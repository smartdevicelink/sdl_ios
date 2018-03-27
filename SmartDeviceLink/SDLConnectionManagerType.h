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
 Send an RPC without bypassing the block on RPC sends before managers complete setup.

 @param request The RPC request to be sent to the remote head unit.
 @param handler A completion block called when the response is received.
 */
- (void)sendConnectionRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler;

@end

NS_ASSUME_NONNULL_END
