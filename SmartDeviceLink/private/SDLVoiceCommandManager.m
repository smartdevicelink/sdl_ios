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
#import "SDLVoiceCommandUpdateOperation.h"

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
@property (copy, nonatomic) NSArray<SDLVoiceCommand *> *currentVoiceCommands;

@end

UInt32 const VoiceCommandIdMin = 1900000000;

@implementation SDLVoiceCommandManager

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _lastVoiceCommandId = VoiceCommandIdMin;
    _voiceCommands = @[];
    _currentVoiceCommands = @[];

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
    _currentVoiceCommands = @[];

    _waitingOnHMIUpdate = NO;
    _currentHMILevel = nil;
    _inProgressUpdate = nil;
    _hasQueuedUpdate = NO;
}

#pragma mark - Setters

- (void)setVoiceCommands:(NSArray<SDLVoiceCommand *> *)voiceCommands {
    if (voiceCommands == self.voiceCommands) {
        SDLLogD(@"New voice commands are equivalent to existing voice commands, skipping...");
        return;
    }

    // Set the ids
    self.lastVoiceCommandId = VoiceCommandIdMin;
    [self sdl_updateIdsOnVoiceCommands:voiceCommands];

    _voiceCommands = voiceCommands;

    [SDLVoiceCommandUpdateOperation *updateOperation = [[SDLVoiceCommandUpdateOperation alloc] initWithConnectionManager:self.connectionManager newVoiceCommands:voiceCommands oldVoiceCommands:_currentVoiceCommands updateCompletionHandler:^(NSError * _Nullable error) {
        // TODO
    }];
}

#pragma mark - Helpers
#pragma mark IDs

- (void)sdl_updateIdsOnVoiceCommands:(NSArray<SDLVoiceCommand *> *)voiceCommands {
    for (SDLVoiceCommand *voiceCommand in voiceCommands) {
        voiceCommand.commandId = self.lastVoiceCommandId++;
    }
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
