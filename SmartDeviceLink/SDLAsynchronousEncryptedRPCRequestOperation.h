//
//  SDLAsynchronousEncryptedRPCRequestOperation.h
//  SmartDeviceLink
//
//  Created by standa1 on 6/22/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLAsynchronousOperation.h"
#import "SDLLifecycleManager.h"

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Sends an array Encrypted RPCs of type `Request` asynchronously. Requests must get a response from Core before the operation is considered finished.
 */
@interface SDLAsynchronousEncryptedRPCRequestOperation : SDLAsynchronousOperation

/**
 *  An array of RPCs of type `Request`.
 */
@property (strong, nonatomic) NSArray<SDLRPCRequest *> *requests;

/**
 *  Convenience init for sending one force encrypted request asynchronously.
 *
 *  @param connectionManager    The connection manager used to send the RPCs
 *  @param request              The request to be sent to Core
 *  @param responseHandler      Called when the request has a response from Core
 *  @return                     A SDLAsynchronousRPCRequestOperation object
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager requestToEncrypt:(SDLRPCRequest *)request responseHandler:(nullable SDLResponseHandler)responseHandler;
@end

NS_ASSUME_NONNULL_END
