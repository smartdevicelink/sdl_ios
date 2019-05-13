//
//  SDLIAPDataSession.h
//  SmartDeviceLink
//
//  Created by Nicole on 4/17/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLIAPSession;

@protocol SDLIAPDataSessionDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface SDLIAPDataSession : NSObject

/**
 *  The communications channel between the app and the SDL enabled accessory.
 */
@property (nullable, strong, nonatomic, readonly) SDLIAPSession *session;

/**
 *  The unique ID assigned to the session between the app and accessory. If no session exists the value will be 0.
 */
@property (assign, nonatomic, readonly) NSUInteger connectionID;

/**
 *  Returns whether the session has open I/O streams.
 */
@property (assign, nonatomic, readonly, getter=isSessionInProgress) BOOL sessionInProgress;

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Creates a new data session.
 *
 *  @param session      The new data session. If a `nil` session is passed, the delegate will be notified that it should attempt to establish a new data session.
 *  @param delegate     The data session delegate
 *  @return             A SDLIAPSession object
 */
- (instancetype)initWithSession:(nullable SDLIAPSession *)session delegate:(id<SDLIAPDataSessionDelegate>)delegate;

/**
 *  Starts a data session.
 */
- (void)startSession;

/**
 *  Stops a current session.
 */
- (void)stopSession;

@end

NS_ASSUME_NONNULL_END
