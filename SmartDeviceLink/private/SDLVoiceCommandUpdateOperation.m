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
@property (copy, nonatomic) NSArray<SDLVoiceCommand *> *pendingVoiceCommands;
@property (strong, nonatomic) NSMutableArray<SDLVoiceCommand *> *currentVoiceCommands;
@property (copy, nonatomic) SDLVoiceCommandUpdateCompletionHandler completionHandler;

@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLVoiceCommandUpdateOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager pendingVoiceCommands:(NSArray<SDLVoiceCommand *> *)pendingVoiceCommands oldVoiceCommands:(NSArray<SDLVoiceCommand *> *)oldVoiceCommands updateCompletionHandler:(SDLVoiceCommandUpdateCompletionHandler)completionHandler {
    self = [self init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _pendingVoiceCommands = pendingVoiceCommands;
    _oldVoiceCommands = oldVoiceCommands;
    _currentVoiceCommands = oldVoiceCommands.mutableCopy;
    _completionHandler = completionHandler;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) {
        [self finishOperation];
        return;
    }

    __weak typeof(self) weakSelf = self;
    [self sdl_sendDeleteCurrentVoiceCommands:^{
        // If the operation has been canceled, then don't send the new commands and finish the operation
        if (self.isCancelled) {
            [weakSelf finishOperation];
            return;
        }

        // Send the new commands
        [weakSelf sdl_sendCurrentVoiceCommands:^{
            [weakSelf finishOperation];
        }];
    }];
}

#pragma mark - Sending RPCs

/// Send DeleteCommand RPCs for voice commands that should be deleted
/// @param completionHandler A handler called when all DeleteCommands have completed
- (void)sdl_sendDeleteCurrentVoiceCommands:(void(^)(void))completionHandler {
    if (self.oldVoiceCommands.count == 0) {
        SDLLogD(@"No voice commands to delete");
        return completionHandler();
    }

    NSArray<SDLDeleteCommand *> *deleteVoiceCommands = [self sdl_deleteCommandsForVoiceCommands:self.oldVoiceCommands];
    __block NSMutableDictionary<SDLDeleteCommand *, NSError *> *errors = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendRequests:deleteVoiceCommands progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
        // Add the request to the error dict or remove it from the current voice commands array
        if (error != nil) {
            errors[request] = error;
        } else {
            [weakSelf sdl_removeCurrentVoiceCommandWithCommandId:((SDLDeleteCommand *)request).cmdID.unsignedIntValue];
        }

        SDLLogV(@"Deleting voice commands progress: %f", percentComplete);
    } completionHandler:^(BOOL success) {
        if (!success) {
            SDLLogE(@"Failed to send voice commands: %@", errors.allKeys);
            SDLLogE(@"Failure reasons: %@", errors.allValues);
            weakSelf.internalError = [NSError sdl_menuManager_failedToUpdateWithDictionary:errors];
            return completionHandler();
        }

        SDLLogD(@"Finished deleting old voice commands");
        return completionHandler();
    }];
}

/// Send AddCommand RPCs for voice commands that should be added
/// @param completionHandler A handler called when all AddCommands have completed
- (void)sdl_sendCurrentVoiceCommands:(void(^)(void))completionHandler {
    if (self.pendingVoiceCommands.count == 0) {
        SDLLogD(@"No voice commands to send");
        return completionHandler();
    }

    NSArray<SDLAddCommand *> *addCommandsToSend = [self sdl_addCommandsForVoiceCommands:self.pendingVoiceCommands];
    __block NSMutableDictionary<SDLAddCommand *, NSError *> *errors = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendRequests:addCommandsToSend progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
        // Add the request to the error dict or add it to the current voice commands array
        if (error != nil) {
            errors[request] = error;
        } else {
            [weakSelf.currentVoiceCommands addObject:[weakSelf sdl_pendingVoiceCommandWithCommandId:((SDLAddCommand *)request).cmdID.unsignedIntValue]];
        }

        SDLLogV(@"Sending voice commands progress: %f", percentComplete);
    } completionHandler:^(BOOL success) {
        if (!success) {
            SDLLogE(@"Failed to send voice commands: %@", errors.allKeys);
            SDLLogE(@"Failure reasons: %@", errors.allValues);
            weakSelf.internalError = [NSError sdl_menuManager_failedToUpdateWithDictionary:errors];
            return completionHandler();
        }

        SDLLogD(@"Finished updating voice commands");
        return completionHandler();
    }];
}

#pragma mark - Helpers
#pragma mark Deletes

/// Create DeleteCommand RPCs for passed voice commands
/// @param voiceCommands The voice commands that should be deleted
/// @return The DeleteCommand RPCs for the passed voice commands
- (NSArray<SDLDeleteCommand *> *)sdl_deleteCommandsForVoiceCommands:(NSArray<SDLVoiceCommand *> *)voiceCommands {
    NSMutableArray<SDLDeleteCommand *> *mutableDeletes = [NSMutableArray array];
    for (SDLVoiceCommand *command in voiceCommands) {
        SDLDeleteCommand *delete = [[SDLDeleteCommand alloc] initWithId:command.commandId];
        [mutableDeletes addObject:delete];
    }

    return [mutableDeletes copy];
}

/// Remove a voice command from the array of voice commands if it has no strings
- (void)sdl_removeEmptyVoiceCommands {
    for (SDLVoiceCommand *voiceCommand in self.currentVoiceCommands) {
        if (voiceCommand.voiceCommands.count == 0) {
            [self.currentVoiceCommands removeObject:voiceCommand];
        }
    }
}

#pragma mark Commands

/// Create AddCommand RPCs for passed voice commands
/// @param voiceCommands The voice commands that should be added
/// @return The AddCommand RPCs for the passed voice commands
- (NSArray<SDLAddCommand *> *)sdl_addCommandsForVoiceCommands:(NSArray<SDLVoiceCommand *> *)voiceCommands {
    NSMutableArray<SDLAddCommand *> *mutableCommands = [NSMutableArray array];
    for (SDLVoiceCommand *voiceCommand in voiceCommands) {
        SDLAddCommand *command = [[SDLAddCommand alloc] init];
        command.vrCommands = voiceCommand.voiceCommands;
        command.cmdID = @(voiceCommand.commandId);

        [mutableCommands addObject:command];
    }

    return [mutableCommands copy];
}

#pragma mark - Managing list of commands on head unit

/// Remove a voice command from the array of voice commands on the head unit based on a command id
/// @param commandId The command id to use to remove a voice command
- (void)sdl_removeCurrentVoiceCommandWithCommandId:(UInt32)commandId {
    for (SDLVoiceCommand *voiceCommand in self.currentVoiceCommands) {
        if (voiceCommand.commandId == commandId) {
            [self.currentVoiceCommands removeObject:voiceCommand];
            break;
        }
    }
}

/// Find a voice command in the pending voice command array based on a command id
/// @param commandId The command id to use to find a voice command
- (nullable SDLVoiceCommand *)sdl_pendingVoiceCommandWithCommandId:(UInt32)commandId {
    for (SDLVoiceCommand *voiceCommand in self.pendingVoiceCommands) {
        if (voiceCommand.commandId == commandId) {
            return voiceCommand;
        }
    }

    return nil;
}

#pragma mark - Operation Overrides

- (void)finishOperation {
    SDLLogV(@"Finishing voice command update operation");
    if (self.isCancelled) {
        self.internalError = [NSError sdl_voiceCommandManager_pendingUpdateSuperseded];
    }

    self.completionHandler(self.currentVoiceCommands.copy, self.error);
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
