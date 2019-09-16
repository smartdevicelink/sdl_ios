//
//  SDLEncryptionLifecycleManager.m
//  SmartDeviceLink
//
//  Created by standa1 on 6/27/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLEncryptionLifecycleManager.h"
#import "SDLEncryptionManagerConstants.h"
#import "SDLEncryptionConfiguration.h"
#import "SDLServiceEncryptionDelegate.h"
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

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLProtocol *protocol;

@property (strong, nonatomic, readwrite) SDLStateMachine *encryptionStateMachine;
@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (strong, nonatomic, nullable) NSMutableDictionary<SDLPermissionRPCName, SDLPermissionItem *> *permissions;
@property (assign, nonatomic) BOOL requiresEncryption;
@property (weak, nonatomic, nullable) id<SDLServiceEncryptionDelegate> delegate;

@end

@implementation SDLEncryptionLifecycleManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLEncryptionConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    SDLLogV(@"Creating EncryptionLifecycleManager");
    _connectionManager = connectionManager;
    _currentHMILevel = nil;
    _requiresEncryption = NO;
    _encryptionStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLEncryptionLifecycleManagerStateStopped states:[self.class sdl_encryptionStateTransitionDictionary]];
    _permissions = [NSMutableDictionary<SDLPermissionRPCName, SDLPermissionItem *> dictionary];
    _delegate = configuration.delegate;

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
    _delegate = nil;

    SDLLogD(@"Stopping encryption manager");
}

- (BOOL)isEncryptionReady {
    return [self.encryptionStateMachine isCurrentState:SDLEncryptionLifecycleManagerStateReady];
}

- (void)startEncryptionService {
    [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStarting];
}

- (void)sdl_startEncryptionService {
    SDLLogV(@"Attempting to start Encryption Service");
    if (!self.protocol || !self.currentHMILevel) {
        SDLLogV(@"Encryption manager is not yet started");
        [self.delegate serviceEncryptionUpdatedOnService:SDLServiceTypeRPC encrypted:NO error:[NSError sdl_encryption_lifecycle_notReadyError]];
        return;
    }
    
    if (![self.currentHMILevel isEqualToEnum:SDLHMILevelNone]) {
        if ([self sdl_appRequiresEncryption]) {
            [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStarting];
        } else {
            SDLLogE(@"Encryption Manager is not ready to encrypt.");
            [self.delegate serviceEncryptionUpdatedOnService:SDLServiceTypeRPC encrypted:NO error:[NSError sdl_encryption_lifecycle_notReadyError]];
        }
    }
}

- (void)sdl_sendEncryptionStartService {
    SDLLogD(@"Sending secure rpc start service");
    [self.protocol startSecureServiceWithType:SDLServiceTypeRPC payload:nil tlsInitializationHandler:^(BOOL success, NSError *error) {
        if (error) {
            SDLLogE(@"TLS setup error: %@", error);
            [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStopped];
            [self.delegate serviceEncryptionUpdatedOnService:SDLServiceTypeRPC encrypted:NO error:error];
        }
    }];
}

#pragma mark Encryption
+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_encryptionStateTransitionDictionary {
    return @{
             SDLEncryptionLifecycleManagerStateStopped : @[SDLEncryptionLifecycleManagerStateStarting],
             SDLEncryptionLifecycleManagerStateStarting : @[SDLEncryptionLifecycleManagerStateStopped, SDLEncryptionLifecycleManagerStateReady],
             SDLEncryptionLifecycleManagerStateReady : @[SDLEncryptionLifecycleManagerStateStopped]
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
        [self.delegate serviceEncryptionUpdatedOnService:SDLServiceTypeRPC encrypted:YES error:nil];
    } else {
        SDLLogD(@"Encryption service ACK received encryption = OFF");
        [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStopped];
        [self.delegate serviceEncryptionUpdatedOnService:SDLServiceTypeRPC encrypted:NO error:[NSError sdl_encryption_lifecycle_encryption_off]];
    }
}

#pragma mark Encryption Start Service NAK

- (void)handleProtocolStartServiceNAKMessage:(SDLProtocolMessage *)startServiceNAK {
    switch (startServiceNAK.header.serviceType) {
        case SDLServiceTypeRPC: {
            [self sdl_handleEncryptionStartServiceNAK:startServiceNAK];
        } break;
        default: break;
    }
}

- (void)sdl_handleEncryptionStartServiceNAK:(SDLProtocolMessage *)audioStartServiceNak {
    SDLLogW(@"Encryption service failed to start due to NAK");
    [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStopped];
    [self.delegate serviceEncryptionUpdatedOnService:SDLServiceTypeRPC encrypted:NO error:[NSError sdl_encryption_lifecycle_nak]];
}

#pragma mark Encryption End Service

- (void)handleProtocolEndServiceACKMessage:(SDLProtocolMessage *)endServiceACK {
    switch (endServiceACK.header.serviceType) {
        case SDLServiceTypeRPC: {
            SDLLogW(@"Encryption RPC service ended with end service ACK");
            [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStopped];
            [self.delegate serviceEncryptionUpdatedOnService:SDLServiceTypeRPC encrypted:NO error:[NSError sdl_encryption_lifecycle_notReadyError]];
        } break;
        default: break;
    }
}

- (void)handleProtocolEndServiceNAKMessage:(SDLProtocolMessage *)endServiceNAK {
    switch (endServiceNAK.header.serviceType) {
        case SDLServiceTypeRPC: {
            SDLLogW(@"Encryption RPC service ended with end service NAK");
            [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStopped];
            [self.delegate serviceEncryptionUpdatedOnService:SDLServiceTypeRPC encrypted:NO error:[NSError sdl_encryption_lifecycle_notReadyError]];
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
    NSArray<SDLPermissionItem *> *permissionItems = onPermissionChange.permissionItem;
    [self.permissions removeAllObjects];

    for (SDLPermissionItem *item in permissionItems) {
        self.permissions[item.rpcName] = item;
    }

    self.requiresEncryption = (onPermissionChange.requireEncryption != nil) ? onPermissionChange.requireEncryption.boolValue : [self sdl_containsAtLeastOneRPCThatRequiresEncryption];
    
    // if startWithProtocol has not been called yet, abort here
    if (!self.protocol) { return; }
    
    if ([self.encryptionStateMachine isCurrentState:SDLEncryptionLifecycleManagerStateStopped]) {
        [self sdl_startEncryptionService];
    }
}

- (BOOL)sdl_appRequiresEncryption {
    if (self.requiresEncryption && [self sdl_containsAtLeastOneRPCThatRequiresEncryption]) {
        return YES;
    }
    return NO;
}

- (BOOL)rpcRequiresEncryption:(__kindof SDLRPCMessage *)rpc {
    if (self.permissions[rpc.name].requireEncryption != nil) {
        return self.permissions[rpc.name].requireEncryption.boolValue;
    }
    return NO;
}

- (BOOL)sdl_containsAtLeastOneRPCThatRequiresEncryption {
    for (SDLPermissionItem *item in self.permissions.allValues) {
        if (item.requireEncryption) {
            return YES;
        }
    }
    return NO;
}

@end

NS_ASSUME_NONNULL_END
