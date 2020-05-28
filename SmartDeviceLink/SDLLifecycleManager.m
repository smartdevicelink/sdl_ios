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
#import "SDLAsynchronousRPCRequestOperation.h"
#import "SDLBackgroundTaskManager.h"
#import "SDLChangeRegistration.h"
#import "SDLConfiguration.h"
#import "SDLConnectionManagerType.h"
#import "SDLEncryptionConfiguration.h"
#import "SDLLogMacros.h"
#import "SDLError.h"
#import "SDLEncryptionLifecycleManager.h"
#import "SDLFile.h"
#import "SDLFileManager.h"
#import "SDLFileManagerConfiguration.h"
#import "SDLGlobals.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLifecycleConfigurationUpdate.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLLockScreenManager.h"
#import "SDLLockScreenPresenter.h"
#import "SDLLogConfiguration.h"
#import "SDLLogFileModuleMap.h"
#import "SDLLogManager.h"
#import "SDLManagerDelegate.h"
#import "SDLNotificationDispatcher.h"
#import "SDLOnAppInterfaceUnregistered.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnHashChange.h"
#import "SDLPermissionManager.h"
#import "SDLPredefinedWindows.h"
#import "SDLProtocol.h"
#import "SDLProxy.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRegisterAppInterface.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLResponseDispatcher.h"
#import "SDLAsynchronousRPCOperation.h"
#import "SDLResult.h"
#import "SDLScreenManager.h"
#import "SDLSecondaryTransportManager.h"
#import "SDLSequentialRPCRequestOperation.h"
#import "SDLSetAppIcon.h"
#import "SDLStateMachine.h"
#import "SDLStreamingMediaConfiguration.h"
#import "SDLStreamingMediaManager.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLUnregisterAppInterface.h"
#import "SDLVersion.h"
#import "SDLWindowCapability.h"

NS_ASSUME_NONNULL_BEGIN

SDLLifecycleState *const SDLLifecycleStateStopped = @"Stopped";
SDLLifecycleState *const SDLLifecycleStateStarted = @"Started";
SDLLifecycleState *const SDLLifecycleStateReconnecting = @"Reconnecting";
SDLLifecycleState *const SDLLifecycleStateConnected = @"Connected";
SDLLifecycleState *const SDLLifecycleStateRegistered = @"Registered";
SDLLifecycleState *const SDLLifecycleStateUpdatingConfiguration = @"UpdatingConfiguration";
SDLLifecycleState *const SDLLifecycleStateSettingUpManagers = @"SettingUpManagers";
SDLLifecycleState *const SDLLifecycleStateSettingUpAppIcon = @"SettingUpAppIcon";
SDLLifecycleState *const SDLLifecycleStateSettingUpHMI = @"SettingUpHMI";
SDLLifecycleState *const SDLLifecycleStateUnregistering = @"Unregistering";
SDLLifecycleState *const SDLLifecycleStateReady = @"Ready";

NSString *const BackgroundTaskTransportName = @"com.sdl.transport.backgroundTask";

#pragma mark - Protected Class Interfaces
@interface SDLStreamingMediaManager ()

@property (strong, nonatomic, nullable) SDLSecondaryTransportManager *secondaryTransportManager;
- (void)startSecondaryTransportWithProtocol:(SDLProtocol *)protocol;

@end

#pragma mark - SDLLifecycleManager Private Interface

@interface SDLLifecycleManager () <SDLConnectionManagerType>

// Readonly public properties
@property (copy, nonatomic, readwrite) SDLConfiguration *configuration;
@property (strong, nonatomic, readwrite, nullable) NSString *authToken;
@property (strong, nonatomic, readwrite) SDLNotificationDispatcher *notificationDispatcher;
@property (strong, nonatomic, readwrite) SDLResponseDispatcher *responseDispatcher;
@property (strong, nonatomic, readwrite) SDLStateMachine *lifecycleStateMachine;

// Private properties
@property (strong, nonatomic, nullable) SDLSecondaryTransportManager *secondaryTransportManager;
@property (copy, nonatomic) SDLManagerReadyBlock readyHandler;
@property (copy, nonatomic) dispatch_queue_t lifecycleQueue;
@property (assign, nonatomic) int32_t lastCorrelationId;
@property (copy, nonatomic) SDLBackgroundTaskManager *backgroundTaskManager;
@property (copy, nonatomic) SDLEncryptionLifecycleManager *encryptionLifecycleManager;

@end


@implementation SDLLifecycleManager

#pragma mark Lifecycle

- (instancetype)init {
    return [self initWithConfiguration:[SDLConfiguration configurationWithLifecycle:[SDLLifecycleConfiguration defaultConfigurationWithAppName:@"SDL APP" fullAppId:@"001"] lockScreen:[SDLLockScreenConfiguration disabledConfiguration] logging:[SDLLogConfiguration defaultConfiguration] fileManager:[SDLFileManagerConfiguration defaultConfiguration]] delegate:nil];
}

