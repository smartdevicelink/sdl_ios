// SDLProxy.m

#import "SDLProxy.h"

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#import "SDLAudioStreamingState.h"
#import "SDLLogMacros.h"
#import "SDLEncodedSyncPData.h"
#import "SDLEncryptionLifecycleManager.h"
#import "SDLFileType.h"
#import "SDLFunctionID.h"
#import "SDLGlobals.h"
#import "SDLHMILevel.h"
#import "SDLIAPTransport.h"
#import "SDLLanguage.h"
#import "SDLLayoutMode.h"
#import "SDLLockScreenStatusManager.h"
#import "SDLOnButtonEvent.h"
#import "SDLOnButtonPress.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnSystemRequest.h"
#import "SDLPolicyDataParser.h"
#import "SDLProtocol.h"
#import "SDLProtocolMessage.h"
#import "SDLPutFile.h"
#import "SDLRPCPayload.h"
#import "SDLRPCResponse.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRequestType.h"
#import "SDLSecondaryTransportManager.h"
#import "SDLStreamingMediaManager.h"
#import "SDLSubscribeButton.h"
#import "SDLSystemContext.h"
#import "SDLSystemRequest.h"
#import "SDLTCPTransport.h"
#import "SDLTimer.h"
#import "SDLTransportType.h"
#import "SDLUnsubscribeButton.h"
#import "SDLVehicleType.h"
#import "SDLVersion.h"
#import "SDLCacheFileManager.h"

#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString SDLVehicleMake;

NSString *const SDLProxyVersion = @"6.6.0";
const float StartSessionTime = 10.0;
const float NotifyProxyClosedDelay = (float)0.1;

@interface SDLProxy () {
    SDLLockScreenStatusManager *_lsm;
}

@property (copy, nonatomic) NSString *appId;
@property (strong, nonatomic) NSMutableSet<NSObject<SDLProxyListener> *> *mutableProxyListeners;
@property (nullable, nonatomic, strong) SDLDisplayCapabilities *displayCapabilities;
@property (nonatomic, strong) NSMutableDictionary<SDLVehicleMake *, Class> *securityManagers;

@end


@implementation SDLProxy

#pragma mark - Object lifecycle
- (instancetype)initWithTransport:(id<SDLTransportType>)transport delegate:(id<SDLProxyListener>)delegate secondaryTransportManager:(nullable SDLSecondaryTransportManager *)secondaryTransportManager {
    if (self = [super init]) {
        SDLLogD(@"Framework Version: %@", self.proxyVersion);
        _lsm = [[SDLLockScreenStatusManager alloc] init];
        _mutableProxyListeners = [NSMutableSet setWithObject:delegate];
        _securityManagers = [NSMutableDictionary dictionary];

        _protocol = [[SDLProtocol alloc] init];
        _transport = transport;
        _transport.delegate = _protocol;

        [_protocol.protocolDelegateTable addObject:self];
        _protocol.transport = transport;

        // make sure that secondary transport manager is started prior to starting protocol
        if (secondaryTransportManager != nil) {
            [secondaryTransportManager startWithPrimaryProtocol:_protocol];
        }

        [self.transport connect];

        SDLLogV(@"Proxy transport initialization");
    }

    return self;
}

- (instancetype)initWithTransport:(id<SDLTransportType>)transport delegate:(id<SDLProxyListener>)delegate secondaryTransportManager:(nullable SDLSecondaryTransportManager *)secondaryTransportManager encryptionLifecycleManager:(SDLEncryptionLifecycleManager *)encryptionLifecycleManager {
    if (self = [super init]) {
        SDLLogD(@"Framework Version: %@", self.proxyVersion);
        _lsm = [[SDLLockScreenStatusManager alloc] init];
        _mutableProxyListeners = [NSMutableSet setWithObject:delegate];
        _securityManagers = [NSMutableDictionary dictionary];
        
        _protocol = [[SDLProtocol alloc] initWithEncryptionLifecycleManager:encryptionLifecycleManager];
        _transport = transport;
        _transport.delegate = _protocol;
        
        [_protocol.protocolDelegateTable addObject:self];
        _protocol.transport = transport;
        
        // make sure that secondary transport manager is started prior to starting protocol
        if (secondaryTransportManager != nil) {
            [secondaryTransportManager startWithPrimaryProtocol:_protocol];
        }
        
        [self.transport connect];
        
        SDLLogV(@"Proxy transport initialization");
    }
    
    return self;
}


