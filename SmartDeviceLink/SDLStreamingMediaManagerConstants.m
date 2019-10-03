//
//  SDLStreamingMediaManagerConstants.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 2/16/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDLStreamingMediaManagerConstants.h"

NSString *const SDLVideoStreamDidStartNotification = @"com.sdl.videoStreamDidStart";
NSString *const SDLVideoStreamDidStopNotification = @"com.sdl.videoStreamDidStop";
NSString *const SDLVideoStreamSuspendedNotification = @"com.sdl.videoStreamSuspended";

NSString *const SDLAudioStreamDidStartNotification = @"com.sdl.audioStreamDidStart";
NSString *const SDLAudioStreamDidStopNotification = @"com.sdl.audioStreamDidStop";

NSString *const SDLLockScreenManagerWillPresentLockScreenViewController = @"com.sdl.lockscreen.willPresent";
NSString *const SDLLockScreenManagerDidPresentLockScreenViewController = @"com.sdl.lockscreen.didPresent";
NSString *const SDLLockScreenManagerWillDismissLockScreenViewController = @"com.sdl.lockscreen.willDismiss";
NSString *const SDLLockScreenManagerDidDismissLockScreenViewController = @"com.sdl.lockscreen.didDismiss";

SDLVideoStreamManagerState *const SDLVideoStreamManagerStateStopped = @"VideoStreamStopped";
SDLVideoStreamManagerState *const SDLVideoStreamManagerStateStarting = @"VideoStreamStarting";
SDLVideoStreamManagerState *const SDLVideoStreamManagerStateReady = @"VideoStreamReady";
SDLVideoStreamManagerState *const SDLVideoStreamManagerStateSuspended = @"VideoStreamSuspended";
SDLVideoStreamManagerState *const SDLVideoStreamManagerStateShuttingDown = @"VideoStreamShuttingDown";

SDLAudioStreamManagerState *const SDLAudioStreamManagerStateStopped = @"AudioStreamStopped";
SDLAudioStreamManagerState *const SDLAudioStreamManagerStateStarting = @"AudioStreamStarting";
SDLAudioStreamManagerState *const SDLAudioStreamManagerStateReady = @"AudioStreamReady";
SDLAudioStreamManagerState *const SDLAudioStreamManagerStateShuttingDown = @"AudioStreamShuttingDown";

SDLAppState *const SDLAppStateInactive = @"AppInactive";
SDLAppState *const SDLAppStateActive = @"AppActive";
