//
//  SDLLifecycleManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/19/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLLifecycleManager.h"

#import "NSMapTable+Subscripting.h"
#import "SDLConfiguration.h"
#import "SDLConnectionManagerType.h"
#import "SDLDebugTool.h"
#import "SDLDisplayCapabilities.h"
#import "SDLError.h"
#import "SDLFile.h"
#import "SDLFileManager.h"
#import "SDLHMILevel.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLLockScreenManager.h"
#import "SDLLockScreenPresenter.h"
#import "SDLManagerDelegate.h"
#import "SDLNotificationDispatcher.h"
#import "SDLOnAppInterfaceUnregistered.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnHashChange.h"
#import "SDLPermissionManager.h"
#import "SDLProxy.h"
#import "SDLProxyFactory.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRegisterAppInterface.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLResponseDispatcher.h"
#import "SDLResult.h"
#import "SDLSetAppIcon.h"
#import "SDLStateMachine.h"
#import "SDLUnregisterAppInterface.h"


NS_ASSUME_NONNULL_BEGIN

SDLLifecycleState *const SDLLifecycleStateStopped = @"Stopped";
SDLLifecycleState *const SDLLifecycleStateStarted = @"Started";
SDLLifecycleState *const SDLLifecycleStateReconnecting = @"Reconnecting";
SDLLifecycleState *const SDLLifecycleStateConnected = @"Connected";
SDLLifecycleState *const SDLLifecycleStateRegistered = @"Registered";
SDLLifecycleState *const SDLLifecycleStateSettingUpManagers = @"SettingUpManagers";
SDLLifecycleState *const SDLLifecycleStatePostManagerProcessing = @"PostManagerProcessing";
SDLLifecycleState *const SDLLifecycleStateUnregistering = @"Unregistering";
SDLLifecycleState *const SDLLifecycleStateReady = @"Ready";

#pragma mark - SDLManager Private Interface

@interface SDLLifecycleManager () <SDLConnectionManagerType>

// Readonly public properties
@property (copy, nonatomic, readwrite) SDLConfiguration *configuration;
@property (strong, nonatomic, readwrite) SDLNotificationDispatcher *notificationDispatcher;
@property (strong, nonatomic, readwrite) SDLResponseDispatcher *responseDispatcher;
@property (strong, nonatomic, readwrite) SDLStateMachine *lifecycleStateMachine;

// Private properties
@property (copy, nonatomic) SDLManagerReadyBlock readyHandler;

@end


@implementation SDLLifecycleManager

#pragma mark Lifecycle

- (instancetype)init {
    return [self initWithConfiguration:[SDLConfiguration configurationWithLifecycle:[SDLLifecycleConfiguration defaultConfigurationWithAppName:@"SDL APP" appId:@"001"] lockScreen:[SDLLockScreenConfiguration disabledConfiguration]] delegate:nil];
}

- (instancetype)initWithConfiguration:(SDLConfiguration *)configuration delegate:(nullable id<SDLManagerDelegate>)delegate {
    self = [super init];
    if (!self) {
        return nil;
    }

    // Dependencies
    _configuration = configuration;
    _delegate = delegate;

    // Logging
    [self.class sdl_updateLoggingWithFlags:self.configuration.lifecycleConfig.logFlags];

    // Private properties
    _lifecycleStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLLifecycleStateStopped states:[self.class sdl_stateTransitionDictionary]];
    _lastCorrelationId = 0;
    _notificationDispatcher = [[SDLNotificationDispatcher alloc] init];
    _responseDispatcher = [[SDLResponseDispatcher alloc] initWithNotificationDispatcher:_notificationDispatcher];
    _registerResponse = nil;

    // Managers
    _fileManager = [[SDLFileManager alloc] initWithConnectionManager:self];
    _permissionManager = [[SDLPermissionManager alloc] init];
    _lockScreenManager = [[SDLLockScreenManager alloc] initWithConfiguration:_configuration.lockScreenConfig notificationDispatcher:_notificationDispatcher presenter:[[SDLLockScreenPresenter alloc] init]];

    // Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transportDidConnect) name:SDLTransportDidConnect object:_notificationDispatcher];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transportDidDisconnect) name:SDLTransportDidDisconnect object:_notificationDispatcher];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hmiStatusDidChange:) name:SDLDidChangeHMIStatusNotification object:_notificationDispatcher];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteHardwareDidUnregister:) name:SDLDidReceiveAppUnregisteredNotification object:_notificationDispatcher];

    return self;
}