- (instancetype)initWithConfiguration:(SDLConfiguration *)configuration delegate:(nullable id<SDLManagerDelegate>)delegate {
    self = [super init];
    if (!self) {
        return nil;
    }

    SDLLogV(@"Initializing Lifecycle Manager");

    // Dependencies
    _configuration = [configuration copy];
    _delegate = delegate;

    // Logging
    [SDLLogManager setConfiguration:_configuration.loggingConfig];

    // Private properties
    _lifecycleStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLLifecycleStateStopped states:[self.class sdl_stateTransitionDictionary]];
    _lastCorrelationId = 0;
    _notificationDispatcher = [[SDLNotificationDispatcher alloc] init];
    _responseDispatcher = [[SDLResponseDispatcher alloc] initWithNotificationDispatcher:_notificationDispatcher];
    _registerResponse = nil;

    _rpcOperationQueue = [[NSOperationQueue alloc] init];
    _rpcOperationQueue.name = @"com.sdl.lifecycle.rpcOperation.concurrent";
    _rpcOperationQueue.underlyingQueue = [SDLGlobals sharedGlobals].sdlConcurrentQueue;

    if (@available(iOS 10.0, *)) {
        _lifecycleQueue = dispatch_queue_create_with_target("com.sdl.lifecycle", DISPATCH_QUEUE_SERIAL, [SDLGlobals sharedGlobals].sdlProcessingQueue);
    } else {
        _lifecycleQueue = [SDLGlobals sharedGlobals].sdlProcessingQueue;
    }

    // Managers
    _fileManager = [[SDLFileManager alloc] initWithConnectionManager:self configuration:_configuration.fileManagerConfig];
    _permissionManager = [[SDLPermissionManager alloc] init];
    _lockScreenManager = [[SDLLockScreenManager alloc] initWithConfiguration:_configuration.lockScreenConfig notificationDispatcher:_notificationDispatcher presenter:[[SDLLockScreenPresenter alloc] init]];
    _systemCapabilityManager = [[SDLSystemCapabilityManager alloc] initWithConnectionManager:self];
    _screenManager = [[SDLScreenManager alloc] initWithConnectionManager:self fileManager:_fileManager systemCapabilityManager:_systemCapabilityManager];

    if ([self.class sdl_isStreamingConfiguration:self.configuration]) {
        _streamManager = [[SDLStreamingMediaManager alloc] initWithConnectionManager:self configuration:configuration systemCapabilityManager:self.systemCapabilityManager];
    } else {
        SDLLogV(@"Skipping StreamingMediaManager setup due to app type");
    }
    
    if (configuration.encryptionConfig.securityManagers != nil) {
        _encryptionLifecycleManager = [[SDLEncryptionLifecycleManager alloc] initWithConnectionManager:self configuration:_configuration.encryptionConfig];
    }

    // Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transportDidConnect) name:SDLTransportDidConnect object:_notificationDispatcher];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transportDidDisconnect) name:SDLTransportDidDisconnect object:_notificationDispatcher];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hmiStatusDidChange:) name:SDLDidChangeHMIStatusNotification object:_notificationDispatcher];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteHardwareDidUnregister:) name:SDLDidReceiveAppUnregisteredNotification object:_notificationDispatcher];

    _backgroundTaskManager = [[SDLBackgroundTaskManager alloc] initWithBackgroundTaskName: BackgroundTaskTransportName];

    return self;
}

- (void)startWithReadyHandler:(SDLManagerReadyBlock)readyHandler {
    dispatch_sync(_lifecycleQueue, ^{
        [self sdl_startWithReadyHandler:readyHandler];
    });
}

- (void)sdl_startWithReadyHandler:(SDLManagerReadyBlock)readyHandler {
    if (![self.lifecycleStateMachine isCurrentState:SDLLifecycleStateStopped]) {
        SDLLogW(@"Warning: SDL has already been started, this attempt will be ignored");
        return;
    }

    SDLLogD(@"Starting lifecycle manager");
    self.readyHandler = [readyHandler copy];

    [self sdl_transitionToState:SDLLifecycleStateStarted];
}

- (void)stop {
    dispatch_sync(_lifecycleQueue, ^{
        SDLLogD(@"Lifecycle manager stopped");
        if ([self.lifecycleStateMachine isCurrentState:SDLLifecycleStateReady]) {
            [self sdl_transitionToState:SDLLifecycleStateUnregistering];
        } else {
            [self sdl_transitionToState:SDLLifecycleStateStopped];
        }
    });
}

- (void)startRPCEncryption {
    [self.encryptionLifecycleManager startEncryptionService];
}

#pragma mark Getters

- (SDLState *)lifecycleState {
    return self.lifecycleStateMachine.currentState;
}


#pragma mark State Machine

