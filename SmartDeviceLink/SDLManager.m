

#import <Foundation/Foundation.h>

#import "SmartDeviceLink.h"

#import "SDLManager.h"

#import "NSMapTable+Subscripting.h"
#import "SDLConfiguration.h"
#import "SDLError.h"
#import "SDLHMILevel.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLLockScreenViewController.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHashChange.h"
#import "SDLStateMachine.h"


NS_ASSUME_NONNULL_BEGIN

#pragma mark - Private Typedefs and Constants

NSString *const SDLLifecycleStateDisconnected = @"TransportDisconnected";
NSString *const SDLLifecycleStateTransportConnected = @"TransportConnected";
NSString *const SDLLifecycleStateRegistered = @"Registered";
NSString *const SDLLifecycleStateSettingUpManagers = @"SettingUpManagers";
NSString *const SDLLifecycleStateUnregistering = @"Unregistering";
NSString *const SDLLifecycleStateReady = @"Ready";

typedef NSNumber SDLRPCCorrelationId;
typedef NSNumber SDLAddCommandCommandId;
typedef NSString SDLSubscribeButtonName;
typedef NSNumber SDLSoftButtonId;


#pragma mark - SDLManager Private Interface

@interface SDLManager () <SDLProxyListener>

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
@property (strong, nonatomic, nullable) UIViewController *lockScreenViewController; // TODO: Make a LockScreenManager
@property (assign, nonatomic, getter=isLockScreenPresented) BOOL lockScreenPresented;
@property (strong, nonatomic, nullable) SDLRegisterAppInterfaceResponse *registerAppInterfaceResponse;

// Dictionaries to link handlers with requests/commands/etc
@property (strong, nonatomic) NSMapTable<SDLRPCCorrelationId *, SDLRequestCompletionHandler> *rpcResponseHandlerMap;
@property (strong, nonatomic) NSMutableDictionary<SDLRPCCorrelationId *, SDLRPCRequest *> *rpcRequestDictionary;
@property (strong, nonatomic) NSMapTable<SDLAddCommandCommandId *, SDLRPCNotificationHandler> *commandHandlerMap;
@property (strong, nonatomic) NSMapTable<SDLSubscribeButtonName *, SDLRPCNotificationHandler> *buttonHandlerMap;
@property (strong, nonatomic) NSMapTable<SDLSoftButtonId *, SDLRPCNotificationHandler> *customButtonHandlerMap;

@end


#pragma mark - SDLManager Implementation

@implementation SDLManager

#pragma mark Lifecycle

- (instancetype)init {
    return [self initWithConfiguration:[SDLConfiguration configurationWithLifecycle:[SDLLifecycleConfiguration defaultConfigurationWithAppName:@"SDL APP" appId:@"001"] lockScreen:nil]];
}

- (instancetype)initWithConfiguration:(SDLConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _lifecycleStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLLifecycleStateDisconnected states:[self.class sdl_stateTransitionDictionary]];
    _configuration = configuration;
    
    _correlationID = 1;
    _firstHMIFullOccurred = NO;
    _firstHMINotNoneOccurred = NO;
    _registerAppInterfaceResponse = nil;
    
    _lockScreenPresented = NO;
    
    _rpcResponseHandlerMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];
    _rpcRequestDictionary = [[NSMutableDictionary alloc] init];
    _commandHandlerMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];
    _buttonHandlerMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];
    _customButtonHandlerMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];
    
    return self;
}

- (void)start {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [SDLProxy enableSiphonDebug];
    
    if (self.configuration.lifecycleConfig.tcpDebugMode) {
        self.proxy = [SDLProxyFactory buildSDLProxyWithListener:self tcpIPAddress:self.configuration.lifecycleConfig.tcpDebugIPAddress tcpPort:self.configuration.lifecycleConfig.tcpDebugPort];
    } else {
        self.proxy = [SDLProxyFactory buildSDLProxyWithListener:self];
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

- (SDLFileManager *)fileManager {
    if (_fileManager == nil) {
        _fileManager = [[SDLFileManager alloc] initWithConnectionManager:self];
    }
    
    return _fileManager;
}

- (SDLPermissionManager *)permissionManager {
    if (_permissionManager == nil) {
        _permissionManager = [[SDLPermissionManager alloc] init];
    }
    
    return _permissionManager;
}

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
             SDLLifecycleStateSettingUpManagers: @[SDLLifecycleStateDisconnected, SDLLifecycleStateReady],
             SDLLifecycleStateUnregistering: @[SDLLifecycleStateDisconnected],
             SDLLifecycleStateReady: @[SDLLifecycleStateUnregistering,SDLLifecycleStateDisconnected]
             };
}

