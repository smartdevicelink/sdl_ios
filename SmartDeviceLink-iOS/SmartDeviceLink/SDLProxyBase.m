//  SDLProxyBase.m
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import "SmartDeviceLink.h"
#import "SDLProxyBase.h"
#import "SDLProxyListenerBase.h"
#import "SDLAddCommandWithHandler.h"
#import "SDLSubscribeButtonWithHandler.h"
#import "SDLSoftButtonWithHandler.h"


@interface SDLProxyBase ()

// GCD variables
@property (assign, nonatomic) dispatch_queue_priority_t priority;
@property (strong, nonatomic) NSObject *proxyLock;
@property (strong, nonatomic) NSObject *correlationIdLock;
@property (strong, nonatomic) NSObject *hmiStateLock;
@property (strong, nonatomic) NSObject *rpcResponseHandlerDictionaryLock;
@property (strong, nonatomic) NSObject *commandHandlerDictionaryLock;
@property (strong, nonatomic) NSObject *buttonHandlerDictionaryLock;
@property (strong, nonatomic) NSObject *customButtonHandlerDictionaryLock;

// SDL state variables
@property (strong, nonatomic) SDLProxy *proxy;
@property (assign, nonatomic) int correlationID;
@property (assign, nonatomic) BOOL firstHMIFullOccurred;
@property (assign, nonatomic) BOOL firstHMINotNoneOccurred;
@property (strong, nonatomic) NSException *proxyError;

// Dictionary to link RPC response handlers with the request correlationId
@property (strong, nonatomic) NSMutableDictionary *rpcResponseHandlerDictionary;
// Dictionary to link command handlers with the command ID
@property (strong, nonatomic) NSMutableDictionary *commandHandlerDictionary;
// Dictionary to link button handlers with the button name
@property (strong, nonatomic) NSMutableDictionary *buttonHandlerDictionary;
// Dictionary to link custom button handlers with the custom button ID
@property (strong, nonatomic) NSMutableDictionary *customButtonHandlerDictionary;


- (void)startProxy;
- (NSNumber *)getNextCorrelationId;
- (void)onError:(NSException *)e;
- (void)onProxyOpened;
- (void)onProxyClosed;
- (void)onHMIStatus:(SDLOnHMIStatus *)notification;
- (void)runHandlerForCommand:(SDLOnCommand *)command;
- (void)runHandlerForButton:(SDLRPCNotification *)notification;

@end


@implementation SDLProxyBase

- (id)init {
    self = [super init];
    if (self) {
        _proxyLock = [NSObject new];
        _correlationIdLock = [NSObject new];
        _hmiStateLock = [NSObject new];
        _rpcResponseHandlerDictionaryLock = [NSObject new];
        _commandHandlerDictionaryLock = [NSObject new];
        _buttonHandlerDictionaryLock = [NSObject new];
        _customButtonHandlerDictionaryLock = [NSObject new];
        _correlationID = 1;
        _priority = DISPATCH_QUEUE_PRIORITY_DEFAULT;
        _firstHMIFullOccurred = NO;
        _firstHMINotNoneOccurred = NO;
        _rpcResponseHandlerDictionary = [NSMutableDictionary new];
        _commandHandlerDictionary = [NSMutableDictionary new];
        _buttonHandlerDictionary = [NSMutableDictionary new];
        _customButtonHandlerDictionary = [NSMutableDictionary new];
    }
    return self;
}

+ (NSException *)createMissingHandlerException {
    NSException* excep = [NSException
                                exceptionWithName:@"MissingHandlerException"
                                reason:@"This request requires a handler to be specified using the <RPC>WithHandler class"
                                userInfo:nil];
    return excep;
}

+ (NSException *)createMissingIDException {
    NSException* excep = [NSException
                          exceptionWithName:@"MissingIDException"
                          reason:@"This request requires an ID (command, softbutton, etc) to be specified"
                          userInfo:nil];
    return excep;
}