+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_stateTransitionDictionary {
    return @{
        SDLLifecycleStateStopped: @[SDLLifecycleStateStarted],
        SDLLifecycleStateStarted: @[SDLLifecycleStateConnected, SDLLifecycleStateStopped, SDLLifecycleStateReconnecting],
        SDLLifecycleStateReconnecting: @[SDLLifecycleStateStarted, SDLLifecycleStateStopped],
        SDLLifecycleStateConnected: @[SDLLifecycleStateStopped, SDLLifecycleStateReconnecting, SDLLifecycleStateRegistered],
        SDLLifecycleStateRegistered: @[SDLLifecycleStateStopped, SDLLifecycleStateReconnecting, SDLLifecycleStateUnregistering, SDLLifecycleStateSettingUpManagers, SDLLifecycleStateUpdatingConfiguration],
        SDLLifecycleStateUpdatingConfiguration: @[SDLLifecycleStateStopped, SDLLifecycleStateReconnecting, SDLLifecycleStateSettingUpManagers],
        SDLLifecycleStateSettingUpManagers: @[SDLLifecycleStateStopped, SDLLifecycleStateReconnecting, SDLLifecycleStateSettingUpAppIcon],
        SDLLifecycleStateSettingUpAppIcon: @[SDLLifecycleStateStopped, SDLLifecycleStateReconnecting, SDLLifecycleStateSettingUpHMI],
        SDLLifecycleStateSettingUpHMI: @[SDLLifecycleStateStopped, SDLLifecycleStateReconnecting, SDLLifecycleStateReady],
        SDLLifecycleStateUnregistering: @[SDLLifecycleStateStopped],
        SDLLifecycleStateReady: @[SDLLifecycleStateUnregistering, SDLLifecycleStateStopped, SDLLifecycleStateReconnecting]
    };
}

- (void)didEnterStateStarted {
    // Start a background task so a session can be established even when the app is backgrounded.
    [self.backgroundTaskManager startBackgroundTask];

    // Start up the internal proxy object
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.secondaryTransportManager = nil;
    if (self.configuration.lifecycleConfig.tcpDebugMode) {
        self.proxy = [SDLProxy tcpProxyWithListener:self.notificationDispatcher
                                       tcpIPAddress:self.configuration.lifecycleConfig.tcpDebugIPAddress
                                            tcpPort:@(self.configuration.lifecycleConfig.tcpDebugPort).stringValue
                          secondaryTransportManager:self.secondaryTransportManager
                         encryptionLifecycleManager:self.encryptionLifecycleManager];
    } else if (self.configuration.lifecycleConfig.allowedSecondaryTransports == SDLSecondaryTransportsNone) {
        self.proxy = [SDLProxy iapProxyWithListener:self.notificationDispatcher secondaryTransportManager:nil encryptionLifecycleManager:self.encryptionLifecycleManager];
    } else {
        if ([self.class sdl_isStreamingConfiguration:self.configuration]) {
            // Reuse the queue to run the secondary transport manager's state machine
            self.secondaryTransportManager = [[SDLSecondaryTransportManager alloc] initWithStreamingProtocolDelegate:(id<SDLStreamingProtocolDelegate>)self.streamManager serialQueue:self.lifecycleQueue];
            self.streamManager.secondaryTransportManager = self.secondaryTransportManager;
        }

        self.proxy = [SDLProxy iapProxyWithListener:self.notificationDispatcher secondaryTransportManager:self.secondaryTransportManager encryptionLifecycleManager:self.encryptionLifecycleManager];
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
    SDLLogV(@"Stopping manager, %@", (shouldRestart ? @"will restart" : @"will not restart"));

    [self.proxy disconnectSession];
    self.proxy = nil;

    [self.fileManager stop];
    [self.permissionManager stop];
    [self.lockScreenManager stop];
    [self.screenManager stop];
    [self.encryptionLifecycleManager stop];
    [self.streamManager stop];
    [self.secondaryTransportManager stop];
    [self.systemCapabilityManager stop];
    [self.responseDispatcher clear];

    [self.rpcOperationQueue cancelAllOperations];

    self.registerResponse = nil;
    self.lastCorrelationId = 0;
    self.hmiLevel = nil;
    self.audioStreamingState = nil;
    self.videoStreamingState = nil;
    self.systemContext = nil;

    // Due to a race condition internally with EAStream, we cannot immediately attempt to restart the proxy, as we will randomly crash.
    // Apple Bug ID #30059457
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), self.lifecycleQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) { return; }

        [strongSelf.delegate managerDidDisconnect];

        if (shouldRestart) {
            [strongSelf sdl_transitionToState:SDLLifecycleStateStarted];
        } else {
            // End the background task because a session will not be established
            [self.backgroundTaskManager endBackgroundTask];
        }
    });
}

