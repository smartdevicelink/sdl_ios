//
//  SDLConnectionManagerType.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/21/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLNotificationConstants.h"
#import <Foundation/Foundation.h>

@class SDLRPCRequest;
@class SDLRPCMessage;
@class SDLRegisterAppInterfaceResponse;


NS_ASSUME_NONNULL_BEGIN

@protocol SDLConnectionManagerType <NSObject>

/**
 *  A special method on the connection manager which is used by managers that must bypass the default block on RPC sends before managers complete setup.
 *
 *  @param request The RPC request to be sent to the remote head unit.
 *  @param handler A completion block called when the response is received.
 */
- (void)sendConnectionManagerRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler;

/**
 *  Sends an RPC of type `SDLRPCRequest` without bypassing the block on RPC sends before managers complete setup.
 *
 *  @param request An RPC of type `SDLRPCRequest` be sent to Core.
 *  @param handler Called when the response is received by Core
 */
- (void)sendConnectionRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler;

/**
 *  Sends an RPC of type `SDLRPCResponse` or `SDLRPCNotification` without bypassing the block on RPC sends before managers complete setup. Unlike requests, responses and notifications sent to Core do not get a response from Core, so no handler is needed.
 *
 *  Do not use to send an RPC of type `SDLRPCRequest`. Instead use `sendConnectionRequest:withResponseHandler:` to send a request.
 *
 *  @param rpc An RPC of type `SDLRPCResponse` or `SDLRPCNotification` to be sent to Core.
 */
- (void)sendConnectionRPC:(__kindof SDLRPCMessage *)rpc;

/**
*  Sends an RPC of type `SDLRPCResponse` or `SDLRPCNotification` and bypasses the block on RPC sends before managers complete setup. Unlike requests, responses and notifications sent to Core do not get a response from Core, so no handler is needed.
*
*  Do not use to send an RPC of type `SDLRPCRequest`. Instead use `sendConnectionRequest:withResponseHandler:` to send a request.
*
*  @param rpc An RPC of type `SDLRPCResponse` or `SDLRPCNotification` to be sent to Core.
*/
- (void)sendConnectionManagerRPC:(__kindof SDLRPCMessage *)rpc;

/**
 *  Sends an array of RPCs of type `Request` asynchronously. The requests are sent without bypassing the block on RPC sends before managers complete setup.
 *
 *  @param requests             An array of RPCs of type `Request`
 *  @param progressHandler      The progress handler is called as each request gets a response from Core.
 *  @param completionHandler    The completion handler is called when all requests have a response from Core.
 */
- (void)sendRequests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleAsyncRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler;

/**
 *  Sends an array of RPCs of type `Request` sequentially. The requests are sent without bypassing the block on RPC sends before managers complete setup.
 *
 *  @param requests             An array of RPCs of type `Request`
 *  @param progressHandler      The progress handler is called as each request gets a response from Core.
 *  @param completionHandler    The completion handler is called when all requests have a response from Core.
 */
- (void)sendSequentialRequests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleSequentialRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
