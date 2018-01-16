//
//  SDLnotificationDispatcher.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/7/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLProxyListener.h"

@class SDLRPCResponse;
@class SDLRPCNotification;


NS_ASSUME_NONNULL_BEGIN

/**
 *  The SDLNotificationDispatcher subscribes to SDLProxy notifications through SDLProxyListener and sends out actual NSNotifications with those contents. It can also be told to send out other types of notifications.
 */
@interface SDLNotificationDispatcher : NSObject <SDLProxyListener>

/**
 *  Post a notification with a specified name and object.
 *
 *  @param name The name of the notification to be dispatched.
 *  @param info The object to be send along in the `userInfo` dictionary.
 */
- (void)postNotificationName:(NSString *)name infoObject:(nullable id)info;
- (void)postRPCResponseNotification:(NSString *)name response:(__kindof SDLRPCResponse *)response;
- (void)postRPCNotificationNotification:(NSString *)name notification:(__kindof SDLRPCNotification *)rpcNotification;

@end

NS_ASSUME_NONNULL_END