- (void)didEnterStateConnected {
    // Ignore the connection while we are reconnecting. The proxy needs to be disposed and restarted in order to ensure correct state. https://github.com/smartdevicelink/sdl_ios/issues/1172
    if ([self.lifecycleState isEqualToString:SDLLifecycleStateReconnecting]) { return; }

    // If we have security managers, add them to the proxy
    NSString *appId = self.configuration.lifecycleConfig.fullAppId ? self.configuration.lifecycleConfig.fullAppId : self.configuration.lifecycleConfig.appId;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (self.configuration.streamingMediaConfig.securityManagers != nil) {
        SDLLogD(@"Adding security managers from streamingMedia configuration");
        [self.proxy addSecurityManagers:self.configuration.streamingMediaConfig.securityManagers forAppId:appId];
    }
#pragma clang diagnostic pop
    if (self.configuration.encryptionConfig.securityManagers != nil) {
        SDLLogD(@"Adding security managers from encryption configuration");
        [self.proxy addSecurityManagers:self.configuration.encryptionConfig.securityManagers forAppId:appId];
    }

    // If the negotiated protocol version is greater than the minimum allowable version, we need to end service and disconnect
    if ([self.configuration.lifecycleConfig.minimumProtocolVersion isGreaterThanVersion:[SDLGlobals sharedGlobals].protocolVersion]) {
        SDLLogW(@"Disconnecting from head unit, protocol version %@ is less than configured minimum version %@", [SDLGlobals sharedGlobals].protocolVersion.stringVersion, self.configuration.lifecycleConfig.minimumProtocolVersion.stringVersion);
        [self.proxy.protocol endServiceWithType:SDLServiceTypeRPC];
        [self sdl_transitionToState:SDLLifecycleStateStopped];
        return;
    }

    // Build a register app interface request with the configuration data
    SDLRegisterAppInterface *regRequest = [[SDLRegisterAppInterface alloc] initWithLifecycleConfiguration:self.configuration.lifecycleConfig];

    // Send the request and depending on the response, post the notification
    __weak typeof(self) weakSelf = self;
    [self sendConnectionManagerRequest:regRequest
      withResponseHandler:^(__kindof SDLRPCRequest *_Nullable request, __kindof SDLRPCResponse *_Nullable response, NSError *_Nullable error) {
        // If the success BOOL is NO or we received an error at this point, we failed. Call the ready handler and transition to the DISCONNECTED state.
        if (error != nil || ![response.success boolValue]) {
            SDLLogE(@"Failed to register the app. Error: %@, Response: %@", error, response);
            if (weakSelf.readyHandler) {
                weakSelf.readyHandler(NO, error);
            }

            if (weakSelf.lifecycleState != SDLLifecycleStateReconnecting) {
                [weakSelf sdl_transitionToState:SDLLifecycleStateStopped];
            }

            return;
        }

        weakSelf.registerResponse = (SDLRegisterAppInterfaceResponse *)response;
        [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithSDLMsgVersion:weakSelf.registerResponse.sdlMsgVersion];
        [weakSelf sdl_transitionToState:SDLLifecycleStateRegistered];
    }];
}

- (void)didEnterStateRegistered {
    // If the negotiated RPC version is greater than the minimum allowable version, we need to unregister and disconnect
    if ([self.configuration.lifecycleConfig.minimumRPCVersion isGreaterThanVersion:[SDLGlobals sharedGlobals].rpcVersion]) {
        SDLLogW(@"Disconnecting from head unit, RPC version %@ is less than configured minimum version %@", [SDLGlobals sharedGlobals].rpcVersion.stringVersion, self.configuration.lifecycleConfig.minimumRPCVersion.stringVersion);
        [self sdl_transitionToState:SDLLifecycleStateUnregistering];
        return;
    }

    NSArray<SDLLanguage> *supportedLanguages = self.configuration.lifecycleConfig.languagesSupported;
    SDLLanguage desiredLanguage = self.configuration.lifecycleConfig.language;
    SDLLanguage actualLanguage = self.registerResponse.language;
    BOOL delegateCanUpdateLifecycle = [self.delegate respondsToSelector:@selector(managerShouldUpdateLifecycleToLanguage:)];
    
    // language mismatch? but actual language is a supported language? and delegate has implemented method?
    if (![actualLanguage isEqualToEnum:desiredLanguage] && [supportedLanguages containsObject:actualLanguage] && delegateCanUpdateLifecycle) {
        [self sdl_transitionToState:SDLLifecycleStateUpdatingConfiguration];
    } else {
        [self sdl_transitionToState:SDLLifecycleStateSettingUpManagers];
    }
}

- (void)didEnterStateUpdatingConfiguration {
    // We can expect that the delegate has implemented the update method and the actual language is a supported language
    SDLLanguage actualLanguage = self.registerResponse.language;
    SDLLogD(@"Updating configuration due to language mismatch. New langugage: %@", actualLanguage);

    SDLLifecycleConfigurationUpdate *configUpdate = [self.delegate managerShouldUpdateLifecycleToLanguage:actualLanguage];

    if (configUpdate) {
        self.configuration.lifecycleConfig.language = actualLanguage;
        if (configUpdate.appName) {
            self.configuration.lifecycleConfig.appName = configUpdate.appName;
        }
        if (configUpdate.shortAppName) {
            self.configuration.lifecycleConfig.shortAppName = configUpdate.shortAppName;
        }
        if (configUpdate.ttsName) {
            self.configuration.lifecycleConfig.ttsName = configUpdate.ttsName;
        }
        if (configUpdate.voiceRecognitionCommandNames) {
            self.configuration.lifecycleConfig.voiceRecognitionCommandNames = configUpdate.voiceRecognitionCommandNames;
        }

        SDLChangeRegistration *changeRegistration = [[SDLChangeRegistration alloc] initWithLanguage:actualLanguage hmiDisplayLanguage:actualLanguage];
        changeRegistration.appName = configUpdate.appName;
        changeRegistration.ngnMediaScreenAppName = configUpdate.shortAppName;
        changeRegistration.ttsName = configUpdate.ttsName;
        changeRegistration.vrSynonyms = configUpdate.voiceRecognitionCommandNames;

        [self sendConnectionManagerRequest:changeRegistration withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (error != nil) {
                SDLLogW(@"Failed to update language with change registration. Request: %@, Response: %@, error: %@", request, response, error);
                return;
            }

            SDLLogD(@"Successfully updated language with change registration. Request sent: %@", request);
        }];
    }
    
    [self sdl_transitionToState:SDLLifecycleStateSettingUpManagers];
}