- (void)startWithReadyHandler:(SDLManagerReadyBlock)readyHandler {
    if (![self.lifecycleStateMachine isCurrentState:SDLLifecycleStateStopped]) {
        [SDLDebugTool logFormat:@"Warning: SDL has already been started, this attempt will be ignored."];
        return;
    }
    
    self.readyHandler = [readyHandler copy];

    [self.lifecycleStateMachine transitionToState:SDLLifecycleStateStarted];
}

- (void)stop {
    if ([self.lifecycleStateMachine isCurrentState:SDLLifecycleStateReady]) {
        [self.lifecycleStateMachine transitionToState:SDLLifecycleStateUnregistering];
    } else {
        [self.lifecycleStateMachine transitionToState:SDLLifecycleStateStopped];
    }
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
        SDLLifecycleStateStopped: @[SDLLifecycleStateStarted],
        SDLLifecycleStateStarted : @[SDLLifecycleStateConnected, SDLLifecycleStateStopped, SDLLifecycleStateReconnecting],
        SDLLifecycleStateReconnecting: @[SDLLifecycleStateStarted],
        SDLLifecycleStateConnected: @[SDLLifecycleStateStopped, SDLLifecycleStateReconnecting, SDLLifecycleStateRegistered],
        SDLLifecycleStateRegistered: @[SDLLifecycleStateStopped, SDLLifecycleStateReconnecting, SDLLifecycleStateSettingUpManagers],
        SDLLifecycleStateSettingUpManagers: @[SDLLifecycleStateStopped, SDLLifecycleStateReconnecting, SDLLifecycleStatePostManagerProcessing],
        SDLLifecycleStatePostManagerProcessing: @[SDLLifecycleStateStopped, SDLLifecycleStateReconnecting, SDLLifecycleStateReady],
        SDLLifecycleStateUnregistering: @[SDLLifecycleStateStopped],
        SDLLifecycleStateReady: @[SDLLifecycleStateUnregistering, SDLLifecycleStateStopped, SDLLifecycleStateReconnecting]
    };
}

- (void)didEnterStateStarted {
    // Start up the internal proxy object
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (self.configuration.lifecycleConfig.tcpDebugMode) {
        self.proxy = [SDLProxyFactory buildSDLProxyWithListener:self.notificationDispatcher tcpIPAddress:self.configuration.lifecycleConfig.tcpDebugIPAddress tcpPort:[@(self.configuration.lifecycleConfig.tcpDebugPort) stringValue]];
    } else {
        self.proxy = [SDLProxyFactory buildSDLProxyWithListener:self.notificationDispatcher];
    }
#pragma clang diagnostic pop
}

- (void)didEnterStateStopped {
    [self sdl_stopManager:NO];
}

- (void)didEnterStateReconnecting {
    [self sdl_stopManager:YES];
}

- (void)sdl_stopManager:(BOOL)shouldRestart {
    [self.fileManager stop];
    [self.permissionManager stop];
    [self.lockScreenManager stop];
    [self.responseDispatcher clear];

    self.registerResponse = nil;
    self.lastCorrelationId = 0;
    self.hmiLevel = nil;

    [self sdl_disposeProxy]; // call this method instead of stopProxy to avoid double-dispatching

    // Due to a race condition internally with EAStream, we cannot immediately attempt to restart the proxy, as we will randomly crash.
    // Apple Bug ID #30059457
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.delegate managerDidDisconnect];

        if (shouldRestart) {
            [weakSelf.lifecycleStateMachine transitionToState:SDLLifecycleStateStarted];
        }
    });
}

