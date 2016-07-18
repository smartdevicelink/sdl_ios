

#import <Foundation/Foundation.h>

#import "SmartDeviceLink.h"

#import "SDLManager.h"

#import "NSMapTable+Subscripting.h"
#import "SDLConnectionManagerType.h"
#import "SDLLockScreenManager.h"
#import "SDLLockScreenPresenter.h"
#import "SDLNotificationDispatcher.h"
#import "SDLResponseDispatcher.h"
#import "SDLStateMachine.h"


NS_ASSUME_NONNULL_BEGIN

#pragma mark - Private Typedefs and Constants

NSString *const SDLLifecycleStateDisconnected = @"TransportDisconnected";
NSString *const SDLLifecycleStateTransportConnected = @"TransportConnected";
NSString *const SDLLifecycleStateRegistered = @"Registered";
NSString *const SDLLifecycleStateSettingUpManagers = @"SettingUpManagers";
NSString *const SDLLifecycleStatePostManagerProcessing = @"PostManagerProcessing";
NSString *const SDLLifecycleStateUnregistering = @"Unregistering";
NSString *const SDLLifecycleStateReady = @"Ready";


#pragma mark - SDLManager Private Interface

@interface SDLManager () <SDLConnectionManagerType>

// Readonly public properties
@property (copy, nonatomic, readwrite) SDLHMILevel *currentHMILevel;
@property (copy, nonatomic, readwrite) SDLConfiguration *configuration;
@property (strong, nonatomic, readwrite) SDLFileManager *fileManager;
@property (strong, nonatomic, readwrite) SDLPermissionManager *permissionManager;
@property (strong, nonatomic, readwrite) SDLStateMachine *lifecycleStateMachine;

// Deprecated internal proxy
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (strong, nonatomic, nullable) SDLProxy *proxy;
#pragma clang diagnostic pop

// Internal properties
@property (assign, nonatomic) UInt32 correlationID;
@property (assign, nonatomic) BOOL firstHMIFullOccurred;
@property (assign, nonatomic) BOOL firstHMINotNoneOccurred;
@property (strong, nonatomic, nullable) SDLOnHashChange *resumeHash;
@property (strong, nonatomic, nullable) SDLRegisterAppInterfaceResponse *registerAppInterfaceResponse;

@property (strong, nonatomic) SDLLockScreenManager *lockScreenManager;
@property (strong, nonatomic) SDLNotificationDispatcher *notificationDispatcher;
@property (strong, nonatomic) SDLResponseDispatcher *responseDispatcher;
@property (weak, nonatomic, nullable) id<SDLManagerDelegate> delegate;

@end


#pragma mark - SDLManager Implementation

@implementation SDLManager

#pragma mark Lifecycle

- (instancetype)init {
    return [self initWithConfiguration:[SDLConfiguration configurationWithLifecycle:[SDLLifecycleConfiguration defaultConfigurationWithAppName:@"SDL APP" appId:@"001"] lockScreen:nil] delegate:nil];
}

- (instancetype)initWithConfiguration:(SDLConfiguration *)configuration delegate:(nullable id<SDLManagerDelegate>)delegate {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // Dependencies
    _configuration = configuration;
    _delegate = delegate;
    
    // Private properties
    _lifecycleStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLLifecycleStateDisconnected states:[self.class sdl_stateTransitionDictionary]];
    _correlationID = 1;
    _firstHMIFullOccurred = NO;
    _firstHMINotNoneOccurred = NO;
    _notificationDispatcher = [[SDLNotificationDispatcher alloc] init];
    _responseDispatcher = [[SDLResponseDispatcher alloc] initWithNotificationDispatcher:_notificationDispatcher];
    _registerAppInterfaceResponse = nil;
    
    // Managers
    _fileManager = [[SDLFileManager alloc] initWithConnectionManager:self];
    _permissionManager = [[SDLPermissionManager alloc] init];
    _lockScreenManager = [[SDLLockScreenManager alloc] initWithConfiguration:_configuration.lockScreenConfig notificationDispatcher:_notificationDispatcher presenter:[[SDLLockScreenPresenter alloc] init]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerAppInterfaceResponseRecieved:) name:SDLDidReceiveRegisterAppInterfaceResponse object:_notificationDispatcher];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hmiStatusDidChange:) name:SDLDidChangeHMIStatusNotification object:_notificationDispatcher];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hashDidChange:) name:SDLDidReceiveNewHashNotification object:_notificationDispatcher];
    
    return self;
}

