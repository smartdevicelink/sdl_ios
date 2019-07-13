//
//  SDLEncryptionLifecycleManager.h
//  SmartDeviceLink
//
//  Created by standa1 on 6/27/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLProtocol.h"
#import "SDLConnectionManagerType.h"
#import "SDLEncryptionConfiguration.h"
#import "SDLProtocolListener.h"
#import "SDLPermissionManager.h"

@class SDLProtocol;
@class SDLStateMachine;

NS_ASSUME_NONNULL_BEGIN

@interface SDLEncryptionLifecycleManager : NSObject <SDLProtocolListener>

/**
 *  Whether or not the encryption session is connected.
 */
@property (assign, nonatomic, readonly, getter=isEncryptionReady) BOOL encryptionReady;


- (instancetype)init NS_UNAVAILABLE;

/**
 Create a new encryption lifecycle manager for apps that need an
 
 @param connectionManager The pass-through for RPCs
 @param configuration This session's configuration
 @param permissionManager The permission manager passed in from the proxy that knowledge whether an RPC needs encryption
 @param rpcOperationQueue The RPC operation queue that the encrypted RPC will be sent on
 @return A new encryption lifecycle manager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLEncryptionConfiguration *)configuration permissionManager:(SDLPermissionManager *)permissionManager rpcOperationQueue:(NSOperationQueue *)rpcOperationQueue;

/**
 *  Start the manager. This is used internally to get notified of the ACK message.
 */
- (void)startWithProtocol:(SDLProtocol *)protocol;

/**
 *  Stop the manager. This method is used internally.
 */
- (void)stop;

/**
 *  Send an Encrypted RPC request and set a completion handler that will be called with the response when the response returns.
 *
 *  @param request The RPC request to send
 *  @param handler The handler that will be called when the response returns
 */
- (void)sendEncryptedRequest:(__kindof SDLRPCMessage *)request withResponseHandler:(nullable SDLResponseHandler)handler;

@end

NS_ASSUME_NONNULL_END
