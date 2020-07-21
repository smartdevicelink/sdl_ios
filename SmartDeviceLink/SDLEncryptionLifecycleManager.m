//
//  SDLEncryptionLifecycleManager.m
//  SmartDeviceLink
//
//  Created by standa1 on 6/27/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLAsynchronousRPCRequestOperation.h"
#import "SDLConfiguration.h"
#import "SDLEncryptionLifecycleManager.h"
#import "SDLEncryptionManagerConstants.h"
#import "SDLEncryptionConfiguration.h"
#import "SDLError.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLogMacros.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnPermissionsChange.h"
#import "SDLPermissionItem.h"
#import "SDLPermissionConstants.h"
#import "SDLProtocol.h"
#import "SDLProtocolMessage.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLServiceEncryptionDelegate.h"
#import "SDLStateMachine.h"
#import "SDLVehicleType.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString SDLVehicleMake;

@interface SDLEncryptionLifecycleManager() <SDLProtocolDelegate>

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLProtocol *protocol;

@property (strong, nonatomic, readwrite) SDLStateMachine *encryptionStateMachine;
@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;
@property (strong, nonatomic, nullable) NSMutableDictionary<SDLPermissionRPCName, SDLPermissionItem *> *permissions;
@property (assign, nonatomic) BOOL requiresEncryption;
@property (strong, nonatomic) SDLConfiguration *configuration;

@property (nonatomic, strong) NSMutableDictionary<SDLVehicleMake *, Class> *securityManagers;

@end

@implementation SDLEncryptionLifecycleManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    SDLLogV(@"Creating EncryptionLifecycleManager");
    _connectionManager = connectionManager;
    _currentHMILevel = nil;
    _requiresEncryption = NO;
    _securityManagers = [NSMutableDictionary dictionary];
    _encryptionStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLEncryptionLifecycleManagerStateStopped states:[self.class sdl_encryptionStateTransitionDictionary]];
    _permissions = [NSMutableDictionary<SDLPermissionRPCName, SDLPermissionItem *> dictionary];
    _configuration = configuration;

    for (Class securityManagerClass in _configuration.encryptionConfig.securityManagers) {
        if (![securityManagerClass conformsToProtocol:@protocol(SDLSecurityType)]) {
            NSString *reason = [NSString stringWithFormat:@"Invalid security manager: Class %@ does not conform to SDLSecurityType protocol", NSStringFromClass(securityManagerClass)];
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
        }

        NSSet<NSString *> *vehicleMakes = [securityManagerClass availableMakes];
        if (vehicleMakes == nil || vehicleMakes.count == 0) {
            NSString *reason = [NSString stringWithFormat:@"Invalid security manager: Failed to retrieve makes for class %@", NSStringFromClass(securityManagerClass)];
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
        }

        for (NSString *vehicleMake in vehicleMakes) {
            self.securityManagers[vehicleMake] = securityManagerClass;
        }
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_registerAppInterfaceResponseReceived:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_permissionsDidChange:) name:SDLDidChangePermissionsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiLevelDidChange:) name:SDLDidChangeHMIStatusNotification object:nil];

    return self;
}

#pragma mark - Lifecycle

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
    SDLLogD(@"Stopping encryption manager");

    [_permissions removeAllObjects];
    _protocol = nil;
    _currentHMILevel = nil;
    _requiresEncryption = NO;

    [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStopped];
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
        [self.configuration.encryptionConfig.delegate serviceEncryptionUpdatedOnService:SDLServiceTypeRPC encrypted:NO error:[NSError sdl_encryption_lifecycle_notReadyError]];
        return;
    }
    
    if (![self.currentHMILevel isEqualToEnum:SDLHMILevelNone]) {
        if ([self sdl_appRequiresEncryption]) {
            [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStarting];
        } else {
            SDLLogE(@"Encryption Manager is not ready to encrypt.");
            [self.configuration.encryptionConfig.delegate serviceEncryptionUpdatedOnService:SDLServiceTypeRPC encrypted:NO error:[NSError sdl_encryption_lifecycle_notReadyError]];
        }
    }
}

- (void)sdl_sendEncryptionStartService {
    SDLLogD(@"Sending secure rpc start service");
    [self.protocol startSecureServiceWithType:SDLServiceTypeRPC payload:nil tlsInitializationHandler:^(BOOL success, NSError *error) {
        if (error) {
            SDLLogE(@"TLS setup error: %@", error);
            [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStopped];
            [self.configuration.encryptionConfig.delegate serviceEncryptionUpdatedOnService:SDLServiceTypeRPC encrypted:NO error:error];
        }
    }];
}