- (void)runHandlerForEvent:(enum SDLEvent)sdlEvent error:(NSException *)error {
    eventHandler handler = nil;
    __weak typeof(self) weakSelf = self;
    
    if (sdlEvent == OnError) {
        self.proxyError = error;
        handler = ^{
            [weakSelf onError:weakSelf.proxyError];
        };
    }
    else if (sdlEvent == ProxyClosed) {
        handler = ^{
            [weakSelf onProxyClosed];
        };
    }
    else if (sdlEvent == ProxyOpened) {
        handler = ^{
            [weakSelf onProxyOpened];
        };
    }
    
    if (handler) {
        dispatch_async(dispatch_get_global_queue(self.priority, 0), ^{
            handler();
        });
    }
}

- (void)runHandlerForResponse:(SDLRPCResponse *)response {
    rpcResponseHandler handler = nil;
    @synchronized(self.rpcResponseHandlerDictionaryLock) {
        handler = [self.rpcResponseHandlerDictionary objectForKey:response.correlationID];
        [self.rpcResponseHandlerDictionary removeObjectForKey:response.correlationID];
    }
    if (handler) {
        dispatch_async(dispatch_get_global_queue(self.priority, 0), ^{
            handler(response);
        });
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

- (void)runHandlerForNotification:(SDLRPCNotification *)notification {
    rpcNotificationHandler handler = nil;
    __weak typeof(self) weakSelf = self;
    
    if ([notification isKindOfClass:[SDLOnHMIStatus class]]) {
        handler = ^(SDLRPCNotification *notification){
            [weakSelf onHMIStatus:((SDLOnHMIStatus *)notification)];
        };
    }
    else if ([notification isKindOfClass:[SDLOnCommand class]]) {
        handler = ^(SDLRPCNotification *command){
            [weakSelf runHandlerForCommand:((SDLOnCommand *)notification)];
        };
    }
    /*else if ([notification isKindOfClass:[SDLOnButtonEvent class]]) {
        handler = ^(SDLRPCNotification *notification){
            [weakSelf runHandlerForButton:((SDLRPCNotification *)notification)];
        };
    }*/
    else if ([notification isKindOfClass:[SDLOnButtonPress class]]) {
        handler = ^(SDLRPCNotification *notification){
            [weakSelf runHandlerForButton:((SDLRPCNotification *)notification)];
        };
    }
    else if ([notification isKindOfClass:[SDLOnDriverDistraction class]]) {
        handler = self.onOnDriverDistractionHandler;
    }
    else if ([notification isKindOfClass:[SDLOnAppInterfaceUnregistered class]]) {
        handler = self.onOnAppInterfaceUnregisteredHandler;
    }
    else if ([notification isKindOfClass:[SDLOnAudioPassThru class]]) {
        handler = self.onOnAudioPassThruHandler;
    }
    else if ([notification isKindOfClass:[SDLOnEncodedSyncPData class]]) {
        handler = self.onOnEncodedSyncPDataHandler;
    }
    else if ([notification isKindOfClass:[SDLOnHashChange class]]) {
        handler = self.onOnHashChangeHandler;
    }
    else if ([notification isKindOfClass:[SDLOnLanguageChange class]]) {
        handler = self.onOnLanguageChangeHandler;
    }
    else if ([notification isKindOfClass:[SDLOnPermissionsChange class]]) {
        handler = self.onOnPermissionsChangeHandler;
    }
    else if ([notification isKindOfClass:[SDLOnSyncPData class]]) {
        handler = self.onOnSyncPDataHandler;
    }
    else if ([notification isKindOfClass:[SDLOnSystemRequest class]]) {
        handler = self.onOnSystemRequestHandler;
    }
    else if ([notification isKindOfClass:[SDLOnTBTClientState class]]) {
        handler = self.onOnTBTClientStateHandler;
    }
    else if ([notification isKindOfClass:[SDLOnTouchEvent class]]) {
        handler = self.onOnTouchEventHandler;
    }
    else if ([notification isKindOfClass:[SDLOnVehicleData class]]) {
        handler = self.onOnVehicleDataHandler;
    }
    else if ([notification isKindOfClass:[SDLOnLockScreenStatus class]]) {
        handler = self.onOnLockScreenNotificationHandler;
    }
    
    if (handler) {
        dispatch_async(dispatch_get_global_queue(self.priority, 0), ^{
            handler(notification);
        });
    }
}

- (void)runHandlerForCommand:(SDLOnCommand *)command {
    rpcNotificationHandler handler = nil;
    @synchronized(self.commandHandlerDictionaryLock) {
        handler = [self.commandHandlerDictionary objectForKey:command.cmdID];
    }
    
    // Already dispatched at this point, no need to do it again
    if (handler) {
        handler(command);
    }
    
    // TODO: Should this even be a thing still?
    if (self.onOnCommandHandler) {
        self.onOnCommandHandler(command);
    }
}

- (void)runHandlerForButton:(SDLRPCNotification *)notification {
    rpcNotificationHandler handler = nil;
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
        @synchronized(self.customButtonHandlerDictionaryLock) {
            handler = [self.customButtonHandlerDictionary objectForKey:customID];
        }
    }
    else {
        @synchronized(self.buttonHandlerDictionaryLock) {
            handler = [self.buttonHandlerDictionary objectForKey:name.value];
        }
    }
    
    // Already dispatched at this point, no need to do it again
    if (handler) {
        handler(notification);
    }
    
    // TODO: Should this even be a thing still?
    if ([notification isKindOfClass:[SDLOnButtonEvent class]]) {
        if (self.onOnButtonEventHandler) {
            self.onOnButtonEventHandler(notification);
        }
    }
    else if ([notification isKindOfClass:[SDLOnButtonPress class]]) {
        if (self.onOnButtonPressHandler) {
            self.onOnButtonPressHandler(notification);
        }
    }
}

- (void)sendRPC:(SDLRPCRequest *)rpc responseHandler:(rpcResponseHandler)responseHandler {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(self.priority, 0), ^{
        // Add a correlation ID
        SDLRPCRequest *rpcWithCorrID = rpc;
        NSNumber *corrID = [weakSelf getNextCorrelationId];
        rpcWithCorrID.correlationID = corrID;
        
        // Check for RPCs that require an extra handler
        // TODO: add SDLAlert and SDLScrollableMessage
        if ([rpcWithCorrID isKindOfClass:[SDLShow class]]) {
            SDLShow *show = (SDLShow *)rpcWithCorrID;
            NSMutableArray *softButtons = show.softButtons;
            if (softButtons && softButtons.count > 0) {
                for (SDLSoftButton *sb in softButtons) {
                    if (![sb isKindOfClass:[SDLSoftButtonWithHandler class]] || ((SDLSoftButtonWithHandler *)sb).onButtonHandler == nil) {
                        @throw [SDLProxyBase createMissingHandlerException];
                    }
                    if (!sb.softButtonID) {
                        @throw [SDLProxyBase createMissingIDException];
                    }
                    @synchronized(weakSelf.customButtonHandlerDictionaryLock) {
                        weakSelf.customButtonHandlerDictionary[sb.softButtonID] = ((SDLSoftButtonWithHandler *)sb).onButtonHandler;
                    }
                }
            }
        }
        else if ([rpcWithCorrID isKindOfClass:[SDLAddCommand class]]) {
            if (![rpcWithCorrID isKindOfClass:[SDLAddCommandWithHandler class]] || ((SDLAddCommandWithHandler *)rpcWithCorrID).onCommandHandler == nil) {
                @throw [SDLProxyBase createMissingHandlerException];
            }
            if (!((SDLAddCommandWithHandler *)rpcWithCorrID).cmdID) {
                @throw [SDLProxyBase createMissingIDException];
            }
            @synchronized(weakSelf.commandHandlerDictionaryLock) {
                weakSelf.commandHandlerDictionary[((SDLAddCommandWithHandler *)rpcWithCorrID).cmdID] = ((SDLAddCommandWithHandler *)rpcWithCorrID).onCommandHandler;
            }
        }
        else if ([rpcWithCorrID isKindOfClass:[SDLSubscribeButton class]]) {
            if (![rpcWithCorrID isKindOfClass:[SDLSubscribeButtonWithHandler class]] || ((SDLSubscribeButtonWithHandler *)rpcWithCorrID).onButtonHandler == nil) {
                @throw [SDLProxyBase createMissingHandlerException];
            }
            // Convert SDLButtonName to NSString, since it doesn't conform to <NSCopying>
            NSString *buttonName = ((SDLSubscribeButtonWithHandler *)rpcWithCorrID).buttonName.value;
            if (!buttonName) {
                @throw [SDLProxyBase createMissingIDException];
            }
            @synchronized(weakSelf.buttonHandlerDictionaryLock) {
                weakSelf.buttonHandlerDictionary[buttonName] = ((SDLSubscribeButtonWithHandler *)rpcWithCorrID).onButtonHandler;
            }
        }
        
        if (responseHandler) {
            @synchronized(weakSelf.rpcResponseHandlerDictionaryLock) {
                weakSelf.rpcResponseHandlerDictionary[corrID] = responseHandler;
            }
        }
        @synchronized(weakSelf.proxyLock) {
            [weakSelf.proxy sendRPC:rpcWithCorrID];
        }
    });
}

