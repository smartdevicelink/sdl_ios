//
//  SDLSequentialRPCRequestOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/31/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLAsynchronousOperation.h"
#import "SDLLifecycleManager.h"

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Sends an array RPCs of type `Request` with the first RPC to be sent at index 0. Sending is sequential, meaning that once an RPC is sent to Core, the operation waits until a response is received from Core before the next request is sent. Requests must get a response from Core before the operation is considered finished.
 */
@interface SDLSequentialRPCRequestOperation : SDLAsynchronousOperation

/**
 *  Convenience init for sending an array of requests sequentially.
 *
 *  @param connectionManager    The connection manager used to send the RPCs
 *  @param requests             The requests to be sent to Core
 *  @param progressHandler      Called as each request gets a response from Core
 *  @param completionHandler    Called when all requests have a response from Core
 *  @return                     A SDLSequentialRPCRequestOperation object
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager requests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleSequentialRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
