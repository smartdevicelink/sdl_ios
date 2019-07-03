//
//  SDLEncryptionLifecycleManager.m
//  SmartDeviceLink
//
//  Created by standa1 on 6/27/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLEncryptionLifecycleManager.h"
#import "SDLEncryptionManagerConstants.h"
#import "SDLLogMacros.h"
#import "SDLStateMachine.h"
#import "SDLAsynchronousEncryptedRPCRequestOperation.h"
#import "SDLProtocolMessage.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLOnHMIStatus.h"

@interface SDLEncryptionLifecycleManager() <SDLProtocolListener>

@property (strong, nonatomic, readonly) NSOperationQueue *rpcOperationQueue;
@property (strong, nonatomic, readonly) SDLPermissionManager *permissionManager;
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLProtocol *protocol;

@property (strong, nonatomic, readwrite) SDLStateMachine *encryptionStateMachine;
@property (copy, nonatomic, nullable) SDLHMILevel hmiLevel;

@end

@implementation SDLEncryptionLifecycleManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLEncryptionConfiguration *)configuration permissionManager:(SDLPermissionManager *)permissionManager rpcOperationQueue:(NSOperationQueue *)rpcOperationQueue {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    SDLLogV(@"Creating EncryptionLifecycleManager");
    _hmiLevel = SDLHMILevelNone;
    _connectionManager = connectionManager;
    _permissionManager = permissionManager;
    _rpcOperationQueue = rpcOperationQueue;
    _encryptionStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLEncryptionManagerStateStopped states:[self.class sdl_encryptionStateTransitionDictionary]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiStatusDidChange:) name:SDLDidChangeHMIStatusNotification object:nil];

    return self;
}

- (void)startWithProtocol:(SDLProtocol *)protocol {
    _protocol = protocol;
    
    @synchronized(self.protocol.protocolDelegateTable) {
        if (![self.protocol.protocolDelegateTable containsObject:self]) {
            [self.protocol.protocolDelegateTable addObject:self];
        }
    }
    
    [self sdl_startEncryptionService];
}

- (void)stop {
    _hmiLevel = SDLHMILevelNone;
    _protocol = nil;
    
    SDLLogD(@"Stopping encryption manager");
    [self sdl_stopEncryptionService];
}

- (void)sendEncryptedRequest:(SDLRPCRequest *)request withResponseHandler:(SDLResponseHandler)handler {
    if (!self.protocol || !self.isEncryptionReady) {
        SDLLogV(@"Encryption manager is not yet ready, wait until after proxy is opened");
        return;
    }
    
    SDLAsynchronousEncryptedRPCRequestOperation *op = [[SDLAsynchronousEncryptedRPCRequestOperation alloc] initWithConnectionManager:self.connectionManager requestToEncrypt:request responseHandler:handler];
    
    [self.rpcOperationQueue addOperation:op];
}

- (BOOL)isEncryptionReady {
    return [self.encryptionStateMachine isCurrentState:SDLEncryptionManagerStateReady];
}

- (void)sdl_startEncryptionService {
    SDLLogV(@"Attempting to start Encryption Service");
    if (!self.protocol) {
        SDLLogV(@"Encryption manager is not yet started");
        return;
    }

    if (!self.permissionManager || !self.permissionManager.currentHMILevel || !self.permissionManager.permissions) {
        SDLLogV(@"Permission Manager is not ready to encrypt.");
        return;
    }
    
    // TODO: check if permissionManager has requireEncyrption flag in any RPC or itself
    if (![self.permissionManager.currentHMILevel isEqualToEnum:SDLHMILevelNone]) {
        [self.encryptionStateMachine transitionToState:SDLEncryptionManagerStateStarting];
    } else {
        SDLLogE(@"Unable to send encryption start service request\n"
                "permissionManager: %@\n"
                "HMI state must be LIMITED, FULL, BACKGROUND: %@\n",
                self.permissionManager.permissions, self.permissionManager.currentHMILevel);
    }
}

- (void)sdl_sendEncryptionStartService {
    SDLLogD(@"Sending secure rpc start service");
    [self.protocol startSecureServiceWithType:SDLServiceTypeRPC payload:nil completionHandler:^(BOOL success, NSError *error) {
        if (error) {
            SDLLogE(@"TLS setup error: %@", error);
            [self.encryptionStateMachine transitionToState:SDLEncryptionManagerStateStopped];
        }
    }];
}

