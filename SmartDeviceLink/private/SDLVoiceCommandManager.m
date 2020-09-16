//
//  SDLVoiceCommandManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLVoiceCommandManager.h"

#import "SDLAddCommand.h"
#import "SDLConnectionManagerType.h"
#import "SDLDeleteCommand.h"
#import "SDLError.h"
#import "SDLHMILevel.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLOnCommand.h"
#import "SDLOnHMIStatus.h"
#import "SDLPredefinedWindows.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCRequest.h"
#import "SDLVoiceCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLVoiceCommand()

@property (assign, nonatomic) UInt32 commandId;

@end

@interface SDLVoiceCommandManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;

@property (assign, nonatomic) BOOL waitingOnHMIUpdate;
@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;

@property (strong, nonatomic, nullable) NSArray<SDLRPCRequest *> *inProgressUpdate;
@property (assign, nonatomic) BOOL hasQueuedUpdate;

@property (assign, nonatomic) UInt32 lastVoiceCommandId;
@property (copy, nonatomic) NSArray<SDLVoiceCommand *> *oldVoiceCommands;

@end

UInt32 const VoiceCommandIdMin = 1900000000;

@implementation SDLVoiceCommandManager

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _lastVoiceCommandId = VoiceCommandIdMin;
    _voiceCommands = @[];
    _oldVoiceCommands = @[];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiStatusNotification:) name:SDLDidChangeHMIStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_commandNotification:) name:SDLDidReceiveCommandNotification object:nil];

    return self;
}

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager {
    self = [self init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;

    return self;
}

- (void)stop {
    _lastVoiceCommandId = VoiceCommandIdMin;
    _voiceCommands = @[];
    _oldVoiceCommands = @[];

    _waitingOnHMIUpdate = NO;
    _currentHMILevel = nil;
    _inProgressUpdate = nil;
    _hasQueuedUpdate = NO;
}

#pragma mark - Setters

- (void)setVoiceCommands:(NSArray<SDLVoiceCommand *> *)voiceCommands {
    if (self.currentHMILevel == nil || [self.currentHMILevel isEqualToEnum:SDLHMILevelNone]) {
        self.waitingOnHMIUpdate = YES;
        return;
    }

    self.waitingOnHMIUpdate = NO;

    // Set the ids
    self.lastVoiceCommandId = VoiceCommandIdMin;
    [self sdl_updateIdsOnVoiceCommands:voiceCommands];

    _oldVoiceCommands = _voiceCommands;
    _voiceCommands = voiceCommands;

    [self sdl_updateWithCompletionHandler:nil];
}

#pragma mark - Updating System

- (void)sdl_updateWithCompletionHandler:(nullable SDLMenuUpdateCompletionHandler)completionHandler {
    if (self.currentHMILevel == nil || [self.currentHMILevel isEqualToEnum:SDLHMILevelNone]) {
        self.waitingOnHMIUpdate = YES;
        return;
    }

    if (self.inProgressUpdate != nil) {
        // There's an in progress update, we need to put this on hold
        self.hasQueuedUpdate = YES;
        return;
    }

    __weak typeof(self) weakself = self;
    [self sdl_sendDeleteCurrentVoiceCommands:^(NSError * _Nullable error) {
        [weakself sdl_sendCurrentVoiceCommands:^(NSError * _Nullable error) {
            weakself.inProgressUpdate = nil;

            if (completionHandler != nil) {
                completionHandler(error);
            }

            if (weakself.hasQueuedUpdate) {
                [weakself sdl_updateWithCompletionHandler:nil];
                weakself.hasQueuedUpdate = NO;
            }
        }];
    }];
}

#pragma mark Delete Old Menu Items

- (void)sdl_sendDeleteCurrentVoiceCommands:(SDLMenuUpdateCompletionHandler)completionHandler {
    if (self.oldVoiceCommands.count == 0) {
        completionHandler(nil);

        return;
    }

    NSArray<SDLRPCRequest *> *deleteVoiceCommands = [self sdl_deleteCommandsForVoiceCommands:self.oldVoiceCommands];
    self.oldVoiceCommands = @[];
    [self.connectionManager sendRequests:deleteVoiceCommands progressHandler:nil completionHandler:^(BOOL success) {
        if (!success) {
            SDLLogE(@"Error deleting old voice commands");
        } else {
            SDLLogD(@"Finished deleting old voice commands");
        }

        completionHandler(nil);
    }];
}

#pragma mark Send New Menu Items

- (void)sdl_sendCurrentVoiceCommands:(SDLMenuUpdateCompletionHandler)completionHandler {
    if (self.voiceCommands.count == 0) {
        SDLLogD(@"No voice commands to send");
        completionHandler(nil);

        return;
    }

    self.inProgressUpdate = [self sdl_addCommandsForVoiceCommands:self.voiceCommands];

    __block NSMutableDictionary<SDLRPCRequest *, NSError *> *errors = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendRequests:self.inProgressUpdate progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
        if (error != nil) {
            errors[request] = error;
        }
    } completionHandler:^(BOOL success) {
        if (!success) {
            SDLLogE(@"Failed to send main menu commands: %@", errors);
            completionHandler([NSError sdl_menuManager_failedToUpdateWithDictionary:errors]);
            return;
        }

        SDLLogD(@"Finished updating voice commands");
        weakSelf.oldVoiceCommands = weakSelf.voiceCommands;
        completionHandler(nil);
    }];
}

#pragma mark - Helpers

#pragma mark IDs

- (void)sdl_updateIdsOnVoiceCommands:(NSArray<SDLVoiceCommand *> *)voiceCommands {
    for (SDLVoiceCommand *voiceCommand in voiceCommands) {
        voiceCommand.commandId = self.lastVoiceCommandId++;
    }
}

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

#pragma mark - Observers

- (void)sdl_commandNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnCommand *onCommand = (SDLOnCommand *)notification.notification;

    for (SDLVoiceCommand *voiceCommand in self.voiceCommands) {
        if (onCommand.cmdID.unsignedIntegerValue != voiceCommand.commandId) { continue; }

        voiceCommand.handler();
        break;
    }
}

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus *)notification.notification;
    
    if (hmiStatus.windowID != nil && hmiStatus.windowID.integerValue != SDLPredefinedWindowsDefaultWindow) {
        return;
    }
    
    SDLHMILevel oldHMILevel = self.currentHMILevel;
    self.currentHMILevel = hmiStatus.hmiLevel;

    // Auto-send an updated show if we were in NONE and now we are not
    if ([oldHMILevel isEqualToEnum:SDLHMILevelNone] && ![self.currentHMILevel isEqualToEnum:SDLHMILevelNone]) {
        if (self.waitingOnHMIUpdate) {
            [self setVoiceCommands:_voiceCommands];
        } else {
            [self sdl_updateWithCompletionHandler:nil];
        }
    }
}

@end

NS_ASSUME_NONNULL_END