- (void)didEnterStateConnected {
    // If we have security managers, add them to the proxy
    if (self.configuration.lifecycleConfig.securityManagers != nil) {
        [self.proxy addSecurityManagers:self.configuration.lifecycleConfig.securityManagers forAppId:self.configuration.lifecycleConfig.appId];
    }

    // Build a register app interface request with the configuration data
    SDLRegisterAppInterface *regRequest = [[SDLRegisterAppInterface alloc] initWithLifecycleConfiguration:self.configuration.lifecycleConfig];

    // Send the request and depending on the response, post the notification
    __weak typeof(self) weakSelf = self;
    [self sdl_sendRequest:regRequest
        withResponseHandler:^(__kindof SDLRPCRequest *_Nullable request, __kindof SDLRPCResponse *_Nullable response, NSError *_Nullable error) {
            // If the success BOOL is NO or we received an error at this point, we failed. Call the ready handler and transition to the DISCONNECTED state.
            if (error != nil || ![response.success boolValue]) {
                [SDLDebugTool logFormat:@"Failed to register the app. Error: %@, Response: %@", error, response];
                weakSelf.readyHandler(NO, error);
                [weakSelf.lifecycleStateMachine transitionToState:SDLLifecycleStateStopped];
                return;
            }

            weakSelf.registerResponse = (SDLRegisterAppInterfaceResponse *)response;
            [weakSelf.lifecycleStateMachine transitionToState:SDLLifecycleStateRegistered];
        }];
}

- (void)didEnterStateRegistered {
    [self.lifecycleStateMachine transitionToState:SDLLifecycleStateSettingUpManagers];
}

- (void)didEnterStateSettingUpManagers {
    dispatch_group_t managerGroup = dispatch_group_create();

    // Make sure there's at least one group_enter until we have synchronously run through all the startup calls
    dispatch_group_enter(managerGroup);

    [self.lockScreenManager start];

    dispatch_group_enter(managerGroup);
    [self.fileManager startWithCompletionHandler:^(BOOL success, NSError *_Nullable error) {
        if (!success) {
            [SDLDebugTool logFormat:@"File manager was unable to start; error: %@", error];
        }

        dispatch_group_leave(managerGroup);
    }];

    dispatch_group_enter(managerGroup);
    [self.permissionManager startWithCompletionHandler:^(BOOL success, NSError *_Nullable error) {
        if (!success) {
            [SDLDebugTool logFormat:@"Permission manager was unable to start; error: %@", error];
        }

        dispatch_group_leave(managerGroup);
    }];

    // We're done synchronously calling all startup methods, so we can now wait.
    dispatch_group_leave(managerGroup);

    // When done, we want to transition, even if there were errors. They may be expected, e.g. on head units that do not support files.
    dispatch_group_notify(managerGroup, dispatch_get_main_queue(), ^{
        [self.lifecycleStateMachine transitionToState:SDLLifecycleStatePostManagerProcessing];
    });
}

- (void)didEnterStatePostManagerProcessing {
    // We only want to send the app icon when the file manager is complete, and when that's done, set the state to ready
    [self sdl_sendAppIcon:self.configuration.lifecycleConfig.appIcon
           withCompletion:^{
               [self.lifecycleStateMachine transitionToState:SDLLifecycleStateReady];
           }];
}

