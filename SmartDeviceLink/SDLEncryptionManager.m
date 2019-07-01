//
//  SDLEncryptionManager.m
//  SmartDeviceLink
//
//  Created by standa1 on 6/27/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLProtocol.h"
#import "SDLConnectionManagerType.h"
#import "SDLEncryptionConfiguration.h"
#import "SDLPermissionManager.h"
#import "SDLEncryptionManager.h"
#import "SDLEncryptionLifecycleManager.h"
#import "SDLEncryptionConfiguration.h"
#import "SDLConnectionManagerType.h"

@interface SDLEncryptionManager()

@property (strong, nonatomic) SDLEncryptionLifecycleManager *lifecycleManager;
@property (assign, nonatomic) BOOL encryptionReady;

@end

@implementation SDLEncryptionManager

#pragma mark - Public
#pragma mark Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLEncryptionConfiguration *)configuration permissionManager:(SDLPermissionManager *)permissionManager rpcOperationQueue:(NSOperationQueue *)rpcOperationQueue {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _lifecycleManager = [[SDLEncryptionLifecycleManager alloc] initWithConnectionManager:connectionManager configuration:configuration permissionManager:permissionManager rpcOperationQueue:rpcOperationQueue];
    
    return self;
}

- (void)startWithProtocol:(SDLProtocol *)protocol {
    [self.lifecycleManager startWithProtocol:protocol];
}

- (void)stop {
    [self.lifecycleManager stop];
}

- (void)sendEncryptedRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    [self.lifecycleManager sendEncryptedRequest:(__kindof SDLRPCMessage *)request withResponseHandler:handler];
}

#pragma mark - Getters

- (BOOL)encryptionReady {
    return self.lifecycleManager.isEncryptionReady;
}

@end