- (void)startProxyWithLockscreenHandler:(rpcNotificationHandler)lockscreenHandler
                  languageChangeHandler:(rpcNotificationHandler)languageChangeHandler
               permissionsChangeHandler:(rpcNotificationHandler)permissionsChangeHandler appName:(NSString *)appName appID:(NSString *)appID isMedia:(BOOL)isMedia languageDesired:(SDLLanguage *)languageDesired {
    
    self.appName = appName;
    self.appID = appID;
    self.isMedia = isMedia;
    self.languageDesired = languageDesired;
    self.onOnLockScreenNotificationHandler = lockscreenHandler;
    self.onOnLanguageChangeHandler = languageChangeHandler;
    self.onOnPermissionsChangeHandler = permissionsChangeHandler;
    
    if (self.appName && self.appID && self.languageDesired &&
        self.onOnLockScreenNotificationHandler &&
        self.onOnLockScreenNotificationHandler && self.onOnPermissionsChangeHandler)
    {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(self.priority, 0), ^{
            [SDLDebugTool logInfo:@"Start Proxy"];
            SDLProxyListenerBase *listener = [[SDLProxyListenerBase alloc] initWithProxyBase:weakSelf];
            @synchronized(self.proxyLock) {
                [SDLProxy enableSiphonDebug];
                weakSelf.proxy = [SDLProxyFactory buildSDLProxyWithListener:listener];
            }
        });
    }
    else {
        [SDLDebugTool logInfo:@"Error: One or more parameters is nil"];
    }
}

