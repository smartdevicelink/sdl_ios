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
        weakSelf.currentVoiceCommands = currentVoiceCommands;
        if (error != nil) {
            weakSelf.internalError = error;
        }

        // If the operation has been canceled, then don't send the new commands and finish the operation
        if (self.isCancelled) {
            [weakSelf finishOperation];
            return;
        }

        // Send the new commands
        [weakSelf sdl_sendCurrentVoiceCommands:^(NSArray<SDLVoiceCommand *> *currentVoiceCommands, NSError * _Nullable error) {
            if (error != nil) {
                weakSelf.internalError = error;
            }

            weakSelf.currentVoiceCommands = currentVoiceCommands;
            [weakSelf finishOperation];
        }];
    }];
}

#pragma mark - Sending RPCs

- (void)sdl_sendDeleteCurrentVoiceCommands:(SDLVoiceCommandUpdateCompletionHandler)completionHandler {
    if (self.currentVoiceCommands.count == 0) {
        SDLLogD(@"No voice commands to delete");
        return completionHandler(self.currentVoiceCommands, nil);
    }

    NSArray<SDLDeleteCommand *> *deleteVoiceCommands = [self sdl_deleteCommandsForVoiceCommands:self.currentVoiceCommands];
    __block NSMutableDictionary<SDLDeleteCommand *, NSError *> *errors = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendRequests:deleteVoiceCommands progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
        if (error != nil) {
            errors[request] = error;
        }

        SDLLogV(@"Deleting voice commands progress: %f", percentComplete);
    } completionHandler:^(BOOL success) {
        if (!success) {
            SDLLogE(@"Error deleting old voice commands: %@", errors);

            // Not all the voice command deletes succeeded, subtract the ones that did from the voice commands current state
            NSArray<SDLDeleteCommand *> *deletedCommands = [self.class sdl_deleteCommands:deleteVoiceCommands subtractDeleteCommands:errors.allKeys];
            NSArray<SDLVoiceCommand *> *newCurrentVoiceCommands = [self.class sdl_voiceCommands:weakSelf.currentVoiceCommands subtractDeleteCommands:deletedCommands];

            return completionHandler(newCurrentVoiceCommands, [NSError sdl_menuManager_failedToUpdateWithDictionary:errors]);
        } else {
            SDLLogD(@"Finished deleting old voice commands");

            // All the voice command deletes succeeded, subtract them from the voice commands current state
            NSArray<SDLVoiceCommand *> *newCurrentVoiceCommands = [self.class sdl_voiceCommands:weakSelf.currentVoiceCommands subtractDeleteCommands:deleteVoiceCommands];
            return completionHandler(newCurrentVoiceCommands, nil);
        }
    }];
}

- (void)sdl_sendCurrentVoiceCommands:(SDLVoiceCommandUpdateCompletionHandler)completionHandler {
    if (self.updatedVoiceCommands.count == 0) {
        SDLLogD(@"No voice commands to send");
        return completionHandler(self.currentVoiceCommands, nil);
    }

    NSArray<SDLAddCommand *> *addCommandsToSend = [self sdl_addCommandsForVoiceCommands:self.updatedVoiceCommands];
    __block NSMutableDictionary<SDLAddCommand *, NSError *> *errors = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendRequests:addCommandsToSend progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
        if (error != nil) {
            errors[request] = error;
        }

        SDLLogV(@"Sending voice commands progress: %f", percentComplete);
    } completionHandler:^(BOOL success) {
        NSArray<SDLVoiceCommand *> *newCurrentVoiceCommands = [self.class sdl_voiceCommands:weakSelf.currentVoiceCommands addVoiceCommandsFrom:weakSelf.updatedVoiceCommands basedOnUnsuccessfulAddCommands:errors.allKeys];

        if (!success) {
            SDLLogE(@"Failed to send main menu commands: %@", errors);
            return completionHandler(newCurrentVoiceCommands, [NSError sdl_menuManager_failedToUpdateWithDictionary:errors]);
        } else {
            SDLLogD(@"Finished updating voice commands");
            return completionHandler(newCurrentVoiceCommands, nil);
        }
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
        [mutableCommands addObject:[self sdl_addCommandForVoiceCommand:command]];
    }

    return [mutableCommands copy];
}

- (SDLAddCommand *)sdl_addCommandForVoiceCommand:(SDLVoiceCommand *)voiceCommand {
    SDLAddCommand *command = [[SDLAddCommand alloc] init];
    command.vrCommands = voiceCommand.voiceCommands;
    command.cmdID = @(voiceCommand.commandId);

    return command;
}

#pragma mark - Managing list of commands on head unit

+ (NSArray<SDLVoiceCommand *> *)sdl_voiceCommands:(NSArray<SDLVoiceCommand *> *)voiceCommands subtractDeleteCommands:(NSArray<SDLDeleteCommand *> *)deleteCommands {
    NSMutableArray<SDLVoiceCommand *> *mutableOldVoiceCommands = [voiceCommands mutableCopy];

    // Remove unsuccessful delete commands
    for (SDLDeleteCommand *deleteCommand in deleteCommands) {
        for (SDLVoiceCommand *voiceCommand in mutableOldVoiceCommands) {
            if (voiceCommand.commandId == deleteCommand.cmdID.unsignedIntValue) {
                [mutableOldVoiceCommands removeObject:voiceCommand];
                break;
            }
        }
    }

    return [mutableOldVoiceCommands copy];
}

+ (NSArray<SDLDeleteCommand *> *)sdl_deleteCommands:(NSArray<SDLDeleteCommand *> *)deleteCommands subtractDeleteCommands:(NSArray<SDLDeleteCommand *> *)subtractCommands {
    NSMutableArray<SDLDeleteCommand *> *mutableDeleteCommands = deleteCommands.mutableCopy;
    [mutableDeleteCommands removeObjectsInArray:subtractCommands];

    return [mutableDeleteCommands copy];
}

+ (NSArray<SDLVoiceCommand *> *)sdl_voiceCommands:(NSArray<SDLVoiceCommand *> *)voiceCommands addVoiceCommandsFrom:(NSArray<SDLVoiceCommand *> *)updatedVoiceCommands basedOnUnsuccessfulAddCommands:(NSArray<SDLAddCommand *> *)unsuccessfulAddCommands {
    NSMutableArray<SDLVoiceCommand *> *mutableVoiceCommands = [voiceCommands mutableCopy];
    NSMutableArray<SDLVoiceCommand *> *mutableUpdatedVoiceCommands = [updatedVoiceCommands mutableCopy];

    // Remove unsuccessful updated voice commands
    for (SDLAddCommand *unsuccessfulAddCommand in unsuccessfulAddCommands) {
        for (SDLVoiceCommand *updatedVoiceCommand in mutableUpdatedVoiceCommands) {
            if (updatedVoiceCommand.commandId == unsuccessfulAddCommand.cmdID.unsignedIntValue) {
                [mutableUpdatedVoiceCommands removeObject:updatedVoiceCommand];
                break;
            }
        }
    }

    [mutableVoiceCommands addObjectsFromArray:mutableUpdatedVoiceCommands];
    return [mutableVoiceCommands copy];
}

#pragma mark - Operation Overrides

- (void)finishOperation {
    SDLLogV(@"Finishing text and graphic update operation");
    if (self.isCancelled) {
        self.internalError = [NSError sdl_voiceCommandManager_pendingUpdateSuperseded];
        self.completionHandler(self.currentVoiceCommands, self.error);
    } else {
        self.completionHandler(self.currentVoiceCommands, nil);
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
