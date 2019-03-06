//
//  SDLRPCRequestOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/30/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLAsynchronousOperation.h"
#import "SDLLifecycleManager.h"

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Sends an array RPCs of type `Request` asynchronously. Requests must get a response from Core before the operation is considered finished.
 */
@interface SDLAsynchronousRPCRequestOperation : SDLAsynchronousOperation

/**
 *  An array of RPCs of type `Request`.
 */
@property (strong, nonatomic) NSArray<SDLRPCRequest *> *requests;

/**
 *  Convenience init for sending an array of requests asynchronously.
 *
 *  @param connectionManager    The connection manager used to send the RPCs
 *  @param requests             The requests to be sent to Core
 *  @param progressHandler      Called as each request gets a response from Core
 *  @param completionHandler    Called when all requests have a response from Core
 *  @return                     A SDLAsynchronousRPCRequestOperation object
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager requests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleAsyncRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler;

/**
 *  Convenience init for sending one request asynchronously.
 *
 *  @param connectionManager    The connection manager used to send the RPCs
 *  @param request              The request to be sent to Core
 *  @param responseHandler      Called when the request has a response from Core
 *  @return                     A SDLAsynchronousRPCRequestOperation object
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager request:(SDLRPCRequest *)request responseHandler:(nullable SDLResponseHandler)responseHandler;

@end

NS_ASSUME_NONNULL_END
