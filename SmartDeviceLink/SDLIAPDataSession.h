//
//  SDLIAPDataSession.h
//  SmartDeviceLink
//
//  Created by Nicole on 4/17/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLIAPSession.h"

@protocol SDLIAPDataSessionDelegate;


NS_ASSUME_NONNULL_BEGIN

@interface SDLIAPDataSession : SDLIAPSession

/**
 *  The unique ID assigned to the session between the app and accessory. If no session exists the value will be 0.
 */
@property (assign, nonatomic, readonly) NSUInteger connectionID;

/**
 *  Returns whether the session has open I/O streams.
 */
@property (assign, nonatomic, readonly, getter=isSessionInProgress) BOOL sessionInProgress;

/**
 *  Returns whether a connection has been established with the accessory.
 */
@property (assign, nonatomic, readonly, getter=isSessionConnected) BOOL sessionConnected;


- (instancetype)init NS_UNAVAILABLE;

/**
 *  Creates a new data session.
 *
 *  @param accessory    The new connected accessory.
 *  @param delegate     The data session delegate
 *  @return             A SDLIAPSession object
 */
- (instancetype)initWithAccessory:(EAAccessory *)accessory delegate:(id<SDLIAPDataSessionDelegate>)delegate forProtocol:(NSString *)protocol;

/**
 *  Starts a data session.
 */
- (void)startSession;

/**
 *  Stops a current session.
 */
- (void)destroySession;

- (void)sendData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