- (void)start {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [SDLProxy enableSiphonDebug];
    
    if (self.configuration.lifecycleConfig.tcpDebugMode) {
        self.proxy = [SDLProxyFactory buildSDLProxyWithListener:self.notificationDispatcher tcpIPAddress:self.configuration.lifecycleConfig.tcpDebugIPAddress tcpPort:self.configuration.lifecycleConfig.tcpDebugPort];
    } else {
        self.proxy = [SDLProxyFactory buildSDLProxyWithListener:self.notificationDispatcher];
    }
#pragma clang diagnostic pop
}

- (void)sdl_startProxy {
    [self start];
}

- (void)stop {
    [self.lifecycleStateMachine transitionToState:SDLLifecycleStateUnregistering];
}


#pragma mark Getters

- (nullable SDLStreamingMediaManager *)streamManager {
    return self.proxy.streamingMediaManager;
}

- (SDLState *)lifecycleState {
    return self.lifecycleStateMachine.currentState;
}


#pragma mark State Machine

+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_stateTransitionDictionary {
    return @{
             SDLLifecycleStateDisconnected: @[SDLLifecycleStateTransportConnected],
             SDLLifecycleStateTransportConnected: @[SDLLifecycleStateDisconnected, SDLLifecycleStateRegistered],
             SDLLifecycleStateRegistered: @[SDLLifecycleStateDisconnected, SDLLifecycleStateSettingUpManagers],
             SDLLifecycleStateSettingUpManagers: @[SDLLifecycleStateDisconnected, SDLLifecycleStatePostManagerProcessing],
             SDLLifecycleStatePostManagerProcessing: @[SDLLifecycleStateDisconnected, SDLLifecycleStateReady],
             SDLLifecycleStateUnregistering: @[SDLLifecycleStateDisconnected],
             SDLLifecycleStateReady: @[SDLLifecycleStateUnregistering,SDLLifecycleStateDisconnected]
             };
}

- (void)didEnterStateTransportDisconnected {
    [self.fileManager stop];
    [self.permissionManager stop];
    [self.lockScreenManager stop];
    
    [self sdl_disposeProxy]; // call this method instead of stopProxy to avoid double-dispatching
    [self.notificationDispatcher postNotification:SDLTransportDidDisconnect info:nil];
    [self.delegate managerDidDisconnect];
    
    [self sdl_startProxy];
}

- (void)didEnterStateTransportConnected {
    // Make sure to post the did connect notification to start preheating some other objects as well while we wait for the RAIR
    [self.notificationDispatcher postNotification:SDLTransportDidConnect info:nil];
    
    // Build a register app interface request with the configuration data
    SDLRegisterAppInterface *regRequest = [SDLRPCRequestFactory buildRegisterAppInterfaceWithAppName:self.configuration.lifecycleConfig.appName languageDesired:self.configuration.lifecycleConfig.language appID:self.configuration.lifecycleConfig.appId];
    regRequest.isMediaApplication = @(self.configuration.lifecycleConfig.isMedia);
    regRequest.ngnMediaScreenAppName = self.configuration.lifecycleConfig.shortAppName;
    
    // TODO: Should the hash be removed under any conditions?
    if (self.resumeHash != nil) {
        regRequest.hashID = self.resumeHash.hashID;
    }
    
    regRequest.vrSynonyms = [NSMutableArray arrayWithArray:self.configuration.lifecycleConfig.voiceRecognitionSynonyms];
    
    // Send the request and depending on the response, post the notification
    [self sdl_sendRequest:regRequest withCompletionHandler:nil];
}

