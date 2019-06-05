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

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Creates a new data session.
 *
 *  @param accessory    The new connected accessory.
 *  @param delegate     The data session delegate
 *  @return             A SDLIAPSession object
 */
- (instancetype)initWithAccessory:(nullable EAAccessory *)accessory delegate:(id<SDLIAPDataSessionDelegate>)delegate forProtocol:(NSString *)protocol;

/**
 *  Sends data to Core via the data session.
 *
 *  @param data The data to send to Core
 */
- (void)sendData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
