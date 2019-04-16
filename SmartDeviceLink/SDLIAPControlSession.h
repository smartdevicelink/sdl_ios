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

extern NSString *const ControlProtocolString;
extern NSString *const IndexedProtocolStringPrefix;

/**
 *  Session for establishing a connection with Core. Once the connection has been established, the session is closed and a session is established. A `controlSession` is not needed if the  head unit supports the multisession protocol string.
 */
@interface SDLIAPControlSession : NSObject

@property (nullable, strong, nonatomic, readonly) SDLIAPSession *session;
@property (assign, nonatomic, readonly) NSUInteger accessoryID;

+ (nullable SDLIAPSession *)createSessionWithAccessory:(EAAccessory *)accessory;

- (void)setSession:(nullable SDLIAPSession *)session delegate:(id<SDLIAPSessionDelegate>)delegate retryCompletionHandler:(SDLIAPControlSessionRetryCompletionHandler)retryCompletionHandler createDataSessionCompletionHandler:(SDLIAPControlSessionCreateDataSessionCompletionHandler)createDataSessionCompletionHandler;
- (void)destroySession;

@end

NS_ASSUME_NONNULL_END