+ (SDLProxy *)iapProxyWithListener:(id<SDLProxyListener>)delegate secondaryTransportManager:(nullable SDLSecondaryTransportManager *)secondaryTransportManager {
    SDLIAPTransport *transport = [[SDLIAPTransport alloc] init];
    SDLProxy *ret = [[SDLProxy alloc] initWithTransport:transport delegate:delegate secondaryTransportManager:secondaryTransportManager];

    return ret;
}

+ (SDLProxy *)tcpProxyWithListener:(id<SDLProxyListener>)delegate tcpIPAddress:(NSString *)ipaddress tcpPort:(NSString *)port secondaryTransportManager:(nullable SDLSecondaryTransportManager *)secondaryTransportManager {
    SDLTCPTransport *transport = [[SDLTCPTransport alloc] initWithHostName:ipaddress portNumber:port];

    SDLProxy *ret = [[SDLProxy alloc] initWithTransport:transport delegate:delegate secondaryTransportManager:secondaryTransportManager];

    return ret;
}

+ (SDLProxy *)iapProxyWithListener:(id<SDLProxyListener>)delegate secondaryTransportManager:(nullable SDLSecondaryTransportManager *)secondaryTransportManager encryptionLifecycleManager:(SDLEncryptionLifecycleManager *)encryptionLifecycleManager {
    SDLIAPTransport *transport = [[SDLIAPTransport alloc] init];
    SDLProxy *ret = [[SDLProxy alloc] initWithTransport:transport delegate:delegate secondaryTransportManager:secondaryTransportManager encryptionLifecycleManager:encryptionLifecycleManager];
    
    return ret;
}

+ (SDLProxy *)tcpProxyWithListener:(id<SDLProxyListener>)delegate tcpIPAddress:(NSString *)ipaddress tcpPort:(NSString *)port secondaryTransportManager:(nullable SDLSecondaryTransportManager *)secondaryTransportManager encryptionLifecycleManager:(SDLEncryptionLifecycleManager *)encryptionLifecycleManager {
    SDLTCPTransport *transport = [[SDLTCPTransport alloc] initWithHostName:ipaddress portNumber:port];
    
    SDLProxy *ret = [[SDLProxy alloc] initWithTransport:transport delegate:delegate secondaryTransportManager:secondaryTransportManager encryptionLifecycleManager:encryptionLifecycleManager];

    return ret;
}

