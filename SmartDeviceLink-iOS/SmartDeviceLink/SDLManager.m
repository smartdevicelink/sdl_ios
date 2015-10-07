//  SDLProxyBase.m
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>

#import "SmartDeviceLink.h" // TODO: Don't import everything ever

#import "SDLManager.h"

#import "NSMapTable+Subscripting.h"
#import "SDLErrorConstants.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLNotificationConstants.h"


NS_ASSUME_NONNULL_BEGIN

#pragma mark - Private Typedefs and Constants

typedef NSNumber SDLRPCCorrelationID;
typedef NSNumber SDLSoftButtonCommandID;
typedef NSNumber SDLAddCommandCommandID;
typedef NSNumber SDLSubscribeButtonCommandID;


#pragma mark - SDLManager NSError Category Interface

@interface NSError (SDLManagerErrors)

+ (NSError *)sdl_rpcErrorWithDescription:(NSString *)description andReason:(NSString *)reason;
+ (NSError *)sdl_notConnectedError;
+ (NSError *)sdl_unknownHeadUnitErrorWithDescription:(NSString *)description andReason:(NSString *)reason;

@end


#pragma mark - SDLManager Private Interface

@interface SDLManager () <SDLProxyListener>

@property (copy, nonatomic, readwrite) SDLLifecycleConfiguration *configuration;

// SDL state
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (strong, nonatomic, nullable) SDLProxy *proxy;
#pragma clang diagnostic pop

@property (assign, nonatomic) UInt32 correlationID;
@property (assign, nonatomic) BOOL firstHMIFullOccurred;
@property (assign, nonatomic) BOOL firstHMINotNoneOccurred;
@property (assign, getter=isConnected, nonatomic) BOOL connected;

// Dictionaries to link handlers with requests/commands/etc
@property (strong, nonatomic) NSMapTable<SDLRPCCorrelationID *, SDLRequestCompletionHandler> *rpcResponseHandlerMap;
@property (strong, nonatomic) NSMutableDictionary<SDLRPCCorrelationID *, SDLRPCRequest *> *rpcRequestDictionary;
@property (strong, nonatomic) NSMapTable<SDLAddCommandCommandID *, SDLRPCNotificationHandler> *commandHandlerMap;
@property (strong, nonatomic) NSMapTable<SDLSubscribeButtonCommandID *, SDLRPCNotificationHandler> *buttonHandlerMap;
@property (strong, nonatomic) NSMapTable<SDLSoftButtonCommandID *, SDLRPCNotificationHandler> *customButtonHandlerMap;

@end


#pragma mark - SDLManager Implementation

@implementation SDLManager

#pragma mark Lifecycle

+ (instancetype)sharedManager {
    static SDLManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SDLManager alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _connected = NO;
    _configuration = nil;
    
    _correlationID = 1;
    _firstHMIFullOccurred = NO;
    _firstHMINotNoneOccurred = NO;
    _rpcResponseHandlerMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];
    _rpcRequestDictionary = [[NSMutableDictionary alloc] init];
    _commandHandlerMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];
    _buttonHandlerMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];
    _customButtonHandlerMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];
    
    return self;
}


#pragma mark Event, Response, Notification Processing

- (void)sdl_postNotification:(NSString *)name info:(nullable id)info {
    NSDictionary<NSString *, id> *userInfo = nil;
    if (info != nil) {
        userInfo = @{ SDLNotificationUserInfoNotificationObject: info };
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:userInfo];
}


- (void)sdl_runHandlersForResponse:(SDLRPCResponse *)response {
    NSError *error = nil;
    BOOL success = [response.success boolValue];
    if (success == NO) {
        error = [NSError sdl_rpcErrorWithDescription:response.resultCode.value andReason:response.info];
    }
    
    SDLRequestCompletionHandler handler = self.rpcResponseHandlerMap[response.correlationID];
    SDLRPCRequest *request = self.rpcRequestDictionary[response.correlationID];
    [self.rpcRequestDictionary removeObjectForKey:response.correlationID];
    [self.rpcResponseHandlerMap removeObjectForKey:response.correlationID];
    
    if (handler) {
        handler(request, response, error);
    }
    
    // Check for UnsubscribeButton, DeleteCommand and remove handlers
    if ([response isKindOfClass:[SDLDeleteCommandResponse class]]) {
        // TODO
        // The Command ID needs to be stored from the request RPC and then used here
    }
    else if ([response isKindOfClass:[SDLUnsubscribeButtonResponse class]]) {
        // TODO
    }
}

