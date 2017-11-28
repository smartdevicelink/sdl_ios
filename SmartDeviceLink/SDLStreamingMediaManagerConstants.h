//
//  SDLStreamingMediaManagerConstants.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 2/16/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SDLStreamingEncryptionFlag) {
    SDLStreamingEncryptionFlagNone,
    SDLStreamingEncryptionFlagAuthenticateOnly,
    SDLStreamingEncryptionFlagAuthenticateAndEncrypt
};

extern CGSize const SDLDefaultScreenSize;

extern NSString *const SDLVideoStreamDidStartNotification;
extern NSString *const SDLVideoStreamDidStopNotification;

extern NSString *const SDLAudioStreamDidStartNotification;
extern NSString *const SDLAudioStreamDidStopNotification;

extern NSString *const SDLLockScreenManagerWillPresentLockScreenViewController;
extern NSString *const SDLLockScreenManagerDidPresentLockScreenViewController;
extern NSString *const SDLLockScreenManagerWillDismissLockScreenViewController;
extern NSString *const SDLLockScreenManagerDidDismissLockScreenViewController;

NS_ASSUME_NONNULL_END