- (void)didEnterStateSettingUpManagers {
    dispatch_group_t managerGroup = dispatch_group_create();

    // Make sure there's at least one group_enter until we have synchronously run through all the startup calls
    dispatch_group_enter(managerGroup);
    SDLLogD(@"Setting up assistant managers");
    [self.lockScreenManager start];
    [self.systemCapabilityManager start];

    dispatch_group_enter(managerGroup);
    [self.fileManager startWithCompletionHandler:^(BOOL success, NSError *_Nullable error) {
        if (!success) {
            SDLLogW(@"File manager was unable to start; error: %@", error);
        }

        dispatch_group_leave(managerGroup);
    }];

    dispatch_group_enter(managerGroup);
    [self.permissionManager startWithCompletionHandler:^(BOOL success, NSError *_Nullable error) {
        if (!success) {
            SDLLogW(@"Permission manager was unable to start; error: %@", error);
        }

        dispatch_group_leave(managerGroup);
    }];
    
    if (self.encryptionLifecycleManager != nil) {
        [self.encryptionLifecycleManager startWithProtocol:self.proxy.protocol];
    }
    
    // Starts the streaming media manager if only using the primary transport (i.e. secondary transports has been disabled in the lifecyle configuration). If using a secondary transport, setup is handled by the stream manager.
    if (self.secondaryTransportManager == nil && self.streamManager != nil) {
        [self.streamManager startSecondaryTransportWithProtocol:self.proxy.protocol];
    }

    dispatch_group_enter(managerGroup);
    [self.screenManager startWithCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            SDLLogW(@"Screen Manager was unable to start; error: %@", error);
        }

        dispatch_group_leave(managerGroup);
    }];

    // We're done synchronously calling all startup methods, so we can now wait.
    dispatch_group_leave(managerGroup);

    // When done, we want to transition, even if there were errors. They may be expected, e.g. on head units that do not support files.
    dispatch_group_notify(managerGroup, self.lifecycleQueue, ^{
        // We could have been shut down while waiting for the completion of starting file manager and permission manager.
        if (self.lifecycleState == SDLLifecycleStateSettingUpManagers) {
            [self sdl_transitionToState:SDLLifecycleStateSettingUpAppIcon];
        }
    });
}

- (void)didEnterStateSettingUpAppIcon {
    if (self.registerResponse.iconResumed.boolValue) {
        [self sdl_transitionToState:SDLLifecycleStateSettingUpHMI];
        return;
    }

    // We only want to send the app icon when the file manager is complete, and when that's done, wait for hmi status to be ready
    __weak typeof(self) weakself = self;
    [self sdl_sendAppIcon:self.configuration.lifecycleConfig.appIcon withCompletion:^() {
        dispatch_async(weakself.lifecycleQueue, ^{
            // We could have been shut down while setting up the app icon, make sure we still want to continue or we could crash
            if (weakself.lifecycleState == SDLLifecycleStateSettingUpAppIcon) {
                [weakself sdl_transitionToState:SDLLifecycleStateSettingUpHMI];
            }
        });
    }];
}

- (void)didEnterStateSettingUpHMI {
    // We want to make sure we've gotten a SDLOnHMIStatus notification
    if (self.hmiLevel == nil) {
        // If nil, return and wait until we get a notification
        return;
    }

    // We are sure to have a HMIStatus, set state to ready
    [self sdl_transitionToState:SDLLifecycleStateReady];
}

- (void)didEnterStateReady {
    SDLResult registerResult = self.registerResponse.resultCode;
    NSString *registerInfo = self.registerResponse.info;
    NSError *startError = nil;

    // If the resultCode isn't success, we got a warning. Errors were handled in `didEnterStateConnected`.
    if (![registerResult isEqualToEnum:SDLResultSuccess]) {
        startError = [NSError sdl_lifecycle_startedWithWarning:registerResult info:registerInfo];
    }

    // If we got to this point, we succeeded, send the error if there was a warning.
    self.readyHandler(YES, startError);

    [self.notificationDispatcher postNotificationName:SDLDidBecomeReady infoObject:nil];

    // Send the hmi level going from NONE to whatever we're at now (could still be NONE)
    [self.delegate hmiLevel:SDLHMILevelNone didChangeToLevel:self.hmiLevel];

    // Send the audio streaming state going from NOT_AUDIBLE to whatever we're at now (could still be NOT_AUDIBLE)
    if ([self.delegate respondsToSelector:@selector(audioStreamingState:didChangeToState:)]) {
        [self.delegate audioStreamingState:SDLAudioStreamingStateNotAudible didChangeToState:self.audioStreamingState];
    }

    if ([self.delegate respondsToSelector:@selector(videoStreamingState:didChangetoState:)]) {
        [self.delegate videoStreamingState:SDLVideoStreamingStateNotStreamable didChangetoState:self.videoStreamingState];
    }

    // Stop the background task now that setup has completed
    [self.backgroundTaskManager endBackgroundTask];
}

