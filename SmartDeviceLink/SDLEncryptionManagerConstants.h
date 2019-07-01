//
//  SDLEncryptionManagerConstants.h
//  SmartDeviceLink
//
//  Created by standa1 on 6/28/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const SDLEncryptionDidStartNotification;
extern NSString *const SDLEncryptionDidStopNotification;

typedef NSString SDLEncryptionManagerState;
extern SDLEncryptionManagerState *const SDLEncryptionManagerStateStopped;
extern SDLEncryptionManagerState *const SDLEncryptionManagerStateStarting;
extern SDLEncryptionManagerState *const SDLEncryptionManagerStateReady;
extern SDLEncryptionManagerState *const SDLEncryptionManagerStateShuttingDown;

NS_ASSUME_NONNULL_END