- (void)didEnterStateRegistered {
    // TODO: Anything?
    [self.lifecycleStateMachine transitionToState:SDLLifecycleStateSettingUpManagers];
}

- (void)didEnterStateSettingUpManagers {
    dispatch_group_t managerGroup = dispatch_group_create();
    
    // Make sure there's at least one group_enter until we have synchronously run through all the startup calls
    dispatch_group_enter(managerGroup);
    
    [self.lockScreenManager start];
    
    // When done, we want to transition
    dispatch_group_notify(managerGroup, dispatch_get_main_queue(), ^{
        [self.lifecycleStateMachine transitionToState:SDLLifecycleStatePostManagerProcessing];
    });
    
    dispatch_group_enter(managerGroup);
    [self.fileManager startWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_group_leave(managerGroup);
    }];
    
    dispatch_group_enter(managerGroup);
    [self.permissionManager startWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_group_leave(managerGroup);
    }];
    
    // We're done synchronously calling all startup methods, so we can now wait.
    dispatch_group_leave(managerGroup);
}

- (void)didEnterStatePostManagerProcessing {
    // TODO: SetDisplayLayout (only after HMI_FULL?)
    [self sdl_sendAppIcon:self.configuration.lifecycleConfig.appIcon withCompletion:^{
        [self.lifecycleStateMachine transitionToState:SDLLifecycleStateReady];
    }];
}

- (void)didEnterStateReady {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.notificationDispatcher postNotification:SDLDidBecomeReady info:nil];
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(managerDidBecomeReady)]) {
            [self.delegate managerDidBecomeReady];
        }
    });
}

- (void)didEnterStateUnregistering {
    SDLUnregisterAppInterface *unregisterRequest = [SDLRPCRequestFactory buildUnregisterAppInterfaceWithCorrelationID:[self sdl_getNextCorrelationId]];
    
    __weak typeof(self) weakSelf = self;
    [self sendRequest:unregisterRequest withCompletionHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [weakSelf.lifecycleStateMachine transitionToState:SDLLifecycleStateDisconnected];
    }];
}

#pragma mark Post Manager Setup Processing

- (void)sdl_sendAppIcon:(nullable SDLFile *)appIcon withCompletion:(void(^)(void))completion {
    // If no app icon was set, just move on to ready
    if (appIcon == nil) {
        completion();
        return;
    }
    
    [self.fileManager uploadFile:appIcon completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
        // These errors could be recoverable (particularly "cannot overwrite"), so we'll still attempt to set the app icon
        if (error != nil) {
            if (error.code == SDLFileManagerErrorCannotOverwrite) {
                [SDLDebugTool logInfo:@"Failed to upload app icon: A file with this name already exists on the system"];
            } else {
                [SDLDebugTool logFormat:@"Unexpected error uploading app icon: %@", error];
            }
        }
        
        // Once we've tried to put the file on the remote system, try to set the app icon
        SDLSetAppIcon *setAppIconRequest = [[SDLSetAppIcon alloc] initWithName:appIcon.name];
        [self sendRequest:setAppIconRequest withCompletionHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (error != nil) {
                [SDLDebugTool logFormat:@"Error setting app icon: ", error];
            }
            
            // We've succeeded or failed
            completion();
        }];
    }];
}


#pragma mark SDLConnectionManager Protocol

- (void)sendRequest:(SDLRPCRequest *)request {
    [self sendRequest:request withCompletionHandler:nil];
}

- (void)sendRequest:(__kindof SDLRPCRequest *)request withCompletionHandler:(nullable SDLRequestCompletionHandler)handler {
    // TODO: This is going to prevent managers from sending anything
    if (![self.lifecycleStateMachine isCurrentState:SDLLifecycleStateReady]) {
        [SDLDebugTool logInfo:@"Manager not ready, will not send RPC until state is Ready"];
        if (handler) {
            handler(nil, nil, [NSError sdl_lifecycle_notReadyError]);
        }
        
        return;
    }
    
    [self sdl_sendRequest:request withCompletionHandler:handler];
}

