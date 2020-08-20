//
//  SDLnotificationDispatcher.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/7/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLRPCRequest;
@class SDLRPCResponse;
@class SDLRPCNotification;


NS_ASSUME_NONNULL_BEGIN

/**
 *  The SDLNotificationDispatcher subscribes to SDLProxy notifications through SDLProxyListener and sends out actual NSNotifications with those contents. It can also be told to send out other types of notifications.
 */
@interface SDLNotificationDispatcher : NSObject

/**
 *  Posts a notification with a specified name and object.
 *
 *  @param name     The name of the notification to be dispatched.
 *  @param info     The notification object to be sent in the `userInfo` dictionary.
 */
- (void)postNotificationName:(NSString *)name infoObject:(nullable id)info;

/**
 *  Posts a request from Core with a specified name and request object
 *
 *  @param name     The name of the request to be dispatched
 *  @param request  The request object to be sent in the `userInfo` dictionary
 */
- (void)postRPCRequestNotification:(NSString *)name request:(__kindof SDLRPCRequest *)request;

/**
 *  Posts a response from Core with a specified name and response object
 *
 *  @param name     The name of the response to be dispatched
 *  @param response The response object to be sent in the `userInfo` dictionary
 */
- (void)postRPCResponseNotification:(NSString *)name response:(__kindof SDLRPCResponse *)response;

/**
 *  Posts a notification from Core with a specified name and notification object
 *
 *  @param name             The name of the notification to be dispatched
 *  @param rpcNotification  The notification object to be sent in the `userInfo` dictionary
 */
- (void)postRPCNotificationNotification:(NSString *)name notification:(__kindof SDLRPCNotification *)rpcNotification;

@end

NS_ASSUME_NONNULL_END
