//
//  SDLEncryptionLifecycleManager.h
//  SmartDeviceLink
//
//  Created by standa1 on 6/27/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLConnectionManagerType.h"
#import "SDLProtocolDelegate.h"

@class SDLConfiguration;
@class SDLProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface SDLEncryptionLifecycleManager : NSObject <SDLProtocolDelegate>

/**
 *  Whether or not the encryption session is connected.
 */
@property (assign, nonatomic, readonly, getter=isEncryptionReady) BOOL encryptionReady;


- (instancetype)init NS_UNAVAILABLE;

/**
 Create a new encryption lifecycle manager for apps that need encryption.
 
 @param connectionManager The pass-through for RPCs
 @param configuration This session's configuration
 @return A new encryption lifecycle manager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLConfiguration *)configuration;

/**
 *  Start the manager. This is used internally to get notified of the ACK message.
 */
- (void)startWithProtocol:(SDLProtocol *)protocol;

/**
 *  Stop the manager. This method is used internally.
 */
- (void)stop;

/**
 *  Check whether or not an RPC needs encryption.
 */
- (BOOL)rpcRequiresEncryption:(__kindof SDLRPCMessage *)rpc;

/**
 *  Attempt to manually start a secure service.
 */
- (void)startEncryptionService;

@end

NS_ASSUME_NONNULL_END