- (void)didEnterStateReady {
    SDLResult *registerResult = self.registerResponse.resultCode;
    NSString *registerInfo = self.registerResponse.info;
    NSError *startError = nil;

    // If the resultCode isn't success, we got a warning. Errors were handled in `didEnterStateConnected`.
    if (![registerResult isEqualToEnum:[SDLResult SUCCESS]]) {
        startError = [NSError sdl_lifecycle_startedWithBadResult:registerResult info:registerInfo];
    }

    // If we got to this point, we succeeded, send the error if there was a warning.
    self.readyHandler(YES, startError);
    [self.notificationDispatcher postNotificationName:SDLDidBecomeReady infoObject:nil];

    // Send the hmi level going from NONE to whatever we're at now (could still be NONE)
    [self.delegate hmiLevel:[SDLHMILevel NONE] didChangeToLevel:self.hmiLevel];
}

- (void)didEnterStateUnregistering {
    SDLUnregisterAppInterface *unregisterRequest = [[SDLUnregisterAppInterface alloc] init];

    __weak typeof(self) weakSelf = self;
    [self sdl_sendRequest:unregisterRequest
        withResponseHandler:^(__kindof SDLRPCRequest *_Nullable request, __kindof SDLRPCResponse *_Nullable response, NSError *_Nullable error) {
            if (error != nil || ![response.success boolValue]) {
                [SDLDebugTool logFormat:@"SDL Error unregistering, we are going to hard disconnect: %@, response: %@", error, response];
            }

            [weakSelf.lifecycleStateMachine transitionToState:SDLLifecycleStateStopped];
        }];
}


#pragma mark Post Manager Setup Processing

- (void)sdl_sendAppIcon:(nullable SDLFile *)appIcon withCompletion:(void (^)(void))completion {
    // If no app icon was set, just move on to ready
    if (appIcon == nil || !self.registerResponse.displayCapabilities.graphicSupported.boolValue) {
        completion();
        return;
    }

    [self.fileManager uploadFile:appIcon
               completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError *_Nullable error) {
                   // These errors could be recoverable (particularly "cannot overwrite"), so we'll still attempt to set the app icon
                   if (error != nil) {
                       if (error.code == SDLFileManagerErrorCannotOverwrite) {
                           [SDLDebugTool logInfo:@"Failed to upload app icon: A file with this name already exists on the system"];
                       } else {
                           [SDLDebugTool logFormat:@"Unexpected error uploading app icon: %@", error];
                           return;
                       }
                   }

                   // Once we've tried to put the file on the remote system, try to set the app icon
                   SDLSetAppIcon *setAppIcon = [[SDLSetAppIcon alloc] init];
                   setAppIcon.syncFileName = appIcon.name;

                   [self sdl_sendRequest:setAppIcon
                       withResponseHandler:^(__kindof SDLRPCRequest *_Nullable request, __kindof SDLRPCResponse *_Nullable response, NSError *_Nullable error) {
                           if (error != nil) {
                               [SDLDebugTool logFormat:@"Error setting app icon: ", error];
                           }

                           // We've succeeded or failed
                           completion();
                       }];
               }];
}


#pragma mark Sending Requests

- (void)sendRequest:(SDLRPCRequest *)request {
    [self sendRequest:request withResponseHandler:nil];
}

- (void)sendRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    if (![self.lifecycleStateMachine isCurrentState:SDLLifecycleStateReady]) {
        [SDLDebugTool logInfo:@"Manager not ready, message not sent"];
        if (handler) {
            handler(request, nil, [NSError sdl_lifecycle_notReadyError]);
        }

        return;
    }

    [self sdl_sendRequest:request withResponseHandler:handler];
}

// Managers need to avoid state checking. Part of <SDLConnectionManagerType>.
- (void)sendManagerRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)block {
    [self sdl_sendRequest:request withResponseHandler:block];
}

- (void)sdl_sendRequest:(SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    // We will allow things to be sent in a "SDLLifeCycleStateConnected" state in the private method, but block it in the public method sendRequest:withCompletionHandler: so that the lifecycle manager can complete its setup without being bothered by developer error

    NSParameterAssert(request != nil);

    // If, for some reason, the request is nil we should error out.
    if (!request) {
        if (handler) {
            handler(nil, nil, [NSError sdl_lifecycle_rpcErrorWithDescription:@"Nil Request Sent" andReason:@"A nil RPC request was passed and cannot be sent."]);
        }
        return;
    }

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
}