- (void)disconnectSession {
    SDLLogD(@"Disconnecting the proxy; stopping security manager and primary transport.");
    if (self.protocol.securityManager != nil) {
        [self.protocol.securityManager stop];
    }

    if (self.transport != nil) {
        [self.transport disconnect];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    SDLLogV(@"Proxy dealloc");
}

- (void)sdl_notifyProxyClosed {
    if (_isConnected) {
        _isConnected = NO;
        [self sdl_invokeMethodOnDelegates:@selector(onProxyClosed) withObject:nil];
    }
}

#pragma mark - Accessors

- (NSSet<NSObject<SDLProxyListener> *> *)proxyListeners {
    return [self.mutableProxyListeners copy];
}


#pragma mark - Setters / Getters

- (NSString *)proxyVersion {
    return SDLProxyVersion;
}

#pragma mark - SecurityManager

- (void)addSecurityManagers:(NSArray<Class> *)securityManagerClasses forAppId:(NSString *)appId {
    NSParameterAssert(securityManagerClasses != nil);
    NSParameterAssert(appId != nil);
    self.appId = appId;

    for (Class securityManagerClass in securityManagerClasses) {
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
}

- (nullable id<SDLSecurityType>)sdl_securityManagerForMake:(NSString *)make {
    if ((make != nil) && (self.securityManagers[make] != nil)) {
        Class securityManagerClass = self.securityManagers[make];
        self.protocol.appId = self.appId;
        return [[securityManagerClass alloc] init];
    }

    return nil;
}


#pragma mark - SDLProtocolListener Implementation

- (void)onProtocolOpened {
    _isConnected = YES;
    SDLLogV(@"Proxy RPC protocol opened");
    // The RPC payload will be created by the protocol object...it's weird and confusing, I know.
    [self.protocol startServiceWithType:SDLServiceTypeRPC payload:nil];

    if (self.startSessionTimer == nil) {
        self.startSessionTimer = [[SDLTimer alloc] initWithDuration:StartSessionTime repeat:NO];
        __weak typeof(self) weakSelf = self;
        self.startSessionTimer.elapsedBlock = ^{
            SDLLogW(@"Start session timed out");
            [weakSelf performSelector:@selector(sdl_notifyProxyClosed) withObject:nil afterDelay:NotifyProxyClosedDelay];
        };
    }
    [self.startSessionTimer start];
}

- (void)onProtocolClosed {
    [self sdl_notifyProxyClosed];
}

- (void)onError:(NSString *)info exception:(NSException *)e {
    [self sdl_invokeMethodOnDelegates:@selector(onError:) withObject:e];
}

- (void)onTransportError:(NSError *)error {
    [self sdl_invokeMethodOnDelegates:@selector(onTransportError:) withObject:error];
}

- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK {
    // Turn off the timer, the start session response came back
    [self.startSessionTimer cancel];
    SDLLogV(@"StartSession (response)\nSessionId: %d for serviceType %d", startServiceACK.header.sessionID, startServiceACK.header.serviceType);

    if (startServiceACK.header.serviceType == SDLServiceTypeRPC) {
        [self sdl_invokeMethodOnDelegates:@selector(onProxyOpened) withObject:nil];
    }
}

- (void)onProtocolMessageReceived:(SDLProtocolMessage *)msgData {
    @try {
        [self handleProtocolMessage:msgData];
    } @catch (NSException *e) {
        SDLLogW(@"Proxy: Failed to handle protocol message %@", e);
    }
}


#pragma mark - Message sending
- (void)sendRPC:(SDLRPCMessage *)message {
    if ([message.name isEqualToString:SDLRPCFunctionNameSubscribeButton]) {
        BOOL handledRPC = [self sdl_adaptButtonSubscribeMessage:(SDLSubscribeButton *)message];
        if (handledRPC) { return; }
    } else if ([message.name isEqualToString:SDLRPCFunctionNameUnsubscribeButton]) {
        BOOL handledRPC = [self sdl_adaptButtonUnsubscribeMessage:(SDLUnsubscribeButton *)message];
        if (handledRPC) { return; }
    }

    @try {
        [self.protocol sendRPC:message];
    } @catch (NSException *exception) {
        SDLLogE(@"Proxy: Failed to send RPC message: %@", message.name);
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (BOOL)sdl_adaptButtonSubscribeMessage:(SDLSubscribeButton *)message {
    if ([SDLGlobals sharedGlobals].rpcVersion.major >= 5) {
        if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
            SDLSubscribeButton *playPauseMessage = [message copy];
            playPauseMessage.buttonName = SDLButtonNamePlayPause;

            @try {
                [self.protocol sendRPC:message];
                [self.protocol sendRPC:playPauseMessage];
            } @catch (NSException *exception) {
                SDLLogE(@"Proxy: Failed to send RPC message: %@", message.name);
            }

            return YES;
        } else if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
            return NO;
        }
    } else { // Major version < 5
        if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
            return NO;
        } else if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
            SDLSubscribeButton *okMessage = [message copy];
            okMessage.buttonName = SDLButtonNameOk;

            @try {
                [self.protocol sendRPC:okMessage];
            } @catch (NSException *exception) {
                SDLLogE(@"Proxy: Failed to send RPC message: %@", message.name);
            }

            return YES;
        }
    }

    return NO;
}

- (BOOL)sdl_adaptButtonUnsubscribeMessage:(SDLUnsubscribeButton *)message {
    if ([SDLGlobals sharedGlobals].rpcVersion.major >= 5) {
        if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
            SDLUnsubscribeButton *playPauseMessage = [message copy];
            playPauseMessage.buttonName = SDLButtonNamePlayPause;

            @try {
                [self.protocol sendRPC:message];
                [self.protocol sendRPC:playPauseMessage];
            } @catch (NSException *exception) {
                SDLLogE(@"Proxy: Failed to send RPC message: %@", message.name);
            }

            return YES;
        } else if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
            return NO;
        }
    } else { // Major version < 5
        if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
            return NO;
        } else if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
            SDLUnsubscribeButton *okMessage = [message copy];
            okMessage.buttonName = SDLButtonNameOk;

            @try {
                [self.protocol sendRPC:okMessage];
            } @catch (NSException *exception) {
                SDLLogE(@"Proxy: Failed to send RPC message: %@", message.name);
            }

            return YES;
        }
    }

    return NO;
}
#pragma clang diagnostic pop

#pragma mark - Message Receiving

- (void)handleProtocolMessage:(SDLProtocolMessage *)incomingMessage {
    // Convert protocol message to dictionary
    NSDictionary<NSString *, id> *rpcMessageAsDictionary = [incomingMessage rpcDictionary];
    [self handleRPCDictionary:rpcMessageAsDictionary];
}