- (void)sdl_stopEncryptionService {
    _protocol = nil;
    
    [self.encryptionStateMachine transitionToState:SDLEncryptionManagerStateStopped];
}

#pragma mark Encryption
+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_encryptionStateTransitionDictionary {
    return @{
             SDLEncryptionManagerStateStopped : @[SDLEncryptionManagerStateStarting],
             SDLEncryptionManagerStateStarting : @[SDLEncryptionManagerStateStopped, SDLEncryptionManagerStateReady],
             SDLEncryptionManagerStateReady : @[SDLEncryptionManagerStateShuttingDown, SDLEncryptionManagerStateStopped],
             SDLEncryptionManagerStateShuttingDown : @[SDLEncryptionManagerStateStopped]
             };
}

#pragma mark - State Machine
- (void)didEnterStateEncryptionStarting {
    SDLLogD(@"Encryption manager is starting");
    
    [self sdl_sendEncryptionStartService];
}

- (void)didEnterStateEncryptionReady {
    SDLLogD(@"Encryption manager is ready");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLEncryptionDidStartNotification object:nil];
}

- (void)didEnterStateEncryptionStopped {
    SDLLogD(@"Encryption manager stopped");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLEncryptionDidStopNotification object:nil];
}

#pragma mark - SDLProtocolListener
#pragma mark Encryption Start Service ACK

- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK {
    switch (startServiceACK.header.serviceType) {
        case SDLServiceTypeRPC: {
            [self sdl_handleEncryptionStartServiceAck:startServiceACK];
        } break;
        default: break;
    }
}

- (void)sdl_handleEncryptionStartServiceAck:(SDLProtocolMessage *)encryptionStartServiceAck {
    SDLLogD(@"Encryption service started");

    [self.encryptionStateMachine transitionToState:SDLEncryptionManagerStateReady];
}

#pragma mark Encryption Start Service NAK

- (void)handleProtocolStartServiceNAKMessage:(SDLProtocolMessage *)startServiceNAK {
    switch (startServiceNAK.header.serviceType) {
        case SDLServiceTypeRPC: {
            [self sdl_handleEncryptionStartServiceNak:startServiceNAK];
        } break;
        default: break;
    }
}

- (void)sdl_handleEncryptionStartServiceNak:(SDLProtocolMessage *)audioStartServiceNak {
    SDLLogW(@"Encryption service failed to start due to NACK");
    [self.encryptionStateMachine transitionToState:SDLEncryptionManagerStateStopped];
}

#pragma mark Encryption End Service

- (void)handleProtocolEndServiceACKMessage:(SDLProtocolMessage *)endServiceACK {
    switch (endServiceACK.header.serviceType) {
        case SDLServiceTypeRPC: {
            SDLLogW(@"Encryption RPC service ended with end service ACK");
            [self.encryptionStateMachine transitionToState:SDLEncryptionManagerStateStopped];
        } break;
        default: break;
    }
}

- (void)handleProtocolEndServiceNAKMessage:(SDLProtocolMessage *)endServiceNAK {
    switch (endServiceNAK.header.serviceType) {
        case SDLServiceTypeRPC: {
            SDLLogW(@"Encryption RPC service ended with end service NACK");
            [self.encryptionStateMachine transitionToState:SDLEncryptionManagerStateStopped];
        } break;
        default: break;
    }
}

#pragma mark - SDL RPC Notification callbacks
- (void)sdl_hmiStatusDidChange:(SDLRPCNotificationNotification *)notification {
    NSAssert([notification.notification isKindOfClass:[SDLOnHMIStatus class]], @"A notification was sent with an unanticipated object");
    if (![notification.notification isKindOfClass:[SDLOnHMIStatus class]]) {
        return;
    }
    
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus*)notification.notification;
    self.hmiLevel = hmiStatus.hmiLevel;
    
    // if startWithProtocol has not been called yet, abort here
    if (!self.protocol) { return; }
    
    if (!self.isEncryptionReady) {
        [self sdl_startEncryptionService];
    }
}

@end
