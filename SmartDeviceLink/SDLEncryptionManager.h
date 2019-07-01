//
//  SDLEncryptionManager.h
//  SmartDeviceLink
//
//  Created by standa1 on 6/27/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLProtocol;
@class SDLPermissionManager;
@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

@interface SDLEncryptionManager : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 Create a new streaming media manager for navigation and VPM apps with a specified configuration
 
 @param connectionManager The pass-through for RPCs
 @param configuration This session's configuration
 @return A new streaming manager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLEncryptionConfiguration *)configuration permissionManager:(SDLPermissionManager *)permissionManager rpcOperationQueue:(NSOperationQueue *)rpcOperationQueue NS_DESIGNATED_INITIALIZER;

/**
 *  Start the manager with a completion block that will be called when startup completes. This is used internally. To use an SDLStreamingMediaManager, you should use the manager found on `SDLManager`.
 */
- (void)startWithProtocol:(SDLProtocol *)protocol;

/**
 *  Send an Encrypted RPC request and set a completion handler that will be called with the response when the response returns.
 *
 *  @param request The RPC request to send
 *  @param handler The handler that will be called when the response returns
 */
- (void)sendEncryptedRequest:(SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler NS_SWIFT_NAME(send(encryptedRequest:responseHandler:));

/**
 *  Stop the manager. This method is used internally.
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
