//
//  SDLEncryptionLifecycleManager.m
//  SmartDeviceLink
//
//  Created by standa1 on 6/27/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLEncryptionLifecycleManager.h"
#import "SDLEncryptionManagerConstants.h"
#import "SDLAsynchronousRPCRequestOperation.h"
#import "SDLLogMacros.h"
#import "SDLStateMachine.h"
#import "SDLProtocolMessage.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnPermissionsChange.h"
#import "SDLPermissionItem.h"
#import "SDLPermissionConstants.h"
#import "SDLProtocol.h"
#import "SDLError.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLEncryptionLifecycleManager() <SDLProtocolListener>

@property (strong, nonatomic, readonly) NSOperationQueue *rpcOperationQueue;
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLProtocol *protocol;

@property (strong, nonatomic, readwrite) SDLStateMachine *encryptionStateMachine;
@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (strong, nonatomic, nullable) NSMutableDictionary<SDLPermissionRPCName, SDLPermissionItem *> *permissions;
@property (assign, nonatomic) BOOL requiresEncryption;

@end

@implementation SDLEncryptionLifecycleManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLEncryptionConfiguration *)configuration rpcOperationQueue:(NSOperationQueue *)rpcOperationQueue {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    SDLLogV(@"Creating EncryptionLifecycleManager");
    _connectionManager = connectionManager;
    _rpcOperationQueue = rpcOperationQueue;
    _currentHMILevel = nil;
    _requiresEncryption = NO;
    _encryptionStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLEncryptionLifecycleManagerStateStopped states:[self.class sdl_encryptionStateTransitionDictionary]];
    _permissions = [NSMutableDictionary<SDLPermissionRPCName, SDLPermissionItem *> dictionary];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_permissionsDidChange:) name:SDLDidChangePermissionsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiLevelDidChange:) name:SDLDidChangeHMIStatusNotification object:nil];

    return self;
}

- (void)startWithProtocol:(SDLProtocol *)protocol {
    SDLLogD(@"Starting encryption manager");
    _protocol = protocol;
    
    @synchronized(self.protocol.protocolDelegateTable) {
        if (![self.protocol.protocolDelegateTable containsObject:self]) {
            [self.protocol.protocolDelegateTable addObject:self];
        }
    }
    
}

- (void)stop {
    _permissions = nil;
    _protocol = nil;
    _currentHMILevel = nil;
    _requiresEncryption = NO;

    SDLLogD(@"Stopping encryption manager");
}

- (BOOL)isEncryptionReady {
    return [self.encryptionStateMachine isCurrentState:SDLEncryptionLifecycleManagerStateReady];
}

- (void)sdl_startEncryptionService {
    SDLLogV(@"Attempting to start Encryption Service");
    if (!self.protocol || !self.currentHMILevel) {
        SDLLogV(@"Encryption manager is not yet started");
        return;
    }
    
    if (![self.currentHMILevel isEqualToEnum:SDLHMILevelNone]
        && self.requiresEncryption) {
        [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStarting];
    } else {
        SDLLogE(@"Encryption Manager is not ready to encrypt.");
    }
}

- (void)sdl_sendEncryptionStartService {
    SDLLogD(@"Sending secure rpc start service");
    [self.protocol startSecureServiceWithType:SDLServiceTypeRPC payload:nil tlsInitializationHandler:^(BOOL success, NSError *error) {
        if (error) {
            SDLLogE(@"TLS setup error: %@", error);
            [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStopped];
        }
    }];
}

#pragma mark Encryption
+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_encryptionStateTransitionDictionary {
    return @{
             SDLEncryptionLifecycleManagerStateStopped : @[SDLEncryptionLifecycleManagerStateStarting],
             SDLEncryptionLifecycleManagerStateStarting : @[SDLEncryptionLifecycleManagerStateStopped, SDLEncryptionLifecycleManagerStateReady],
             SDLEncryptionLifecycleManagerStateReady : @[SDLEncryptionLifecycleManagerStateShuttingDown, SDLEncryptionLifecycleManagerStateStopped]
            };
}

#pragma mark - State Machine
- (void)didEnterStateEncryptionStarting {
    SDLLogD(@"Encryption manager is starting");
    [self sdl_sendEncryptionStartService];
}

