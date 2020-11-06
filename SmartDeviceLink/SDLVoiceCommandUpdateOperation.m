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
@property (strong, nonatomic, nullable) NSArray<SDLVoiceCommand *> *oldVoiceCommands;
@property (assign, nonatomic) UInt32 firstNewVoiceCommandId;
@property (copy, nonatomic) SDLVoiceCommandUpdateCompletionHandler completionHandler;

@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLVoiceCommandUpdateOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager newVoiceCommands:(nullable NSArray<SDLVoiceCommand *> *)newVoiceCommands oldVoiceCommands:(nullable NSArray<SDLVoiceCommand *> *)oldVoiceCommands updateCompletionHandler:(SDLVoiceCommandUpdateCompletionHandler)completionHandler {
    self = [self init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _updatedVoiceCommands = newVoiceCommands;
    _oldVoiceCommands = oldVoiceCommands;
    _completionHandler = completionHandler;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    __weak typeof(self) weakSelf = self;
    [self sdl_sendDeleteCurrentVoiceCommands:^(NSError * _Nullable error) {
        // If any of the deletions failed, don't send the new commands
        if (error != nil) {
            SDLLogD(@"Some voice commands failed to delete; aborting operation");
            weakSelf.internalError = error;
            [weakSelf finishOperation];

            return;
        }

        // If the operation has been canceled, then don't send the new commands
        if (self.isCancelled) {
            [weakSelf finishOperation];
        }

        // If no error, send the new commands
        [weakSelf sdl_sendCurrentVoiceCommands:^(NSError * _Nullable error) {
            if (weakSelf.completionHandler != nil) {
                weakSelf.completionHandler(error);
                [weakSelf finishOperation];
            }
        }];
    }];
}

#pragma mark - Sending RPCs

- (void)sdl_sendDeleteCurrentVoiceCommands:(void(^)(NSError * _Nullable))completionHandler {
    if (self.oldVoiceCommands.count == 0) {
        SDLLogD(@"No voice commands to delete");
        return completionHandler(nil);
    }

    NSArray<SDLRPCRequest *> *deleteVoiceCommands = [self sdl_deleteCommandsForVoiceCommands:self.oldVoiceCommands];

    __block NSMutableDictionary<SDLRPCRequest *, NSError *> *errors = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendRequests:deleteVoiceCommands progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
        if (error != nil) {
            errors[request] = error;
        }
    } completionHandler:^(BOOL success) {
        if (!success) {
            SDLLogE(@"Error deleting old voice commands: %@", errors);
            return completionHandler([NSError sdl_menuManager_failedToUpdateWithDictionary:errors]);
        }

        self.oldVoiceCommands = @[];
        SDLLogD(@"Finished deleting old voice commands");
        return completionHandler(nil);
    }];
}

- (void)sdl_sendCurrentVoiceCommands:(void(^)(NSError * _Nullable))completionHandler {
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
    } completionHandler:^(BOOL success) {
        if (!success) {
            SDLLogE(@"Failed to send main menu commands: %@", errors);
            return completionHandler([NSError sdl_menuManager_failedToUpdateWithDictionary:errors]);
        }

        weakSelf.oldVoiceCommands = weakSelf.updatedVoiceCommands;
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

#pragma mark - Operation Overrides

- (void)finishOperation {
    SDLLogV(@"Finishing text and graphic update operation");
    if (self.isCancelled) {
        self.internalError = [NSError sdl_voiceCommandManager_pendingUpdateSuperseded];
        self.completionHandler(self.error);
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