- (void)didEnterStateTransportDisconnected {
    [self.fileManager stop];
    [self.permissionManager stop];
    
    [self sdl_disposeProxy]; // call this method instead of stopProxy to avoid double-dispatching
    [self sdl_postNotification:SDLDidDisconnectNotification info:nil];
    [self sdl_startProxy];
}

- (void)didEnterStateTransportConnected {
    // Build a register app interface request with the configuration data
    SDLRegisterAppInterface *regRequest = [SDLRPCRequestFactory buildRegisterAppInterfaceWithAppName:self.configuration.lifecycleConfig.appName languageDesired:self.configuration.lifecycleConfig.language appID:self.configuration.lifecycleConfig.appId];
    regRequest.isMediaApplication = @(self.configuration.lifecycleConfig.isMedia);
    regRequest.ngnMediaScreenAppName = self.configuration.lifecycleConfig.shortAppName;
    
    // TODO: Should the hash be removed under any conditions?
    if (self.resumeHash != nil) {
        regRequest.hashID = self.resumeHash.hashID;
    }
    
    if (self.configuration.lifecycleConfig.voiceRecognitionSynonyms != nil) {
        regRequest.vrSynonyms = [NSMutableArray arrayWithArray:self.configuration.lifecycleConfig.voiceRecognitionSynonyms];
    }
    
    // Send the request and depending on the response, post the notification
    [self sdl_sendRequest:regRequest withCompletionHandler:^(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *response, NSError *error) {
        if (error) {
            [self sdl_postNotification:SDLDidFailToRegisterNotification info:error];
        } else {
            [self sdl_postNotification:SDLDidRegisterNotification info:response];
        }
    }];
    
    // Make sure to post the did connect notification to start preheating some other objects as well while we wait for the RAIR
    [self sdl_postNotification:SDLDidConnectNotification info:nil];
}

- (void)didEnterStateRegistered {
    // TODO: Anything?
    [self.lifecycleStateMachine transitionToState:SDLLifecycleStateSettingUpManagers];
}

// TODO: Tear down managers on disconnect
- (void)didEnterStateSettingUpManagers {
    dispatch_group_t managerGroup = dispatch_group_create();
    
    // Make sure there's at least one group_enter until we have synchronously run through all the startup calls
    dispatch_group_enter(managerGroup);
    
    // When done, we want to transition
    dispatch_group_notify(managerGroup, dispatch_get_main_queue(), ^{
        [self.lifecycleStateMachine transitionToState:SDLLifecycleStateReady];
    });
    
    dispatch_group_enter(managerGroup);
    [self.fileManager startManagerWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_group_leave(managerGroup);
    }];
    
    dispatch_group_enter(managerGroup);
    [self.permissionManager startWithCompletionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_group_leave(managerGroup);
    }];
    
    // We're done synchronously calling all startup methods, so we can now wait.
    dispatch_group_leave(managerGroup);
}

- (void)didEnterStateReady {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidBecomeReadyNotification object:self userInfo:nil];
    });
}

- (void)didEnterStateUnregistering {
    SDLUnregisterAppInterface *unregisterRequest = [SDLRPCRequestFactory buildUnregisterAppInterfaceWithCorrelationID:[self sdl_getNextCorrelationId]];
    
    __weak typeof(self) weakSelf = self;
    [self sendRequest:unregisterRequest withCompletionHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [weakSelf.lifecycleStateMachine transitionToState:SDLLifecycleStateDisconnected];
    }];
}


#pragma mark Event, Response, Notification Processing

- (void)sdl_postNotification:(NSString *)name info:(nullable id)info {
    NSDictionary<NSString *, id> *userInfo = nil;
    if (info != nil) {
        userInfo = @{ SDLNotificationUserInfoNotificationObject: info };
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:userInfo];
    });
}


