//
//  SDLVoiceCommandUpdateOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 11/6/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLVoiceCommandUpdateOperation.h"

#import "SDLAddCommand.h"
#import "SDLConnectionManagerType.h"
#import "SDLDeleteCommand.h"
#import "SDLError.h"
#import "SDLLogMacros.h"
#import "SDLVoiceCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLVoiceCommand()
@property (assign, nonatomic) UInt32 commandId;
@end

@interface SDLVoiceCommandUpdateOperation ()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (strong, nonatomic, nullable) NSArray<SDLVoiceCommand *> *updatedVoiceCommands;
@property (strong, nonatomic, nullable) NSArray<SDLVoiceCommand *> *currentVoiceCommands;
@property (copy, nonatomic) SDLVoiceCommandUpdateCompletionHandler completionHandler;

@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLVoiceCommandUpdateOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager newVoiceCommands:(nullable NSArray<SDLVoiceCommand *> *)newVoiceCommands oldVoiceCommands:(nullable NSArray<SDLVoiceCommand *> *)oldVoiceCommands updateCompletionHandler:(SDLVoiceCommandUpdateCompletionHandler)completionHandler {
    self = [self init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _updatedVoiceCommands = newVoiceCommands;
    _currentVoiceCommands = oldVoiceCommands;
    _completionHandler = completionHandler;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    __weak typeof(self) weakSelf = self;
    [self sdl_sendDeleteCurrentVoiceCommands:^(NSArray<SDLVoiceCommand *> *currentVoiceCommands, NSError * _Nullable error) {
        // If any of the deletions failed, don't send the new commands
        if (error != nil) {
            SDLLogE(@"Some voice commands failed to delete; going to attempt to set new voice commands");
            weakSelf.internalError = error;
            return;
        }

        // If the operation has been canceled, then don't send the new commands
        if (self.isCancelled) {
            [weakSelf finishOperation];
        }

        // If no error, send the new commands
        [weakSelf sdl_sendCurrentVoiceCommands:^(NSArray<SDLVoiceCommand *> *currentVoiceCommands, NSError * _Nullable error) {
            SDLLogE(@"Some voice commands failed to send; aborting operation");
            if (weakSelf.completionHandler != nil) {
                weakSelf.completionHandler(error);
                [weakSelf finishOperation];
            }
        }];
    }];
}

#pragma mark - Sending RPCs

- (void)sdl_sendDeleteCurrentVoiceCommands:(SDLVoiceCommandUpdateCompletionHandler)completionHandler {
    if (self.currentVoiceCommands.count == 0) {
        SDLLogD(@"No voice commands to delete");
        return completionHandler(self.currentVoiceCommands, nil);
    }

    NSArray<SDLRPCRequest *> *deleteVoiceCommands = [self sdl_deleteCommandsForVoiceCommands:self.currentVoiceCommands];
    __block NSMutableDictionary<SDLRPCRequest *, NSError *> *errors = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendRequests:deleteVoiceCommands progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
        if (error != nil) {
            firstRunErrors[request] = error;
        }

        SDLLogV(@"Deleting voice commands progress: %f", percentComplete);
    } completionHandler:^(BOOL success) {
        if (!success) {
            SDLLogE(@"Error deleting old voice commands: %@", errors);

            // Not all the voice command deletes succeeded, subtract the ones that did from the voice commands current state
            NSArray<SDLDeleteCommand *> *deletedCommands = [self.class sdl_deleteCommands:deleteVoiceCommands subtractDeleteCommands:errors.allKeys];
            [self sdl_voiceCommandsSubtractDeleteCommands:deletedCommands];

            return completionHandler(nil);
        } else {
            SDLLogD(@"Finished deleting old voice commands");

            // All the voice command deletes succeeded, subtract them from the voice commands current state
            [self sdl_voiceCommandsSubtractDeleteCommands:deleteVoiceCommands];
            return completionHandler(nil);
        }
    }];
}

