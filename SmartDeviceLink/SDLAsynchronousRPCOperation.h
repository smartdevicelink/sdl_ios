//
//  SDLAsynchronousRPCOperation.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/20/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLAsynchronousOperation.h"
#import "SDLLifecycleManager.h"

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Sends an RPC of type `Response` or `Notification`. Since these RPCs do not get a response from Core, the operation is considered finished as soon as the RPC is sent. RPCs of type `Request` can not be sent using this operation as `Request`s must get a response from Core before the operation is considered finished. To send `Requests` use the `SDLAsynchronousRPCRequestOperation` or the `SDLSequentialRPCRequestOperation`
 */
@interface SDLAsynchronousRPCOperation : SDLAsynchronousOperation

/**
 *  An RPC of type `SDLRPCResponse` or `SDLRPCNotification`.
 */
@property (copy, nonatomic) __kindof SDLRPCMessage *rpc;

/**
 *  Convenience init.
 *
 *  @param connectionManager    The connection manager used to send the RPC
 *  @param rpc                  An RPC of type `SDLRPCResponse` or `SDLRPCNotification` to be sent by the connection manager.
 *  @return                     A SDLAsynchronousRPCOperation object
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager rpc:(__kindof SDLRPCMessage *)rpc;

@end

NS_ASSUME_NONNULL_END