- (NSNumber *)sdl_getNextCorrelationId {
    if (self.lastCorrelationId == UINT16_MAX) {
        self.lastCorrelationId = 0;
    }

    return @(++self.lastCorrelationId);
}

+ (BOOL)sdl_checkNotification:(NSNotification *)notification containsKindOfClass:(Class)class {
    NSAssert([notification.userInfo[SDLNotificationUserInfoObject] isKindOfClass:class], @"A notification was sent with an unanticipated object");
    if (![notification.userInfo[SDLNotificationUserInfoObject] isKindOfClass:class]) {
        return NO;
    }

    return YES;
}

+ (void)sdl_updateLoggingWithFlags : (SDLLogOutput)logFlags {
    if (logFlags == SDLLogOutputNone) {
        [SDLDebugTool disable];
        return;
    }

    if ((logFlags & SDLLogOutputConsole) == SDLLogOutputConsole) {
        [SDLDebugTool enable];
    }

    if ((logFlags & SDLLogOutputFile) == SDLLogOutputFile) {
        [SDLDebugTool enableDebugToLogFile];
    } else {
        [SDLDebugTool disableDebugToLogFile];
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ((logFlags & SDLLogOutputSiphon) == SDLLogOutputSiphon) {
        [SDLProxy enableSiphonDebug];
    } else {
        [SDLProxy disableSiphonDebug];
    }
#pragma clang diagnostic pop
}


#pragma mark SDL notification observers

- (void)transportDidConnect {
    [self.lifecycleStateMachine transitionToState:SDLLifecycleStateConnected];
}

- (void)transportDidDisconnect {
    if (self.lifecycleState == SDLLifecycleStateUnregistering || self.lifecycleState == SDLLifecycleStateStopped) {
        [self.lifecycleStateMachine transitionToState:SDLLifecycleStateStopped];
    } else {
        [self.lifecycleStateMachine transitionToState:SDLLifecycleStateReconnecting];
    }
}

- (void)hmiStatusDidChange:(SDLRPCNotificationNotification *)notification {
    if (![self.class sdl_checkNotification:notification containsKindOfClass:[SDLOnHMIStatus class]]) {
        return;
    }

    SDLOnHMIStatus *hmiStatusNotification = notification.notification;
    SDLHMILevel *oldHMILevel = self.hmiLevel;
    self.hmiLevel = hmiStatusNotification.hmiLevel;

    if (![self.lifecycleStateMachine isCurrentState:SDLLifecycleStateReady]) {
        return;
    }

    if (![oldHMILevel isEqualToEnum:self.hmiLevel]) {
        [self.delegate hmiLevel:oldHMILevel didChangeToLevel:self.hmiLevel];
    }
}

- (void)remoteHardwareDidUnregister:(SDLRPCNotificationNotification *)notification {
    if (![self.class sdl_checkNotification:notification containsKindOfClass:[SDLOnAppInterfaceUnregistered class]]) {
        return;
    }

    SDLOnAppInterfaceUnregistered *appUnregisteredNotification = notification.notification;
    [SDLDebugTool logFormat:@"Remote Device forced unregistration for reason: %@", appUnregisteredNotification.reason];

    if ([self.lifecycleStateMachine isCurrentState:SDLLifecycleStateUnregistering]) {
        [self.lifecycleStateMachine transitionToState:SDLLifecycleStateStopped];
    } else if ([self.lifecycleStateMachine isCurrentState:SDLLifecycleStateStopped]) {
        return;
    } else {
        [self.lifecycleStateMachine transitionToState:SDLLifecycleStateReconnecting];
    }
}

@end

NS_ASSUME_NONNULL_END