- (void)startProxy {
    [self startProxyWithLockscreenHandler:self.onOnLockScreenNotificationHandler
                    languageChangeHandler:self.onOnLanguageChangeHandler
                 permissionsChangeHandler:self.onOnPermissionsChangeHandler
                                  appName:self.appName appID:self.appID isMedia:self.isMedia
                          languageDesired:self.languageDesired];
}

- (void)stopProxy {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(self.priority, 0), ^{
        [SDLDebugTool logInfo:@"Stop Proxy"];
        @synchronized(weakSelf.proxyLock) {
            [weakSelf.proxy dispose];
            weakSelf.proxy = nil;
        }
        @synchronized(weakSelf.hmiStateLock) {
            weakSelf.firstHMIFullOccurred = NO;
            weakSelf.firstHMINotNoneOccurred = NO;
        }
    });
}

- (NSNumber *)getNextCorrelationId {
    NSNumber *corrId = nil;
    @synchronized(self.correlationIdLock) {
        self.correlationID++;
        corrId = [NSNumber numberWithInt:self.correlationID];
    }
    return corrId;
}

- (void)onError:(NSException *)e {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(self.priority, 0), ^{
        if (weakSelf.proxyErrorHandler) {
            weakSelf.proxyErrorHandler(e);
        }
    });
}

