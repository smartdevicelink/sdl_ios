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

/// Name of video stream start notification
extern NSString *const SDLVideoStreamDidStartNotification;

/// Name of video stream stop notification
extern NSString *const SDLVideoStreamDidStopNotification;

/// Name of video stream suspended notification
extern NSString *const SDLVideoStreamSuspendedNotification;

/// Name of audio stream start notification
extern NSString *const SDLAudioStreamDidStartNotification;

/// Name of audio stream stop notification
extern NSString *const SDLAudioStreamDidStopNotification;

/// Lockscreen will present notification
extern NSString *const SDLLockScreenManagerWillPresentLockScreenViewController;

/// Lockscreen did present notification
extern NSString *const SDLLockScreenManagerDidPresentLockScreenViewController;

/// Lockscreen will dismiss notification
extern NSString *const SDLLockScreenManagerWillDismissLockScreenViewController;

/// Lockscreen did dismiss notification
extern NSString *const SDLLockScreenManagerDidDismissLockScreenViewController;

/// The current state of the video stream manager
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

/// The current state of the audio stream manager
typedef NSString SDLAudioStreamManagerState;

/// Audio state stopped
extern SDLAudioStreamManagerState *const SDLAudioStreamManagerStateStopped;

/// Audio state starting
extern SDLAudioStreamManagerState *const SDLAudioStreamManagerStateStarting;

/// Audio state ready
extern SDLAudioStreamManagerState *const SDLAudioStreamManagerStateReady;

/// Audio state shutting down
extern SDLAudioStreamManagerState *const SDLAudioStreamManagerStateShuttingDown;

/// Typedef SDLAppState
typedef NSString SDLAppState;

/// App state inactive
extern SDLAppState *const SDLAppStateInactive;

/// App state active
extern SDLAppState *const SDLAppStateActive;

NS_ASSUME_NONNULL_END
