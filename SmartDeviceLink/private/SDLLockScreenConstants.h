//
//  SDLLockScreenConstants.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 9/4/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

/// Describes the status of the lock screen
typedef NS_ENUM(NSUInteger, SDLLockScreenStatus) {
    SDLLockScreenStatusOff, // LockScreen is not required
    SDLLockScreenStatusOptional, // LockScreen is optional
    SDLLockScreenStatusRequired // LockScreen is required
};

NS_ASSUME_NONNULL_END
