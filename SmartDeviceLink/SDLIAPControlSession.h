//
//  SDLIAPControlSession.h
//  SmartDeviceLink
//
//  Created by Nicole on 4/16/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLIAPSession;
@class EAAccessory;

@protocol SDLIAPControlSessionDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 *  The communications channel between the app and the SDL enabled accessory. The control session is used to get the unique protocol string needed to create a session with Core. The control session is only used with legacy head units that do not support the multisession protocol (the multisession protocol allows multiple apps to connect over the same protocol string). A control session is needed because each SDL enabled app needs to connect to the accessory using a unique protocol string.
 *
 *  When the protocol string is received from Core, the control session is closed as a new session with Core must be established with the received protocol string. Core has ~10 seconds to send the protocol string, otherwise the control session is closed and new attempt is made to establish a control session with Core.
 */
@interface SDLIAPControlSession : NSObject

/**
 *  Session for getting the protocol string from Core. The protocol string is the protocol used for communication with the accessory.
 */
@property (nullable, strong, nonatomic, readonly) SDLIAPSession *session;

/**
 *  The unique ID assigned to the session between the app and accessory. If no session exists the `connectionID` will be 0.
 */
@property (assign, nonatomic, readonly) NSUInteger connectionID;

/**
 *  Returns whether the session has open I/O streams.
 */
@property (assign, nonatomic, readonly, getter=isSessionInProgress) BOOL sessionInProgress;

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Creates a new control session.
 *
 *  @param session      The new control session. If a `nil` session is passed, the delegate will be notified that it should attempt to establish a new control session.
 *  @param delegate     The control session delegate
 *  @return             A SDLIAPControlSession object
 */
- (instancetype)initWithSession:(nullable SDLIAPSession *)session delegate:(id<SDLIAPControlSessionDelegate>)delegate;

/**
 *  Starts a control session.
 */
- (void)startSession;

/**
 *  Stops the current control session if it is open.
 */
- (void)stopSession;

/**
 *  Starts a timer for the session. Core has ~10 seconds to send the protocol string, otherwise the control session is closed and the delegate will be notified that it should attempt to establish a new control session.
 */
- (void)startSessionTimer;

@end

NS_ASSUME_NONNULL_END