- (void)sdl_runHandlerForCommand:(SDLOnCommand *)command {
    // Already background dispatched from caller
    SDLRPCNotificationHandler handler = nil;
    handler = self.commandHandlerMap[command.cmdID];
    
    if (handler) {
        handler(command);
    }
}

- (void)sdl_runHandlerForButton:(__kindof SDLRPCNotification *)notification {
    // Already background dispatched from caller
    SDLRPCNotificationHandler handler = nil;
    SDLButtonName *name = nil;
    NSNumber *customID = nil;
    
    if ([notification isKindOfClass:[SDLOnButtonEvent class]]) {
        name = ((SDLOnButtonEvent *)notification).buttonName;
        customID = ((SDLOnButtonEvent *)notification).customButtonID;
    }
    else if ([notification isKindOfClass:[SDLOnButtonPress class]]) {
        name = ((SDLOnButtonPress *)notification).buttonName;
        customID = ((SDLOnButtonPress *)notification).customButtonID;
    }
    
    if ([name isEqual:[SDLButtonName CUSTOM_BUTTON]]) {
        handler = self.customButtonHandlerMap[customID];
    }
    else {
        handler = self.buttonHandlerMap[name.value];
    }
    
    if (handler) {
        handler(notification);
    }
}


#pragma mark Proxy Wrappers