- (void)sdl_sendRequest:(SDLRPCRequest *)request withCompletionHandler:(nullable SDLRequestCompletionHandler)handler {
    // We will allow things to be sent in a "SDLLifeCycleStateTransportConnected" in the private method, but block it in the public method sendRequest:withCompletionHandler: so that the lifecycle manager can complete its setup without being bothered by developer error
    
    // Add a correlation ID to the request
    NSNumber *corrID = [self sdl_getNextCorrelationId];
    request.correlationID = corrID;
    
    [self.responseDispatcher storeRequest:request handler:handler];
    [self.proxy sendRPC:request];
}


#pragma mark Helper Methods

- (void)sdl_disposeProxy {
    [SDLDebugTool logInfo:@"Stop Proxy"];
    [self.proxy dispose];
    self.proxy = nil;
    self.firstHMIFullOccurred = NO;
    self.firstHMINotNoneOccurred = NO;
}

- (NSNumber *)sdl_getNextCorrelationId {
    if (self.correlationID == UINT16_MAX) {
        self.correlationID = 1;
    }
    
    return @(self.correlationID++);
}


#pragma mark SDLProxyListener Methods

// TODO: These are notification handlers now, change object type
- (void)registerAppInterfaceResponseRecieved:(NSNotification *)notification {
    SDLRegisterAppInterfaceResponse *registerAppInterfaceResponse = notification.userInfo[SDLNotificationUserInfoObject];
    self.registerAppInterfaceResponse = registerAppInterfaceResponse;
    
    [self.lifecycleStateMachine transitionToState:SDLLifecycleStateRegistered];
}

- (void)hmiStatusDidChange:(NSNotification *)notification {
    SDLOnHMIStatus *hmiStatusNotification = notification.userInfo[SDLNotificationUserInfoObject];
    
    if (hmiStatusNotification.hmiLevel == [SDLHMILevel FULL]) {
        BOOL occurred = NO;
        occurred = self.firstHMINotNoneOccurred;
        if (!occurred) {
//            [self.notificationDispatcher postNotification:SDLDidReceiveFirstNonNoneHMIStatusNotification info:notification];
        }
        self.firstHMINotNoneOccurred = YES;
        
        occurred = self.firstHMIFullOccurred;
        if (!occurred) {
//            [self.notificationDispatcher postNotification:SDLDidReceiveFirstFullHMIStatusNotification info:notification];
        }
        self.firstHMIFullOccurred = YES;
    } else if (hmiStatusNotification.hmiLevel == [SDLHMILevel BACKGROUND] || hmiStatusNotification.hmiLevel == [SDLHMILevel LIMITED]) {
        BOOL occurred = NO;
        occurred = self.firstHMINotNoneOccurred;
        if (!occurred) {
//            [self.notificationDispatcher postNotification:SDLDidReceiveFirstNonNoneHMIStatusNotification info:notification];
        }
        self.firstHMINotNoneOccurred = YES;
    }
    
    self.currentHMILevel = hmiStatusNotification.hmiLevel;
    [self.notificationDispatcher postNotification:SDLDidChangeHMIStatusNotification info:notification];
}

- (void)hashDidChange:(NSNotification *)notification {
    SDLOnHashChange *hashChangeNotification = notification.userInfo[SDLNotificationUserInfoObject];
    
    self.resumeHash = hashChangeNotification;
}

- (void)remoteHardwareDidUnregister:(NSNotification *)notification {
    SDLOnAppInterfaceUnregistered *appUnregisteredNotification = notification.userInfo[SDLNotificationUserInfoObject];
    [SDLDebugTool logFormat:@"Remote Device forced unregistration for reason: %@", appUnregisteredNotification.reason];
    
    [self.lifecycleStateMachine transitionToState:SDLLifecycleStateDisconnected];
}

@end

NS_ASSUME_NONNULL_END