- (void)didEnterStateEncryptionReady {
    SDLLogD(@"Encryption manager is ready");
}

- (void)didEnterStateEncryptionStopped {
    SDLLogD(@"Encryption manager stopped");
}

#pragma mark - SDLProtocolListener
#pragma mark Encryption Start Service ACK

- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK {
    switch (startServiceACK.header.serviceType) {
        case SDLServiceTypeRPC: {
            [self sdl_handleEncryptionStartServiceACK:startServiceACK];
        } break;
        default: break;
    }
}

- (void)sdl_handleEncryptionStartServiceACK:(SDLProtocolMessage *)encryptionStartServiceAck {
    if (encryptionStartServiceAck.header.encrypted) {
        SDLLogD(@"Encryption service started");
        [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateReady];
    } else {
        SDLLogD(@"Encryption service ACK received encryption = OFF");
        [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStopped];
    }
}

#pragma mark Encryption Start Service NAK

- (void)handleProtocolStartServiceNAKMessage:(SDLProtocolMessage *)startServiceNAK {
    switch (startServiceNAK.header.serviceType) {
        case SDLServiceTypeRPC: {
            if (startServiceNAK.header.encrypted) {
                [self sdl_handleEncryptionStartServiceNAK:startServiceNAK];
            } else {
                SDLLogW(@"Encryption service failed to start due to encryption bit set to 0 in ACK");
            }
        } break;
        default: break;
    }
}

- (void)sdl_handleEncryptionStartServiceNAK:(SDLProtocolMessage *)audioStartServiceNak {
    SDLLogW(@"Encryption service failed to start due to NAK");
    [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStopped];
}

#pragma mark Encryption End Service

- (void)handleProtocolEndServiceACKMessage:(SDLProtocolMessage *)endServiceACK {
    switch (endServiceACK.header.serviceType) {
        case SDLServiceTypeRPC: {
            SDLLogW(@"Encryption RPC service ended with end service ACK");
            [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStopped];
        } break;
        default: break;
    }
}

- (void)handleProtocolEndServiceNAKMessage:(SDLProtocolMessage *)endServiceNAK {
    switch (endServiceNAK.header.serviceType) {
        case SDLServiceTypeRPC: {
            SDLLogW(@"Encryption RPC service ended with end service NAK");
            [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStopped];
        } break;
        default: break;
    }
}

#pragma mark - SDL RPC Notification callbacks
- (void)sdl_hmiLevelDidChange:(SDLRPCNotificationNotification *)notification {
    if (![notification isNotificationMemberOfClass:[SDLOnHMIStatus class]]) {
        return;
    }
    
    SDLOnHMIStatus *hmiStatus = notification.notification;
    
    self.currentHMILevel = hmiStatus.hmiLevel;
    
    // if startWithProtocol has not been called yet, abort here
    if (!self.protocol) { return; }
    
    if ([self.encryptionStateMachine isCurrentState:SDLEncryptionLifecycleManagerStateStopped]) {
        [self sdl_startEncryptionService];
    }
}

- (void)sdl_permissionsDidChange:(SDLRPCNotificationNotification *)notification {
    if (![notification isNotificationMemberOfClass:[SDLOnPermissionsChange class]]) {
        return;
    }
    
    SDLOnPermissionsChange *onPermissionChange = notification.notification;
    self.requiresEncryption = onPermissionChange.requireEncryption.boolValue;
    
    if (!self.requiresEncryption) {
        return;
    }
    
    NSArray<SDLPermissionItem *> *newPermissionItems = onPermissionChange.permissionItem;
    
    for (SDLPermissionItem *item in newPermissionItems) {
        self.permissions[item.rpcName] = item;
    }
    
    // if startWithProtocol has not been called yet, abort here
    if (!self.protocol) { return; }
    
    if ([self.encryptionStateMachine isCurrentState:SDLEncryptionLifecycleManagerStateStopped]) {
        [self sdl_startEncryptionService];
    }
}

- (BOOL)rpcRequiresEncryption:(__kindof SDLRPCMessage *)rpc {
    if (self.permissions[rpc.name].requireEncryption != nil) {
        return self.permissions[rpc.name].requireEncryption.boolValue;
    }
    return NO;
}

@end

NS_ASSUME_NONNULL_END