- (void)handleRPCDictionary:(NSDictionary<NSString *, id> *)dict {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    SDLRPCMessage *message = [[SDLRPCMessage alloc] initWithDictionary:[dict mutableCopy]];
#pragma clang diagnostic pop
    NSString *functionName = message.name;
    NSString *messageType = message.messageType;

    // If it's a response, append response
    if ([messageType isEqualToString:SDLRPCParameterNameResponse]) {
        BOOL notGenericResponseMessage = ![functionName isEqualToString:SDLRPCFunctionNameGenericResponse];
        if (notGenericResponseMessage) {
            functionName = [NSString stringWithFormat:@"%@Response", functionName];
        }
    }

    // From the function name, create the corresponding RPCObject and initialize it
    NSString *functionClassName = [NSString stringWithFormat:@"SDL%@", functionName];
    SDLRPCMessage *newMessage = [[NSClassFromString(functionClassName) alloc] initWithDictionary:[dict mutableCopy]];

    // Log the RPC message
    SDLLogV(@"Message received: %@", newMessage);

    // Intercept and handle several messages ourselves

    if ([functionName isEqualToString:@"RegisterAppInterfaceResponse"]) {
        [self handleRegisterAppInterfaceResponse:(SDLRPCResponse *)newMessage];
    }

    if ([functionName isEqualToString:@"OnButtonPress"]) {
        SDLOnButtonPress *message = (SDLOnButtonPress *)newMessage;
        if ([SDLGlobals sharedGlobals].rpcVersion.major >= 5) {
            BOOL handledRPC = [self sdl_handleOnButtonPressPostV5:message];
            if (handledRPC) { return; }
        } else { // RPC version of 4 or less (connected to an old head unit)
            BOOL handledRPC = [self sdl_handleOnButtonPressPreV5:message];
            if (handledRPC) { return; }
        }
    }

    if ([functionName isEqualToString:@"OnButtonEvent"]) {
        SDLOnButtonEvent *message = (SDLOnButtonEvent *)newMessage;
        if ([SDLGlobals sharedGlobals].rpcVersion.major >= 5) {
            BOOL handledRPC = [self sdl_handleOnButtonEventPostV5:message];
            if (handledRPC) { return; }
        } else {
            BOOL handledRPC = [self sdl_handleOnButtonEventPreV5:message];
            if (handledRPC) { return; }
        }
    }

    [self sdl_invokeDelegateMethodsWithFunction:functionName message:newMessage];
    
    //Intercepting SDLRPCFunctionNameOnAppInterfaceUnregistered must happen after it is broadcasted as a notification above. This will prevent reconnection attempts in the lifecycle manager when the AppInterfaceUnregisteredReason should prevent reconnections.
    if ([functionName isEqualToString:SDLRPCFunctionNameOnAppInterfaceUnregistered] || [functionName isEqualToString:SDLRPCFunctionNameUnregisterAppInterface]) {
        [self sdl_handleRPCUnregistered:dict];
    }

    // When an OnHMIStatus notification comes in, after passing it on (above), generate an "OnLockScreenNotification"
    if ([functionName isEqualToString:@"OnHMIStatus"]) {
        [self sdl_handleAfterHMIStatus:newMessage];
    }

    // When an OnDriverDistraction notification comes in, after passing it on (above), generate an "OnLockScreenNotification"
    if ([functionName isEqualToString:@"OnDriverDistraction"]) {
        [self sdl_handleAfterDriverDistraction:newMessage];
    }
}

- (void)sdl_invokeDelegateMethodsWithFunction:(NSString *)functionName message:(SDLRPCMessage *)message {
    // Formulate the name of the method to call and invoke the method on the delegate(s)
    NSString *handlerName = [NSString stringWithFormat:@"on%@:", functionName];
    SEL handlerSelector = NSSelectorFromString(handlerName);
    [self sdl_invokeMethodOnDelegates:handlerSelector withObject:message];
}


#pragma mark - RPC Handlers

- (void)sdl_handleRPCUnregistered:(NSDictionary<NSString *, id> *)messageDictionary {
    SDLLogW(@"Unregistration forced by module. %@", messageDictionary);
    [self sdl_notifyProxyClosed];
}

- (void)handleRegisterAppInterfaceResponse:(SDLRPCResponse *)response {
    SDLRegisterAppInterfaceResponse *registerResponse = (SDLRegisterAppInterfaceResponse *)response;

    self.protocol.securityManager = [self sdl_securityManagerForMake:registerResponse.vehicleType.make];
    if (self.protocol.securityManager && [self.protocol.securityManager respondsToSelector:@selector(setAppId:)]) {
        self.protocol.securityManager.appId = self.appId;
    }
}