- (void)onProxyOpened {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(self.priority, 0), ^{
        [SDLDebugTool logInfo:@"onProxyOpened"];
        SDLRegisterAppInterface *regRequest = [SDLRPCRequestFactory buildRegisterAppInterfaceWithAppName:weakSelf.appName languageDesired:weakSelf.languageDesired appID:weakSelf.appID];
        regRequest.isMediaApplication = [NSNumber numberWithBool:weakSelf.isMedia];
        regRequest.ngnMediaScreenAppName = weakSelf.shortName;
        if (weakSelf.vrSynonyms) {
            regRequest.vrSynonyms = [NSMutableArray arrayWithArray:weakSelf.vrSynonyms];
        }
        [weakSelf sendRPC:regRequest responseHandler:^(SDLRPCResponse *response){
            if (weakSelf.appRegisteredHandler) {
                dispatch_async(dispatch_get_global_queue(weakSelf.priority, 0), ^{
                    weakSelf.appRegisteredHandler(response);
                });
            }
        }];
        if (weakSelf.onProxyOpenedHandler) {
            weakSelf.onProxyOpenedHandler();
        }
    });
}

- (void)onProxyClosed {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(self.priority, 0), ^{
        [SDLDebugTool logInfo:@"onProxyClosed"];
        [weakSelf stopProxy];
        [weakSelf startProxy];
        if (weakSelf.onProxyClosedHandler) {
            weakSelf.onProxyClosedHandler();
        }
    });
}

- (void)onHMIStatus:(SDLOnHMIStatus *)notification {
    [SDLDebugTool logInfo:@"onOnHMIStatus"];
    if (notification.hmiLevel == [SDLHMILevel FULL])
    {
        BOOL occurred = NO;
        @synchronized(self.hmiStateLock) {
            occurred = self.firstHMINotNoneOccurred;
        }
        if (!occurred)
        {
            if (self.firstHMINotNoneHandler) {
                self.firstHMINotNoneHandler();
            }
        }
        @synchronized(self.hmiStateLock) {
            self.firstHMINotNoneOccurred = YES;
        }

        @synchronized(self.hmiStateLock) {
            occurred = self.firstHMIFullOccurred;
        }
        if (!occurred)
        {
            if (self.firstHMIFullHandler) {
                self.firstHMIFullHandler();
            }
        }
        @synchronized(self.hmiStateLock) {
            self.firstHMIFullOccurred = YES;
        }
    }
    else if (notification.hmiLevel == [SDLHMILevel BACKGROUND] || notification.hmiLevel == [SDLHMILevel LIMITED])
    {
        BOOL occurred = NO;
        @synchronized(self.hmiStateLock) {
            occurred = self.firstHMINotNoneOccurred;
        }
        if (!occurred)
        {
            if (self.firstHMINotNoneHandler) {
                self.firstHMINotNoneHandler();
            }
        }
        @synchronized(self.hmiStateLock) {
            self.firstHMINotNoneOccurred = YES;
        }
    }
    if (self.onOnHMIStatusHandler) {
        self.onOnHMIStatusHandler(notification);
    }
}

- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(self.priority, 0), ^{
        // Add a correlation ID
        SDLRPCRequest *rpcWithCorrID = putFileRPCRequest;
        NSNumber *corrID = [weakSelf getNextCorrelationId];
        rpcWithCorrID.correlationID = corrID;
        
        @synchronized(weakSelf.proxyLock) {
            [weakSelf.proxy putFileStream:inputStream withRequest:(SDLPutFile *)rpcWithCorrID];
        }
    });
}

@end
