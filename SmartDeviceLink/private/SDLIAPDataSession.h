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

@interface SDLIAPDataSession: NSObject <SDLIAPSessionDelegate>

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Returns whether the session has open I/O streams.
 */
@property (assign, nonatomic, readonly, getter=isSessionInProgress) BOOL sessionInProgress;

/**
 *  The unique ID assigned to the session between the app and accessory. If no session exists the value will be 0.
 */
@property (assign, nonatomic, readonly) NSUInteger connectionID;

/**
 *  The accessory with which to open a session.
 */
@property (nullable, strong, nonatomic, readonly) EAAccessory *accessory;
/**
 *  Creates a new data session.
 *
 *  @param accessory    The new connected accessory.
 *  @param delegate     The data session delegate
 *  @return             A SDLIAPSession object
 */
- (instancetype)initWithAccessory:(nullable EAAccessory *)accessory delegate:(id<SDLIAPDataSessionDelegate>)delegate forProtocol:(NSString *)protocol;

/**
 *  Closes the SDLIAPSession used by the SDLIAPControlSession
 */
- (void) closeSession;

/**
 *  Sends data to Core via the data session.
 *
 *  @param data The data to send to Core
 */
- (void)sendData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END

