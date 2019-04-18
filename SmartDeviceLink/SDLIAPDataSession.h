//
//  SDLIAPDataSession.h
//  SmartDeviceLink
//
//  Created by Nicole on 4/17/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLIAPSession;

NS_ASSUME_NONNULL_BEGIN

typedef void (^SDLIAPDataSessionRetryCompletionHandler)(BOOL retryEstablishSession);
typedef void (^SDLIAPDataSessionCreateDataReceivedHandler)(NSData *dataIn);

@interface SDLIAPDataSession : NSObject

/**
 *  The communications channel between the app and the SDL enabled accessory.
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
- (instancetype)initWithSession:(nullable SDLIAPSession *)session retrySessionCompletionHandler:(SDLIAPDataSessionRetryCompletionHandler)retrySessionHandler dataReceivedCompletionHandler:(SDLIAPDataSessionCreateDataReceivedHandler)dataReceivedHandler;

/**
 *  Stops a current session.
 */
- (void)stopSession;

@end

NS_ASSUME_NONNULL_END