- (void)didEnterStateUnregistering {
    SDLUnregisterAppInterface *unregisterRequest = [[SDLUnregisterAppInterface alloc] init];

    __weak typeof(self) weakSelf = self;
    [self sdl_sendRequest:unregisterRequest
      withResponseHandler:^(__kindof SDLRPCRequest *_Nullable request, __kindof SDLRPCResponse *_Nullable response, NSError *_Nullable error) {
        if (error != nil || ![response.success boolValue]) {
            SDLLogE(@"SDL Error unregistering, we are going to hard disconnect: %@, response: %@", error, response);
        }

        [weakSelf sdl_transitionToState:SDLLifecycleStateStopped];
    }];
}


#pragma mark Post Manager Setup Processing

- (void)sdl_sendAppIcon:(nullable SDLFile *)appIcon withCompletion:(void (^)(void))completion {
    // If no app icon was set, just move on to ready
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    if (appIcon == nil || ![self.systemCapabilityManager.defaultMainWindowCapability.imageTypeSupported containsObject:SDLImageTypeDynamic]) {
        completion();
        return;
    }
#pragma clang diagnostic pop

    [self.fileManager uploadFile:appIcon completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError *_Nullable error) {
        // These errors could be recoverable (particularly "cannot overwrite"), so we'll still attempt to set the app icon
        if (error != nil) {
            if (error.code == SDLFileManagerErrorCannotOverwrite) {
                SDLLogW(@"Failed to upload app icon: A file with this name already exists on the system");
            } else {
                SDLLogW(@"Unexpected error uploading app icon: %@", error);
                completion();
                return;
            }
        }

        // Once we've tried to put the file on the remote system, try to set the app icon
        SDLSetAppIcon *setAppIcon = [[SDLSetAppIcon alloc] init];
        setAppIcon.syncFileName = appIcon.name;

        [self sendConnectionManagerRequest:setAppIcon
          withResponseHandler:^(__kindof SDLRPCRequest *_Nullable request, __kindof SDLRPCResponse *_Nullable response, NSError *_Nullable error) {
            if (error != nil) {
                SDLLogW(@"Error setting up app icon: %@", error);
            }

            // We've succeeded or failed
            completion();
        }];
    }];
}


#pragma mark Sending Requests

- (void)sendRPC:(__kindof SDLRPCMessage *)rpc {
    if ([rpc isKindOfClass:SDLRPCRequest.class]) {
        SDLRPCRequest *requestRPC = (SDLRPCRequest *)rpc;
        [self sendRequest:requestRPC withResponseHandler:nil];
    } else if ([rpc isKindOfClass:SDLRPCResponse.class] || [rpc isKindOfClass:SDLRPCNotification.class]) {
        [self sdl_sendRPC:rpc];
    } else {
        NSAssert(false, @"The request should be of type `Request`, `Response` or `Notification");
    }
}

- (void)sdl_sendRPC:(__kindof SDLRPCMessage *)rpc {
    SDLAsynchronousRPCOperation *op = [[SDLAsynchronousRPCOperation alloc] initWithConnectionManager:self rpc:rpc];
    [self.rpcOperationQueue addOperation:op];
}

- (void)sendRequest:(SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    SDLAsynchronousRPCRequestOperation *op = [[SDLAsynchronousRPCRequestOperation alloc] initWithConnectionManager:self request:request responseHandler:handler];
    [self.rpcOperationQueue addOperation:op];
}

- (void)sendRequests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleAsyncRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler {
    if (requests.count == 0) {
        completionHandler(YES);
        return;
    }

    SDLAsynchronousRPCRequestOperation *op = [[SDLAsynchronousRPCRequestOperation alloc] initWithConnectionManager:self requests:requests progressHandler:progressHandler completionHandler:completionHandler];
    [self.rpcOperationQueue addOperation:op];
}

- (void)sendSequentialRequests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleSequentialRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler {
    if (requests.count == 0) {
        completionHandler(YES);
        return;
    }

    SDLSequentialRPCRequestOperation *op = [[SDLSequentialRPCRequestOperation alloc] initWithConnectionManager:self requests:requests progressHandler:progressHandler completionHandler:completionHandler];
    [self.rpcOperationQueue addOperation:op];
}

- (void)sendConnectionRPC:(__kindof SDLRPCMessage *)rpc {
    NSAssert(([rpc isKindOfClass:SDLRPCResponse.class] || [rpc isKindOfClass:SDLRPCNotification.class]), @"Only RPCs of type `Response` or `Notfication` can be sent using this method. To send RPCs of type `Request` use sendConnectionRequest:withResponseHandler:.");

    if (![self.lifecycleStateMachine isCurrentState:SDLLifecycleStateReady]) {
        SDLLogW(@"Manager not ready, message not sent (%@)", rpc);
        return;
    }

    [self sdl_runOnProcessingQueue:^{
        [self sdl_sendRequest:rpc withResponseHandler:nil];
    }];
}

- (void)sendConnectionRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    if (![self.lifecycleStateMachine isCurrentState:SDLLifecycleStateReady]) {
        SDLLogW(@"Manager not ready, request not sent (%@)", request);
        if (handler) {
            handler(request, nil, [NSError sdl_lifecycle_notReadyError]);
        }
        
        return;
    }
    
    if (!request.isPayloadProtected && [self.encryptionLifecycleManager rpcRequiresEncryption:request]) {
        request.payloadProtected = YES;
    }
    
    if (request.isPayloadProtected && !self.encryptionLifecycleManager.isEncryptionReady) {
        SDLLogW(@"Encryption Manager not ready, request not sent (%@)", request);
        if (handler) {
            handler(request, nil, [NSError sdl_encryption_lifecycle_notReadyError]);
        }
        
        return;
    }

    [self sdl_runOnProcessingQueue:^{
        [self sdl_sendRequest:request withResponseHandler:handler];
    }];
}

