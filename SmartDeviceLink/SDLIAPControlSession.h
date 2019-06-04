//
//  SDLIAPControlSession.h
//  SmartDeviceLink
//
//  Created by Nicole on 4/16/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLIAPSession.h"

@class EAAccessory;

@protocol SDLIAPControlSessionDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 *  The communications channel between the app and the SDL enabled accessory. The control session is used to get the unique protocol string needed to create a session with Core. The control session is only used with legacy head units that do not support the multisession protocol (the multisession protocol allows multiple apps to connect over the same protocol string). A control session is needed because each SDL enabled app needs to connect to the accessory using a unique protocol string.
 *
 *  When the protocol string is received from Core, the control session is closed as a new session with Core must be established with the received protocol string. Core has ~10 seconds to send the protocol string, otherwise the control session is closed and new attempt is made to establish a control session with Core.
 */
@interface SDLIAPControlSession : SDLIAPSession

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Creates a new control session.
 *
 *  @param accessory      The accessory to connect to.
 *  @param delegate     The control session delegate
 *  @return             A SDLIAPControlSession object
 */
- (instancetype)initWithAccessory:(nullable EAAccessory *)accessory delegate:(id<SDLIAPControlSessionDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