- (void)sdl_runHandlersForResponse:(__kindof SDLRPCResponse *)response {
    NSError *error = nil;
    BOOL success = [response.success boolValue];
    if (success == NO) {
        error = [NSError sdl_lifecycle_rpcErrorWithDescription:response.resultCode.value andReason:response.info];
    }
    
    // Find the appropriate request completion handler, remove the request and response handler
    SDLRequestCompletionHandler handler = self.rpcResponseHandlerMap[response.correlationID];
    SDLRPCRequest *request = self.rpcRequestDictionary[response.correlationID];
    [self.rpcRequestDictionary removeObjectForKey:response.correlationID];
    [self.rpcResponseHandlerMap removeObjectForKey:response.correlationID];
    
    // Run the response handler
    if (handler) {
        handler(request, response, error);
    }
    
    // If it's a DeleteCommand or UnsubscribeButton, we need to remove handlers for the corresponding commands / buttons
    if ([response isKindOfClass:[SDLDeleteCommandResponse class]]) {
        SDLDeleteCommand *deleteCommandRequest = (SDLDeleteCommand *)request;
        NSNumber *deleteCommandId = deleteCommandRequest.cmdID;
        [self.commandHandlerMap removeObjectForKey:deleteCommandId];
    } else if ([response isKindOfClass:[SDLUnsubscribeButtonResponse class]]) {
        SDLUnsubscribeButton *unsubscribeButtonRequest = (SDLUnsubscribeButton *)request;
        NSString *unsubscribeButtonName = unsubscribeButtonRequest.buttonName.value;
        [self.buttonHandlerMap removeObjectForKey:unsubscribeButtonName];
    }
}

- (void)sdl_runHandlerForCommand:(SDLOnCommand *)command {
    SDLRPCNotificationHandler handler = nil;
    handler = self.commandHandlerMap[command.cmdID];
    
    if (handler) {
        handler(command);
    }
}

- (void)sdl_runHandlerForButton:(__kindof SDLRPCNotification *)notification {
    SDLRPCNotificationHandler handler = nil;
    SDLButtonName *name = nil;
    NSNumber *customID = nil;
    
    if ([notification isKindOfClass:[SDLOnButtonEvent class]]) {
        name = ((SDLOnButtonEvent *)notification).buttonName;
        customID = ((SDLOnButtonEvent *)notification).customButtonID;
    } else if ([notification isKindOfClass:[SDLOnButtonPress class]]) {
        name = ((SDLOnButtonPress *)notification).buttonName;
        customID = ((SDLOnButtonPress *)notification).customButtonID;
    }
    
    if ([name isEqual:[SDLButtonName CUSTOM_BUTTON]]) {
        handler = self.customButtonHandlerMap[customID];
    } else {
        handler = self.buttonHandlerMap[name.value];
    }
    
    if (handler) {
        handler(notification);
    }
}


#pragma mark SDLConnectionManager Protocol

- (void)sendRequest:(__kindof SDLRPCRequest *)request withCompletionHandler:(nullable SDLRequestCompletionHandler)handler {
    if ([self.lifecycleStateMachine isCurrentState:SDLLifecycleStateDisconnected]) {
        [SDLDebugTool logInfo:@"Proxy not connected! Not sending RPC."];
        if (handler) {
            handler(nil, nil, [NSError sdl_lifecycle_notConnectedError]);
        }
    } else if ([self.lifecycleStateMachine isCurrentState:SDLLifecycleStateTransportConnected]) {
        [SDLDebugTool logInfo:@"Manager not ready, will not send RPC until ready"];
        if (handler) {
            handler(nil, nil, [NSError sdl_lifecycle_notReadyError]);
        }
    } else if ([self.lifecycleStateMachine isCurrentState:SDLLifecycleStateReady]) {
        [self sdl_sendRequest:request withCompletionHandler:handler];
    }
}