// Managers need to avoid state checking. Part of <SDLConnectionManagerType>.
- (void)sendConnectionManagerRequest:(__kindof SDLRPCMessage *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    [self sdl_runOnProcessingQueue:^{
        [self sdl_sendRequest:request withResponseHandler:handler];
    }];
}

- (void)sdl_sendRequest:(__kindof SDLRPCMessage *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    // We will allow things to be sent in a "SDLLifecycleStateConnected" state in the private method, but block it in the public method sendRequest:withCompletionHandler: so that the lifecycle manager can complete its setup without being bothered by developer error
    NSParameterAssert(request != nil);

    // If, for some reason, the request is nil we should error out.
    if (!request) {
        NSError *error = [NSError sdl_lifecycle_rpcErrorWithDescription:@"Nil Request Sent" andReason:@"A nil RPC request was passed and cannot be sent."];
        SDLLogW(@"%@", error);
        if (handler) {
            handler(nil, nil, error);
        }
        return;
    }

    if ([request isKindOfClass:SDLRPCRequest.class]) {
        // Generate and add a correlation ID to the request. When a response for the request is returned from Core, it will have the same correlation ID
        SDLRPCRequest *requestRPC = (SDLRPCRequest *)request;
        NSNumber *corrID = [self sdl_getNextCorrelationId];
        requestRPC.correlationID = corrID;
        [self.responseDispatcher storeRequest:requestRPC handler:handler];
        [self.proxy sendRPC:requestRPC];
    } else if ([request isKindOfClass:SDLRPCResponse.class] || [request isKindOfClass:SDLRPCNotification.class]) {
        [self.proxy sendRPC:request];
    } else {
        SDLLogE(@"Attempting to send an RPC with unknown type, %@. The request should be of type request, response or notification. Returning...", request.class);
    }
}

#pragma mark Helper Methods

/// Returns true if the app type set in the configuration is `NAVIGATION` or `PROJECTION`; false for any other app type.
/// @param configuration This session's configuration
+ (BOOL)sdl_isStreamingConfiguration:(SDLConfiguration *)configuration {
    if ([configuration.lifecycleConfig.appType isEqualToEnum:SDLAppHMITypeNavigation] ||
    [configuration.lifecycleConfig.appType isEqualToEnum:SDLAppHMITypeProjection] ||
    [configuration.lifecycleConfig.additionalAppTypes containsObject:SDLAppHMITypeNavigation] ||
    [configuration.lifecycleConfig.additionalAppTypes containsObject:SDLAppHMITypeProjection]) {
        return YES;
    }

    return NO;
}

- (NSNumber<SDLInt> *)sdl_getNextCorrelationId {
    if (self.lastCorrelationId == INT32_MAX) {
        self.lastCorrelationId = 0;
    }

    return @(++self.lastCorrelationId);
}

+ (BOOL)sdl_checkNotification:(NSNotification *)notification containsKindOfClass:(Class) class {
    NSAssert([notification.userInfo[SDLNotificationUserInfoObject] isKindOfClass:class], @"A notification was sent with an unanticipated object");
    if (![notification.userInfo[SDLNotificationUserInfoObject] isKindOfClass:class]) {
        return NO;
    }

    return YES;
}

// this is to make sure that the transition happens on the dedicated queue
- (void)sdl_runOnProcessingQueue:(void (^)(void))block {
    if (dispatch_get_specific(SDLProcessingQueueName) != nil) {
        block();
    } else {
        dispatch_sync(self.lifecycleQueue, block);
    }
}

- (void)sdl_transitionToState:(SDLState *)state {
    [self sdl_runOnProcessingQueue:^{
        [self.lifecycleStateMachine transitionToState:state];
    }];
}

/**
 *  Gets the authentication token returned by the `StartServiceACK` header
 *
 *  @return An authentication token
 */
- (nullable NSString *)authToken {
    return self.proxy.protocol.authToken;
}

#pragma mark SDL notification observers

- (void)transportDidConnect {
    if (![self.lifecycleStateMachine isCurrentState:SDLLifecycleStateReady]) {
        SDLLogD(@"Transport connected");

        dispatch_async(self.lifecycleQueue, ^{
            [self sdl_transitionToState:SDLLifecycleStateConnected];
        });
    }
}

- (void)transportDidDisconnect {
    SDLLogD(@"Transport Disconnected");

    dispatch_async(self.lifecycleQueue, ^{
        if (self.lifecycleState == SDLLifecycleStateUnregistering || self.lifecycleState == SDLLifecycleStateStopped) {
            [self sdl_transitionToState:SDLLifecycleStateStopped];
        } else {
            [self sdl_transitionToState:SDLLifecycleStateReconnecting];
        }
    });
}

