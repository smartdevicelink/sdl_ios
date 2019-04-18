//
//  SDLIAPControlSession.h
//  SmartDeviceLink
//
//  Created by Nicole on 4/16/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLIAPSessionDelegate.h"

@class EAAccessory;
@class SDLIAPSession;

NS_ASSUME_NONNULL_BEGIN

typedef void (^SDLIAPControlSessionRetryCompletionHandler)(BOOL retryEstablishSession);
typedef void (^SDLIAPControlSessionCreateDataSessionCompletionHandler)(EAAccessory *connectedaccessory, NSString *indexedProtocolString);

/**
 *  A control session is used by to get the unique protocol string needed to create a session with Core. The control session is only used on legacy head units that do not support the multisession protocol which allows multiple apps to connect over the same protocol string. When the protocol string is received from Core, the control session is closed as a new session with Core must be established with the received protocol string. Core has ~10 seconds to send the protocol string, otherwise the control session is closed and new attempt is made to establish a control session with Core.
 */
@interface SDLIAPControlSession : NSObject

/**
 *  Session for getting the protocol string from Core. The protocol string is the protocol used for communication with the accessory.
 */
@property (nullable, strong, nonatomic, readonly) SDLIAPSession *session;

/**
 *  The unique ID assigned to the session between the app and accessory. If no session exists the value will be 0.
 */
@property (assign, nonatomic, readonly) NSUInteger accessoryID;

/**
 *  Returns whether the session has open I/O streams.
 */
@property (assign, nonatomic, readonly, getter=isSessionInProgress) BOOL sessionInProgress;

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Sets a new control session.
 *
 *  @param session                              The new control session
 *  @param retrySessionCompletionHandler        A handler called when the control session failed to be established and a new session should be attempted.
 *  @param createDataSessionCompletionHandler   A handler called when control session is successful and a new session must be established with the recevied protocol string.
 */
- (instancetype)initWithSession:(nullable SDLIAPSession *)session retrySessionCompletionHandler:(SDLIAPControlSessionRetryCompletionHandler)retrySessionHandler createDataSessionCompletionHandler:(SDLIAPControlSessionCreateDataSessionCompletionHandler)createDataSessionHandler;

/**
 *  Stops a current session.
 */
- (void)stopSession;

/**
 *  Starts a timer for the session. Core has ~10 seconds to send the protocol string, otherwise the control session is closed.
 */
- (void)startSessionTimer;

@end

NS_ASSUME_NONNULL_END
