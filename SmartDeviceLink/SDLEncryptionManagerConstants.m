//
//  SDLEncryptionManagerConstants.m
//  SmartDeviceLink
//
//  Created by standa1 on 6/28/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLEncryptionManagerConstants.h"

NSString *const SDLEncryptionDidStartNotification = @"com.sdl.encryptionDidStart";
NSString *const SDLEncryptionDidStopNotification = @"com.sdl.encryptionDidStop";

SDLEncryptionManagerState *const SDLEncryptionManagerStateStopped = @"EncryptionStopped";
SDLEncryptionManagerState *const SDLEncryptionManagerStateStarting = @"EncryptionStarting";
SDLEncryptionManagerState *const SDLEncryptionManagerStateReady = @"EncryptionReady";
SDLEncryptionManagerState *const SDLEncryptionManagerStateShuttingDown = @"EncryptionShuttingDown";
