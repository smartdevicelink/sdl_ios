//
//  SDLLifecycleMobileHMIStateHandler.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/9/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLLifecycleMobileHMIStateHandler.h"

#import "SDLConnectionManagerType.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCResponseNotification.h"
#import "SDLMsgVersion.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLLifecycleMobileHMIStateHandler ()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;

@end

@implementation SDLLifecycleMobileHMIStateHandler

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerResponseReceived:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];

    return self;
}

- (void)stop {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

/// This method sends an OnHMIStatus with the Mobile's HMI level to the head unit.
/// This was originally designed to make sure that the head unit properly knew about the mobile app's ability to run timers in the background, which affected heartbeat.
/// It may still affect some features on the head unit and the ability for the head unit to know which app is in the foreground is useful. It should not be removed due to unknown backward compatibility issues.
- (void)sdl_sendMobileHMIState {
    __block UIApplicationState appState = UIApplicationStateInactive;
    if ([NSThread isMainThread]) {
        appState = [UIApplication sharedApplication].applicationState;
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            appState = [UIApplication sharedApplication].applicationState;
        });
    }

    SDLOnHMIStatus *hmiStatus = [[SDLOnHMIStatus alloc] init];
    hmiStatus.audioStreamingState = SDLAudioStreamingStateNotAudible;
    hmiStatus.systemContext = SDLSystemContextMain;

    switch (appState) {
        case UIApplicationStateActive: {
            hmiStatus.hmiLevel = SDLHMILevelFull;
        } break;
        case UIApplicationStateBackground: // Fallthrough
        case UIApplicationStateInactive: {
            hmiStatus.hmiLevel = SDLHMILevelBackground;
        } break;
        default: break;
    }

    SDLLogD(@"Mobile UIApplication state changed, sending to remote system: %@", hmiStatus.hmiLevel);
    [self.connectionManager sendConnectionManagerRPC:hmiStatus];
}

#pragma mark - Actions

- (void)registerResponseReceived:(SDLRPCResponseNotification *)notification {
    SDLRegisterAppInterfaceResponse *response = (SDLRegisterAppInterfaceResponse *)notification.response;

    if (response.sdlMsgVersion.majorVersion.unsignedIntegerValue >= 4) {
        [self sdl_sendMobileHMIState];
        // Send SDL updates to application state
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_sendMobileHMIState) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_sendMobileHMIState) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}

@end

NS_ASSUME_NONNULL_END