#pragma mark BackCompatability ButtonName Helpers

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (BOOL)sdl_handleOnButtonPressPreV5:(SDLOnButtonPress *)message {
    // Drop PlayPause, this shouldn't come in
    if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
        return YES;
    } else if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
        // Send Ok and Play/Pause notifications
        SDLOnButtonPress *playPausePress = [message copy];
        playPausePress.buttonName = SDLButtonNamePlayPause;

        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:playPausePress];
        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:message];
        return YES;
    }

    return NO;
}

- (BOOL)sdl_handleOnButtonPressPostV5:(SDLOnButtonPress *)message {
    if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
        // Send PlayPause & OK notifications
        SDLOnButtonPress *okPress = [message copy];
        okPress.buttonName = SDLButtonNameOk;

        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:okPress];
        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:message];
        return YES;
    } else if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
        // Send PlayPause and OK notifications
        SDLOnButtonPress *playPausePress = [message copy];
        playPausePress.buttonName = SDLButtonNamePlayPause;

        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:playPausePress];
        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:message];
        return YES;
    }

    return NO;
}

- (BOOL)sdl_handleOnButtonEventPreV5:(SDLOnButtonEvent *)message {
    // Drop PlayPause, this shouldn't come in
    if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
        return YES;
    } else if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
        // Send Ok and Play/Pause notifications
        SDLOnButtonEvent *playPauseEvent = [message copy];
        playPauseEvent.buttonName = SDLButtonNamePlayPause;

        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:playPauseEvent];
        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:message];
        return YES;
    }

    return NO;
}

- (BOOL)sdl_handleOnButtonEventPostV5:(SDLOnButtonEvent *)message {
    if ([message.buttonName isEqualToEnum:SDLButtonNamePlayPause]) {
        // Send PlayPause & OK notifications
        SDLOnButtonEvent *okEvent = [message copy];
        okEvent.buttonName = SDLButtonNameOk;

        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:okEvent];
        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:message];
        return YES;
    } else if ([message.buttonName isEqualToEnum:SDLButtonNameOk]) {
        // Send PlayPause and OK notifications
        SDLOnButtonEvent *playPauseEvent = [message copy];
        playPauseEvent.buttonName = SDLButtonNamePlayPause;

        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:playPauseEvent];
        [self sdl_invokeDelegateMethodsWithFunction:message.getFunctionName message:message];
        return YES;
    }

    return NO;
}
#pragma clang diagnostic pop


#pragma mark Handle Post-Invoke of Delegate Methods
- (void)sdl_handleAfterHMIStatus:(SDLRPCMessage *)message {
    SDLHMILevel hmiLevel = (SDLHMILevel)message.parameters[SDLRPCParameterNameHMILevel];
    _lsm.hmiLevel = hmiLevel;

    SEL callbackSelector = NSSelectorFromString(@"onOnLockScreenNotification:");
    [self sdl_invokeMethodOnDelegates:callbackSelector withObject:_lsm.lockScreenStatusNotification];
}

- (void)sdl_handleAfterDriverDistraction:(SDLRPCMessage *)message {
    NSString *stateString = (NSString *)message.parameters[SDLRPCParameterNameState];
    BOOL state = [stateString isEqualToString:@"DD_ON"] ? YES : NO;
    _lsm.driverDistracted = state;

    SEL callbackSelector = NSSelectorFromString(@"onOnLockScreenNotification:");
    [self sdl_invokeMethodOnDelegates:callbackSelector withObject:_lsm.lockScreenStatusNotification];
}

#pragma mark - Delegate management

- (void)addDelegate:(NSObject<SDLProxyListener> *)delegate {
    @synchronized(self.mutableProxyListeners) {
        [self.mutableProxyListeners addObject:delegate];
    }
}

- (void)removeDelegate:(NSObject<SDLProxyListener> *)delegate {
    @synchronized(self.mutableProxyListeners) {
        [self.mutableProxyListeners removeObject:delegate];
    }
}

- (void)sdl_invokeMethodOnDelegates:(SEL)aSelector withObject:(nullable id)object {
    // Occurs on the processing serial queue
    for (id<SDLProxyListener> listener in self.proxyListeners) {
        if ([listener respondsToSelector:aSelector]) {
            // HAX: http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
            ((void (*)(id, SEL, id))[(NSObject *)listener methodForSelector:aSelector])(listener, aSelector, object);
        }
    }
}

@end

NS_ASSUME_NONNULL_END