- (void)sdl_sendRequest:(SDLRPCRequest *)request withCompletionHandler:(nullable SDLRequestCompletionHandler)handler {
    // We will allow things to be sent in a "SDLLifeCycleStateTransportConnected" in the private method, but block it in the public method sendRequest:withCompletionHandler: so that the lifecycle manager can complete its setup without being bothered by developer error
    
    // Add a correlation ID
    NSNumber *corrID = [self sdl_getNextCorrelationId];
    request.correlationID = corrID;
    
    // Check for RPCs that require an extra handler
    if ([request isKindOfClass:[SDLShow class]]) {
        // TODO: Can we create soft button ids ourselves?
        SDLShow *show = (SDLShow *)request;
        [self sdl_addToHandlerMapWithSoftButtons:show.softButtons];
    } else if ([request isKindOfClass:[SDLAddCommand class]]) {
        // TODO: Can we create CmdIDs ourselves?
        SDLAddCommand *addCommand = (SDLAddCommand *)request;
        if (!addCommand.cmdID) {
            @throw [SDLManager sdl_missingIDException];
        }
        if (addCommand.handler) {
            self.commandHandlerMap[addCommand.cmdID] = addCommand.handler;
        }
    } else if ([request isKindOfClass:[SDLSubscribeButton class]]) {
        // Convert SDLButtonName to NSString, since it doesn't conform to <NSCopying>
        SDLSubscribeButton *subscribeButton = (SDLSubscribeButton *)request;
        NSString *buttonName = subscribeButton.buttonName.value;
        if (!buttonName) {
            @throw [SDLManager sdl_missingIDException];
        }
        if (subscribeButton.handler) {
            self.buttonHandlerMap[buttonName] = subscribeButton.handler;
        }
    } else if ([request isKindOfClass:[SDLAlert class]]) {
        SDLAlert *alert = (SDLAlert *)request;
        [self sdl_addToHandlerMapWithSoftButtons:alert.softButtons];
    } else if ([request isKindOfClass:[SDLScrollableMessage class]]) {
        SDLScrollableMessage *scrollableMessage = (SDLScrollableMessage *)request;
        [self sdl_addToHandlerMapWithSoftButtons:scrollableMessage.softButtons];
    }
    
    if (handler) {
        self.rpcRequestDictionary[corrID] = request;
        self.rpcResponseHandlerMap[corrID] = handler;
    }
    
    [self.proxy sendRPC:request];
}

- (void)sdl_addToHandlerMapWithSoftButtons:(NSMutableArray<SDLSoftButton *> *)softButtons {
    if (softButtons.count > 0) {
        for (SDLSoftButton *sb in softButtons) {
            if (!sb.softButtonID) {
                @throw [SDLManager sdl_missingIDException];
            }
            if (sb.handler) {
                self.customButtonHandlerMap[sb.softButtonID] = sb.handler;
            }
        }
    }
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


#pragma mark Lock Screen

- (void)sdl_initializeLockScreenController {
    // Create and initialize the lock screen controller depending on the configuration
    if (!self.configuration.lockScreenConfig.enableAutomaticLockScreen) {
        self.lockScreenViewController = nil;
    } else if (self.configuration.lockScreenConfig.customViewController != nil) {
        self.lockScreenViewController = self.configuration.lockScreenConfig.customViewController;
    } else {
        NSBundle *sdlBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SmartDeviceLink" ofType:@"bundle"]];
        SDLLockScreenViewController *lockScreenVC = [[UIStoryboard storyboardWithName:@"SDLLockScreen" bundle:sdlBundle] instantiateInitialViewController];
        lockScreenVC.appIcon = self.configuration.lockScreenConfig.appIcon;
        lockScreenVC.backgroundColor = self.configuration.lockScreenConfig.backgroundColor;
        self.lockScreenViewController = lockScreenVC;
    }
}

- (UIViewController *)sdl_getCurrentViewController {
    // http://stackoverflow.com/questions/6131205/iphone-how-to-find-topmost-view-controller
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController != nil) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}


#pragma mark SDLProxyListener Methods

- (void)onProxyOpened {
    [SDLDebugTool logInfo:@"onProxyOpened"];
    [self.lifecycleStateMachine transitionToState:SDLLifecycleStateTransportConnected];
}

- (void)onProxyClosed {
    [SDLDebugTool logInfo:@"onProxyClosed"];
    [self.lifecycleStateMachine transitionToState:SDLLifecycleStateDisconnected];
}

- (void)onError:(NSException *)e {
    NSError *error = [NSError sdl_lifecycle_unknownRemoteErrorWithDescription:e.name andReason:e.reason];
    [self sdl_postNotification:SDLDidReceiveErrorNotification info:error];
}