- (void)hmiStatusDidChange:(SDLRPCNotificationNotification *)notification {
    dispatch_async(self.lifecycleQueue, ^{
        [self sdl_hmiStatusDidChange:notification];
    });
}

- (void)sdl_hmiStatusDidChange:(SDLRPCNotificationNotification *)notification {
    if (![notification isNotificationMemberOfClass:[SDLOnHMIStatus class]]) {
        return;
    }

    SDLOnHMIStatus *hmiStatusNotification = notification.notification;
    
    if (hmiStatusNotification.windowID != nil && hmiStatusNotification.windowID.integerValue != SDLPredefinedWindowsDefaultWindow) {
        return;
    }
    
    SDLHMILevel oldHMILevel = self.hmiLevel;
    self.hmiLevel = hmiStatusNotification.hmiLevel;

    SDLAudioStreamingState oldAudioStreamingState = self.audioStreamingState;
    self.audioStreamingState = hmiStatusNotification.audioStreamingState;

    SDLVideoStreamingState oldVideoStreamingState = self.videoStreamingState;
    self.videoStreamingState = hmiStatusNotification.videoStreamingState;

    SDLSystemContext oldSystemContext = self.systemContext;
    self.systemContext = hmiStatusNotification.systemContext;

    if (![oldHMILevel isEqualToEnum:self.hmiLevel]) {
        SDLLogD(@"HMI level changed from %@ to %@", oldHMILevel, self.hmiLevel);
    }

    if (![oldAudioStreamingState isEqualToEnum:self.audioStreamingState]) {
        SDLLogD(@"Audio streaming state changed from %@ to %@", oldAudioStreamingState, self.audioStreamingState);
    }

    if (![oldVideoStreamingState isEqualToEnum:self.videoStreamingState]) {
        SDLLogD(@"Video streaming state changed from %@ to %@", oldVideoStreamingState, self.videoStreamingState);
    }

    if (![oldSystemContext isEqualToEnum:self.systemContext]) {
        SDLLogD(@"System context changed from %@ to %@", oldSystemContext, self.systemContext);
    }

    if ([self.lifecycleStateMachine isCurrentState:SDLLifecycleStateSettingUpHMI]) {
        [self sdl_transitionToState:SDLLifecycleStateReady];
    }

    if (![self.lifecycleStateMachine isCurrentState:SDLLifecycleStateReady]) {
        return;
    }

    if (![oldHMILevel isEqualToEnum:self.hmiLevel]
        && !(oldHMILevel == nil && self.hmiLevel == nil)) {
        [self.delegate hmiLevel:oldHMILevel didChangeToLevel:self.hmiLevel];
    }

    if (![oldAudioStreamingState isEqualToEnum:self.audioStreamingState]
        && !(oldAudioStreamingState == nil && self.audioStreamingState == nil)
        && [self.delegate respondsToSelector:@selector(audioStreamingState:didChangeToState:)]) {
        [self.delegate audioStreamingState:oldAudioStreamingState didChangeToState:self.audioStreamingState];
    }

    if (![oldVideoStreamingState isEqualToEnum:self.videoStreamingState]
        && !(oldVideoStreamingState == nil && self.videoStreamingState == nil)
        && [self.delegate respondsToSelector:@selector(videoStreamingState:didChangetoState:)]) {
        [self.delegate videoStreamingState:oldVideoStreamingState didChangetoState:self.videoStreamingState];
    }

    if (![oldSystemContext isEqualToEnum:self.systemContext]
        && !(oldSystemContext == nil && self.systemContext == nil)
        && [self.delegate respondsToSelector:@selector(systemContext:didChangeToContext:)]) {
        [self.delegate systemContext:oldSystemContext didChangeToContext:self.systemContext];
    }
}

- (void)remoteHardwareDidUnregister:(SDLRPCNotificationNotification *)notification {
    dispatch_async(self.lifecycleQueue, ^{
        [self sdl_remoteHardwareDidUnregister:notification];
    });
}

- (void)sdl_remoteHardwareDidUnregister:(SDLRPCNotificationNotification *)notification {
    if (![notification isNotificationMemberOfClass:[SDLOnAppInterfaceUnregistered class]]) {
        return;
    }

    SDLOnAppInterfaceUnregistered *appUnregisteredNotification = notification.notification;
    SDLLogE(@"Remote Device forced unregistration for reason: %@", appUnregisteredNotification.reason);

    if ([self.lifecycleStateMachine isCurrentState:SDLLifecycleStateUnregistering]) {
        [self sdl_transitionToState:SDLLifecycleStateStopped];
    } else if ([self.lifecycleStateMachine isCurrentState:SDLLifecycleStateStopped]) {
        return;
    } else if (appUnregisteredNotification.reason != nil && ([appUnregisteredNotification.reason isEqualToEnum:SDLAppInterfaceUnregisteredReasonAppUnauthorized] || [appUnregisteredNotification.reason isEqualToString:SDLAppInterfaceUnregisteredReasonProtocolViolation])) {
        // HAX: The string check is due to a core "feature" that could cause -1 to be sent as the enum value, which will crash here.
        [self sdl_transitionToState:SDLLifecycleStateStopped];
    } else {
        [self sdl_transitionToState:SDLLifecycleStateReconnecting];
    }
}

@end

NS_ASSUME_NONNULL_END
