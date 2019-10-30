//
//  SDLStreamingMediaManagerConstants.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 2/16/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A flag determining how video and audio streaming should be encrypted
 */
typedef NS_ENUM(NSInteger, SDLStreamingEncryptionFlag) {
    /// It should not be encrypted at all
    SDLStreamingEncryptionFlagNone,

    /// It should use SSL/TLS only to authenticate
    SDLStreamingEncryptionFlagAuthenticateOnly,

    /// All data on these services should be encrypted using SSL/TLS
    SDLStreamingEncryptionFlagAuthenticateAndEncrypt
};

extern NSString *const SDLVideoStreamDidStartNotification;
extern NSString *const SDLVideoStreamDidStopNotification;
extern NSString *const SDLVideoStreamSuspendedNotification;

extern NSString *const SDLAudioStreamDidStartNotification;
extern NSString *const SDLAudioStreamDidStopNotification;

extern NSString *const SDLLockScreenManagerWillPresentLockScreenViewController;
extern NSString *const SDLLockScreenManagerDidPresentLockScreenViewController;
extern NSString *const SDLLockScreenManagerWillDismissLockScreenViewController;
extern NSString *const SDLLockScreenManagerDidDismissLockScreenViewController;

typedef NSString SDLVideoStreamManagerState;
/// Streaming state stopped
extern SDLVideoStreamManagerState *const SDLVideoStreamManagerStateStopped;

/// Streaming state starting
extern SDLVideoStreamManagerState *const SDLVideoStreamManagerStateStarting;

/// Streaming state ready
extern SDLVideoStreamManagerState *const SDLVideoStreamManagerStateReady;

/// Streaming state suspended
extern SDLVideoStreamManagerState *const SDLVideoStreamManagerStateSuspended;

/// Streaming state shutting down
extern SDLVideoStreamManagerState *const SDLVideoStreamManagerStateShuttingDown;

typedef NSString SDLAudioStreamManagerState;
/// Audio state stopped
extern SDLAudioStreamManagerState *const SDLAudioStreamManagerStateStopped;

/// Audio state starting
extern SDLAudioStreamManagerState *const SDLAudioStreamManagerStateStarting;

/// Audio state ready
extern SDLAudioStreamManagerState *const SDLAudioStreamManagerStateReady;

/// Audio state shutting down
extern SDLAudioStreamManagerState *const SDLAudioStreamManagerStateShuttingDown;

typedef NSString SDLAppState;
/// App state inactive
extern SDLAppState *const SDLAppStateInactive;

/// App state active
extern SDLAppState *const SDLAppStateActive;

NS_ASSUME_NONNULL_END