- (void)sdl_sendCurrentVoiceCommands:(void(^)(SDLVoiceCommandUpdateCompletionHandler))completionHandler {
    if (self.updatedVoiceCommands.count == 0) {
        SDLLogD(@"No voice commands to send");
        return completionHandler(nil);
    }

    NSArray<SDLAddCommand *> *addCommandsToSend = [self sdl_addCommandsForVoiceCommands:self.updatedVoiceCommands];

    __block NSMutableDictionary<SDLRPCRequest *, NSError *> *errors = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendRequests:addCommandsToSend progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
        if (error != nil) {
            errors[request] = error;
        }

        SDLLogV(@"Sending voice commands progress: %f", percentComplete);
    } completionHandler:^(BOOL success) {
        if (!success) {
            SDLLogE(@"Failed to send main menu commands: %@", errors);
            return completionHandler([NSError sdl_menuManager_failedToUpdateWithDictionary:errors]);
        }

        weakSelf.currentVoiceCommands = weakSelf.updatedVoiceCommands; // TODO: This needs to happen if some succeed
        SDLLogD(@"Finished updating voice commands");
        return completionHandler(nil);
    }];
}

#pragma mark - Helpers
#pragma mark Deletes

- (NSArray<SDLDeleteCommand *> *)sdl_deleteCommandsForVoiceCommands:(NSArray<SDLVoiceCommand *> *)voiceCommands {
    NSMutableArray<SDLDeleteCommand *> *mutableDeletes = [NSMutableArray array];
    for (SDLVoiceCommand *command in voiceCommands) {
        SDLDeleteCommand *delete = [[SDLDeleteCommand alloc] initWithId:command.commandId];
        [mutableDeletes addObject:delete];
    }

    return [mutableDeletes copy];
}

#pragma mark Commands

- (NSArray<SDLAddCommand *> *)sdl_addCommandsForVoiceCommands:(NSArray<SDLVoiceCommand *> *)voiceCommands {
    NSMutableArray<SDLAddCommand *> *mutableCommands = [NSMutableArray array];
    for (SDLVoiceCommand *command in voiceCommands) {
        [mutableCommands addObject:[self sdl_commandForVoiceCommand:command]];
    }

    return [mutableCommands copy];
}

- (SDLAddCommand *)sdl_commandForVoiceCommand:(SDLVoiceCommand *)voiceCommand {
    SDLAddCommand *command = [[SDLAddCommand alloc] init];
    command.vrCommands = voiceCommand.voiceCommands;
    command.cmdID = @(voiceCommand.commandId);

    return command;
}

#pragma mark - Managing list of commands on head unit

- (void)sdl_voiceCommandsSubtractDeleteCommands:(NSArray<SDLDeleteCommand *> *)deleteCommands {
    NSMutableArray<SDLVoiceCommand *> *mutableOldVoiceCommands = [self.currentVoiceCommands mutableCopy];
    for (SDLDeleteCommand *deleteCommand in deleteCommands) {
        for (SDLVoiceCommand *voiceCommand in mutableOldVoiceCommands) {
            if (voiceCommand.commandId == deleteCommand.cmdID.unsignedIntValue) {
                [mutableOldVoiceCommands removeObject:voiceCommand];
                break;
            }
        }
    }
}

+ (NSArray<SDLDeleteCommand *> *)sdl_deleteCommands:(NSArray<SDLDeleteCommand *> *)deleteCommands subtractDeleteCommands:(NSArray<SDLDeleteCommand *> *)subtractCommands {
    NSMutableArray<SDLDeleteCommand *> *mutableDeleteCommands = deleteCommands.mutableCopy;
    [mutableDeleteCommands removeObjectsInArray:subtractCommands];

    return [mutableDeleteCommands copy];
}

- (void)sdl_voiceCommandsAddAddCommands:(NSArray<SDLAddCommand *> *)addCommands {

}

#pragma mark - Operation Overrides

- (void)finishOperation {
    SDLLogV(@"Finishing text and graphic update operation");
    if (self.isCancelled) {
        self.internalError = [NSError sdl_voiceCommandManager_pendingUpdateSuperseded];
        self.completionHandler(self.currentVoiceCommands, self.error);
    }

    [super finishOperation];
}

- (nullable NSString *)name {
    return @"com.sdl.voicecommand.update";
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (nullable NSError *)error {
    return self.internalError;
}

@end

NS_ASSUME_NONNULL_END