- (void)sendRequest:(SDLRPCRequest *)request withCompletionHandler:(nullable SDLRequestCompletionHandler)handler {
    if (!self.isConnected) {
        [SDLDebugTool logInfo:@"Proxy not connected! Not sending RPC."];
        
        if (handler) {
            handler(nil, nil, [NSError sdl_notConnectedError]);
        }
        
        return;
    }
    // Add a correlation ID
    NSNumber *corrID = [self sdl_getNextCorrelationId];
    request.correlationID = corrID;
    
    // Check for RPCs that require an extra handler
    // TODO: add SDLAlert and SDLScrollableMessage
    if ([request isKindOfClass:[SDLShow class]]) {
        SDLShow *show = (SDLShow *)request;
        NSMutableArray<SDLSoftButton *> *softButtons = show.softButtons;
        if (softButtons && softButtons.count > 0) {
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
    else if ([request isKindOfClass:[SDLAddCommand class]]) {
        // TODO: Can we create CmdIDs ourselves?
        SDLAddCommand *addCommand = (SDLAddCommand *)request;
        
        if (!addCommand.cmdID) {
            @throw [SDLManager sdl_missingIDException];
        }
        if (addCommand.handler) {
            self.commandHandlerMap[addCommand.cmdID] = addCommand.handler;
        }
    }
    else if ([request isKindOfClass:[SDLSubscribeButton class]]) {
        // Convert SDLButtonName to NSString, since it doesn't conform to <NSCopying>
        SDLSubscribeButton *subscribeButton = (SDLSubscribeButton *)request;
        NSString *buttonName = subscribeButton.buttonName.value;
        
        if (!buttonName) {
            @throw [SDLManager sdl_missingIDException];
        }
        if (subscribeButton.handler) {
            self.buttonHandlerMap[buttonName] = subscribeButton.handler;
        }
    }
    
    if (handler) {
        self.rpcRequestDictionary[corrID] = request;
        self.rpcResponseHandlerMap[corrID] = handler;
    }
    
    [self.proxy sendRPC:request];
}

- (void)startProxyWithConfiguration:(SDLLifecycleConfiguration *)configuration {
    self.configuration = configuration;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [SDLProxy enableSiphonDebug];
    
    if (configuration.tcpDebugMode) {
        self.proxy = [SDLProxyFactory buildSDLProxyWithListener:self tcpIPAddress:configuration.tcpDebugIPAddress tcpPort:configuration.tcpDebugPort];
    } else {
        self.proxy = [SDLProxyFactory buildSDLProxyWithListener:self];
    }
#pragma clang diagnostic pop
}

- (void)sdl_startProxy {
    if (self.configuration != nil) {
        [self startProxyWithConfiguration:self.configuration];
    }
}

- (void)stopProxy {
    [self sdl_disposeProxy];
}

- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest {
    // TODO: Need to check if the put file stream needs to be on a background queue
    SDLRPCRequest *rpcWithCorrID = putFileRPCRequest;
    NSNumber *corrID = [self sdl_getNextCorrelationId];
    rpcWithCorrID.correlationID = corrID;
    
    [self.proxy putFileStream:inputStream withRequest:(SDLPutFile *)rpcWithCorrID];
}


#pragma mark Private Methods

- (void)sdl_disposeProxy {
    [SDLDebugTool logInfo:@"Stop Proxy"];
    [self.proxy dispose];
    self.proxy = nil;
    self.firstHMIFullOccurred = NO;
    self.firstHMINotNoneOccurred = NO;
}

- (NSNumber *)sdl_getNextCorrelationId {
    if (self.correlationID == UINT16_MAX) {
        self.correlationID = 0;
    }
    
    return @(self.correlationID++);
}


#pragma mark - SDLProxyListener Methods

- (void)onProxyOpened {
    [SDLDebugTool logInfo:@"onProxyOpened"];
    self.connected = YES;
    
    SDLRegisterAppInterface *regRequest = [SDLRPCRequestFactory buildRegisterAppInterfaceWithAppName:self.configuration.appName languageDesired:self.configuration.language appID:self.configuration.appId];
    regRequest.isMediaApplication = @(self.configuration.isMedia);
    regRequest.ngnMediaScreenAppName = self.configuration.shortAppName;
    
    if (self.configuration.voiceRecognitionSynonyms) {
        regRequest.vrSynonyms = [NSMutableArray arrayWithArray:self.configuration.voiceRecognitionSynonyms];
    }
    // TODO: implement handler with success/error
    [self sendRequest:regRequest withCompletionHandler:^(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *response, NSError *error) {
        if (error) {
            [self sdl_postNotification:SDLDidFailToRegisterNotification info:error];
        } else {
            [self sdl_postNotification:SDLDidRegisterNotification info:response];
        }
        
    }];
    
    [self sdl_postNotification:SDLDidConnectNotification info:nil];
}

- (void)onProxyClosed {
    // Already background dispatched from caller
    [SDLDebugTool logInfo:@"onProxyClosed"];
    self.connected = NO;
    [self sdl_disposeProxy];    // call this method instead of stopProxy to avoid double-dispatching
    [self sdl_postNotification:SDLDidDisconnectNotification info:nil];
    [self sdl_startProxy];
}

- (void)onError:(NSException *)e {
    NSError *error = [NSError sdl_unknownHeadUnitErrorWithDescription:e.name andReason:e.reason];
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
    }
    else if (notification.hmiLevel == [SDLHMILevel BACKGROUND] || notification.hmiLevel == [SDLHMILevel LIMITED]) {
        BOOL occurred = NO;
        occurred = self.firstHMINotNoneOccurred;
        if (!occurred) {
            [self sdl_postNotification:SDLDidReceiveFirstNonNoneHMIStatusNotification info:notification];
        }
        self.firstHMINotNoneOccurred = YES;
    }
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


#pragma mark - SDLManager NSError category implementation

@implementation NSError (SDLManagerErrors)

+ (NSError *)sdl_rpcErrorWithDescription:(NSString *)description andReason:(NSString *)reason {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                               };
    return [NSError errorWithDomain:SDLManagerErrorDomain
                               code:SDLManagerErrorRPCRequestFailed
                           userInfo:userInfo];
}

+ (NSError *)sdl_notConnectedError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"Could not find a connection", nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The SDL library could not find a current connection to an SDL hardware device", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                               };
    
    return [NSError errorWithDomain:SDLManagerErrorDomain
                               code:SDLManagerErrorNotConnected
                           userInfo:userInfo];
}

+ (NSError *)sdl_unknownHeadUnitErrorWithDescription:(NSString *)description andReason:(NSString *)reason {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                               };
    return [NSError errorWithDomain:SDLManagerErrorDomain
                               code:SDLManagerErrorUnknownHeadUnitError
                           userInfo:userInfo];
}

@end

NS_ASSUME_NONNULL_END