- (void)onAddCommandResponse:(SDLAddCommandResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onAddSubMenuResponse:(SDLAddSubMenuResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onAlertResponse:(SDLAlertResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onChangeRegistrationResponse:(SDLChangeRegistrationResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onCreateInteractionChoiceSetResponse:(SDLCreateInteractionChoiceSetResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onDeleteCommandResponse:(SDLDeleteCommandResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onDeleteFileResponse:(SDLDeleteFileResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onDeleteInteractionChoiceSetResponse:(SDLDeleteInteractionChoiceSetResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onDeleteSubMenuResponse:(SDLDeleteSubMenuResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onDiagnosticMessageResponse:(SDLDiagnosticMessageResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onEncodedSyncPDataResponse:(SDLEncodedSyncPDataResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onEndAudioPassThruResponse:(SDLEndAudioPassThruResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onGenericResponse:(SDLGenericResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onGetDTCsResponse:(SDLGetDTCsResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onGetVehicleDataResponse:(SDLGetVehicleDataResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onListFilesResponse:(SDLListFilesResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onReceivedLockScreenIcon:(UIImage *)icon {
    // TODO: Notification? I'd guess not.
    if ([self.lockScreenViewController isKindOfClass:[SDLLockScreenViewController class]]) {
        ((SDLLockScreenViewController *)self.lockScreenViewController).vehicleIcon = icon;
    } else {
        [self sdl_postNotification:SDLDidReceiveVehicleIconNotification info:icon];
    }
}

- (void)onPerformAudioPassThruResponse:(SDLPerformAudioPassThruResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onPerformInteractionResponse:(SDLPerformInteractionResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onPutFileResponse:(SDLPutFileResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onReadDIDResponse:(SDLReadDIDResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onRegisterAppInterfaceResponse:(SDLRegisterAppInterfaceResponse *)response {
    self.registerAppInterfaceResponse = response;
    
    [self.lifecycleStateMachine transitionToState:SDLLifecycleStateRegistered];
    
    [self sdl_runHandlersForResponse:response];
}

- (void)onResetGlobalPropertiesResponse:(SDLResetGlobalPropertiesResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onScrollableMessageResponse:(SDLScrollableMessageResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onSetAppIconResponse:(SDLSetAppIconResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onSetDisplayLayoutResponse:(SDLSetDisplayLayoutResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onSetGlobalPropertiesResponse:(SDLSetGlobalPropertiesResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onSetMediaClockTimerResponse:(SDLSetMediaClockTimerResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onShowConstantTBTResponse:(SDLShowConstantTBTResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onShowResponse:(SDLShowResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onSliderResponse:(SDLSliderResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onSpeakResponse:(SDLSpeakResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onSubscribeButtonResponse:(SDLSubscribeButtonResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onSubscribeVehicleDataResponse:(SDLSubscribeVehicleDataResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

// TODO: Not actually a notification
- (void)onSyncPDataResponse:(SDLSyncPDataResponse *)response {
    [self sdl_postNotification:SDLDidReceiveDataNotification info:response];
}

- (void)onUpdateTurnListResponse:(SDLUpdateTurnListResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onUnregisterAppInterfaceResponse:(SDLUnregisterAppInterfaceResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onUnsubscribeButtonResponse:(SDLUnsubscribeButtonResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onUnsubscribeVehicleDataResponse:(SDLUnsubscribeVehicleDataResponse *)response {
    [self sdl_runHandlersForResponse:response];
}

- (void)onOnLockScreenNotification:(SDLOnLockScreenStatus *)notification {
    // TODO: This logic should be moved into the lock screen manager class when SDLProxy doesn't handle this stuff
    if (self.lockScreenViewController == nil) {
        return;
    }
    
    if ([notification.lockScreenStatus isEqualToEnum:[SDLLockScreenStatus REQUIRED]]) {
        if (!self.lockScreenPresented) {
            [[self sdl_getCurrentViewController] presentViewController:self.lockScreenViewController animated:YES completion:nil];
            self.lockScreenPresented = YES;
        }
    } else if ([notification.lockScreenStatus isEqualToEnum:[SDLLockScreenStatus OPTIONAL]]) {
        if (self.configuration.lockScreenConfig.showInOptional && !self.lockScreenPresented) {
            [[self sdl_getCurrentViewController] presentViewController:self.lockScreenViewController animated:YES completion:nil];
            self.lockScreenPresented = YES;
        } else if (self.lockScreenPresented) {
            [[self sdl_getCurrentViewController] dismissViewControllerAnimated:YES completion:nil];
            self.lockScreenPresented = NO;
        }
    } else if ([notification.lockScreenStatus isEqualToEnum:[SDLLockScreenStatus OFF]]) {
        if (self.lockScreenPresented) {
            [[self sdl_getCurrentViewController] dismissViewControllerAnimated:YES completion:nil];
            self.lockScreenPresented = NO;
        }
    }
    
    [self sdl_postNotification:SDLDidChangeLockScreenStatusNotification info:notification];
}

- (void)onOnHMIStatus:(SDLOnHMIStatus *)notification {
    [SDLDebugTool logInfo:@"onOnHMIStatus"];
    if (notification.hmiLevel == [SDLHMILevel FULL]) {
        BOOL occurred = NO;
        occurred = self.firstHMINotNoneOccurred;
        if (!occurred) {
            [self sdl_postNotification:SDLDidReceiveFirstNonNoneHMIStatusNotification info:notification];
        }
        self.firstHMINotNoneOccurred = YES;
        
        occurred = self.firstHMIFullOccurred;
        if (!occurred) {
            [self sdl_postNotification:SDLDidReceiveFirstFullHMIStatusNotification info:notification];
        }
        self.firstHMIFullOccurred = YES;
    } else if (notification.hmiLevel == [SDLHMILevel BACKGROUND] || notification.hmiLevel == [SDLHMILevel LIMITED]) {
        BOOL occurred = NO;
        occurred = self.firstHMINotNoneOccurred;
        if (!occurred) {
            [self sdl_postNotification:SDLDidReceiveFirstNonNoneHMIStatusNotification info:notification];
        }
        self.firstHMINotNoneOccurred = YES;
    }
    
    self.currentHMILevel = notification.hmiLevel;
    [self sdl_postNotification:SDLDidChangeHMIStatusNotification info:notification];
}

- (void)onOnDriverDistraction:(SDLOnDriverDistraction *)notification {
    [self sdl_postNotification:SDLDidChangeDriverDistractionStateNotification info:notification];
}

- (void)onOnAppInterfaceUnregistered:(SDLOnAppInterfaceUnregistered *)notification {
    [self sdl_postNotification:SDLDidUnregisterNotification info:notification];
}

- (void)onOnAudioPassThru:(SDLOnAudioPassThru *)notification {
    [self sdl_postNotification:SDLDidReceiveAudioPassThruNotification info:notification];
}

- (void)onOnButtonEvent:(SDLOnButtonEvent *)notification {
    [self sdl_postNotification:SDLDidReceiveButtonEventNotification info:notification];
}

- (void)onOnButtonPress:(SDLOnButtonPress *)notification {
    [self sdl_postNotification:SDLDidReceiveButtonPressNotification info:notification];
    
    [self sdl_runHandlerForButton:notification];
}

- (void)onOnCommand:(SDLOnCommand *)notification {
    [self sdl_postNotification:SDLDidReceiveCommandNotification info:notification];
    [self sdl_runHandlerForCommand:((SDLOnCommand *)notification)];
}

- (void)onOnEncodedSyncPData:(SDLOnEncodedSyncPData *)notification {
    [self sdl_postNotification:SDLDidReceiveEncodedDataNotification info:notification];
}

- (void)onOnHashChange:(SDLOnHashChange *)notification {
    self.resumeHash = notification;
    
    [self sdl_postNotification:SDLDidReceiveNewHashNotification info:notification];
}

- (void)onOnLanguageChange:(SDLOnLanguageChange *)notification {
    [self sdl_postNotification:SDLDidChangeLanguageNotification info:notification];
}

- (void)onOnPermissionsChange:(SDLOnPermissionsChange *)notification {
    [self sdl_postNotification:SDLDidChangePermissionsNotification info:notification];
}

- (void)onOnSyncPData:(SDLOnSyncPData *)notification {
    [self sdl_postNotification:SDLDidReceiveSystemRequestNotification info:notification];
}

- (void)onOnSystemRequest:(SDLOnSystemRequest *)notification {
    [self sdl_postNotification:SDLDidReceiveSystemRequestNotification info:notification];
}

- (void)onOnTBTClientState:(SDLOnTBTClientState *)notification {
    [self sdl_postNotification:SDLDidChangeTurnByTurnStateNotification info:notification];
}

- (void)onOnTouchEvent:(SDLOnTouchEvent *)notification {
    [self sdl_postNotification:SDLDidReceiveTouchEventNotification info:notification];
}

- (void)onOnVehicleData:(SDLOnVehicleData *)notification {
    [self sdl_postNotification:SDLDidReceiveVehicleDataNotification info:notification];
}


#pragma mark Exceptions

+ (NSException *)sdl_missingHandlerException {
    return [NSException
            exceptionWithName:@"MissingHandlerException"
            reason:@"This request requires a handler to be specified using the <RPC>WithHandler class"
            userInfo:nil];
}

+ (NSException *)sdl_missingIDException {
    return [NSException
            exceptionWithName:@"MissingIDException"
            reason:@"This request requires an ID (command, softbutton, etc) to be specified"
            userInfo:nil];
}

@end

NS_ASSUME_NONNULL_END