#pragma mark - State Machine

+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_encryptionStateTransitionDictionary {
    return @{
             SDLEncryptionLifecycleManagerStateStopped : @[SDLEncryptionLifecycleManagerStateStarting],
             SDLEncryptionLifecycleManagerStateStarting : @[SDLEncryptionLifecycleManagerStateStopped, SDLEncryptionLifecycleManagerStateReady],
             SDLEncryptionLifecycleManagerStateReady : @[SDLEncryptionLifecycleManagerStateStopped]
            };
}

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

#pragma mark - SDLProtocolDelegate
#pragma mark Encryption Start Service ACK

- (void)protocol:(SDLProtocol *)protocol didReceiveStartServiceACK:(SDLProtocolMessage *)startServiceACK {
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
        [self.configuration.encryptionConfig.delegate serviceEncryptionUpdatedOnService:SDLServiceTypeRPC encrypted:YES error:nil];
    } else {
        SDLLogD(@"Encryption service ACK received encryption = OFF");
        [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStopped];
        [self.configuration.encryptionConfig.delegate serviceEncryptionUpdatedOnService:SDLServiceTypeRPC encrypted:NO error:[NSError sdl_encryption_lifecycle_encryption_off]];
    }
}

#pragma mark Encryption Start Service NAK

- (void)protocol:(SDLProtocol *)protocol didReceiveStartServiceNAK:(SDLProtocolMessage *)startServiceNAK {
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
    [self.configuration.encryptionConfig.delegate serviceEncryptionUpdatedOnService:SDLServiceTypeRPC encrypted:NO error:[NSError sdl_encryption_lifecycle_nak]];
}

#pragma mark Encryption End Service

- (void)protocol:(SDLProtocol *)protocol didReceiveEndServiceACK:(SDLProtocolMessage *)endServiceACK {
    switch (endServiceACK.header.serviceType) {
        case SDLServiceTypeRPC: {
            SDLLogW(@"Encryption RPC service ended with end service ACK");
            [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStopped];
            [self.configuration.encryptionConfig.delegate serviceEncryptionUpdatedOnService:SDLServiceTypeRPC encrypted:NO error:[NSError sdl_encryption_lifecycle_notReadyError]];
        } break;
        default: break;
    }
}

- (void)protocol:(SDLProtocol *)protocol didReceiveEndServiceNAK:(SDLProtocolMessage *)endServiceNAK {
    switch (endServiceNAK.header.serviceType) {
        case SDLServiceTypeRPC: {
            SDLLogW(@"Encryption RPC service ended with end service NAK");
            [self.encryptionStateMachine transitionToState:SDLEncryptionLifecycleManagerStateStopped];
            [self.configuration.encryptionConfig.delegate serviceEncryptionUpdatedOnService:SDLServiceTypeRPC encrypted:NO error:[NSError sdl_encryption_lifecycle_notReadyError]];
        } break;
        default: break;
    }
}

#pragma mark - Notifications

- (void)sdl_registerAppInterfaceResponseReceived:(SDLRPCResponseNotification *)notification {
    if (![notification isResponseMemberOfClass:[SDLRegisterAppInterfaceResponse class]]) { return; }

    SDLRegisterAppInterfaceResponse *registerResponse = notification.response;
    self.protocol.securityManager = [self sdl_securityManagerForMake:registerResponse.vehicleType.make];
    if (self.protocol.securityManager && [self.protocol.securityManager respondsToSelector:@selector(setAppId:)]) {
        self.protocol.securityManager.appId = self.configuration.lifecycleConfig.fullAppId ? self.configuration.lifecycleConfig.fullAppId : self.configuration.lifecycleConfig.appId;
    }
}

- (void)sdl_hmiLevelDidChange:(SDLRPCNotificationNotification *)notification {
    if (![notification isNotificationMemberOfClass:[SDLOnHMIStatus class]]) { return; }
    
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


#pragma mark - Utilities

- (nullable id<SDLSecurityType>)sdl_securityManagerForMake:(NSString *)make {
    if ((make != nil) && (self.securityManagers[make] != nil)) {
        Class securityManagerClass = self.securityManagers[make];
        return [[securityManagerClass alloc] init];
    }

    return nil;
}

#pragma mark Encryption Status

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
