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
@property (nonatomic, assign) dispatch_queue_priority_t priority;
@property (nonatomic, strong) dispatch_queue_t handlerQueue;
@property (nonatomic, strong) NSObject *proxyLock;
@property (nonatomic, strong) NSObject *correlationIdLock;
@property (nonatomic, strong) NSObject *hmiStateLock;
@property (nonatomic, strong) NSObject *rpcResponseHandlerDictionaryLock;
@property (nonatomic, strong) NSObject *commandHandlerDictionaryLock;
@property (nonatomic, strong) NSObject *buttonHandlerDictionaryLock;
@property (nonatomic, strong) NSObject *customButtonHandlerDictionaryLock;

// SDL state variables
@property (nonatomic, strong) SDLProxy *proxy;
@property (nonatomic, assign) int correlationID;
@property (nonatomic, assign) BOOL firstHMIFullOccurred;
@property (nonatomic, assign) BOOL firstHMINotNoneOccurred;
@property (nonatomic, strong) NSException *proxyError;

// Proxy notification and event handlers
@property (nonatomic, strong) NSMutableSet *onProxyOpenedHandlers;
@property (nonatomic, strong) NSMutableSet *onProxyClosedHandlers;
@property (nonatomic, strong) NSMutableSet *firstHMIFullHandlers;
@property (nonatomic, strong) NSMutableSet *firstHMINotNoneHandlers;
@property (nonatomic, strong) NSMutableSet *proxyErrorHandlers;
@property (nonatomic, strong) NSMutableSet *appRegisteredHandlers;

// These handlers are required for the app to implement
@property (nonatomic, strong) NSMutableSet *onOnLockScreenNotificationHandlers;
@property (nonatomic, strong) NSMutableSet *onOnLanguageChangeHandlers;
@property (nonatomic, strong) NSMutableSet *onOnPermissionsChangeHandlers;

// Optional handlers
@property (nonatomic, strong) NSMutableSet *onOnDriverDistractionHandlers;
@property (nonatomic, strong) NSMutableSet *onOnHMIStatusHandlers;
@property (nonatomic, strong) NSMutableSet *onOnAppInterfaceUnregisteredHandlers;
@property (nonatomic, strong) NSMutableSet *onOnAudioPassThruHandlers;
@property (nonatomic, strong) NSMutableSet *onOnButtonEventHandlers;
@property (nonatomic, strong) NSMutableSet *onOnButtonPressHandlers;
@property (nonatomic, strong) NSMutableSet *onOnCommandHandlers;
@property (nonatomic, strong) NSMutableSet *onOnEncodedSyncPDataHandlers;
@property (nonatomic, strong) NSMutableSet *onOnHashChangeHandlers;
@property (nonatomic, strong) NSMutableSet *onOnSyncPDataHandlers;
@property (nonatomic, strong) NSMutableSet *onOnSystemRequestHandlers;
@property (nonatomic, strong) NSMutableSet *onOnTBTClientStateHandlers;
@property (nonatomic, strong) NSMutableSet *onOnTouchEventHandlers;
@property (nonatomic, strong) NSMutableSet *onOnVehicleDataHandlers;

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
        _proxyLock = [[NSObject alloc] init];
        _correlationIdLock = [[NSObject alloc] init];
        _hmiStateLock = [[NSObject alloc] init];
        _rpcResponseHandlerDictionaryLock = [[NSObject alloc] init];
        _commandHandlerDictionaryLock = [[NSObject alloc] init];
        _buttonHandlerDictionaryLock = [[NSObject alloc] init];
        _customButtonHandlerDictionaryLock = [[NSObject alloc] init];
        _correlationID = 1;
        _priority = DISPATCH_QUEUE_PRIORITY_DEFAULT;
        _handlerQueue = dispatch_queue_create("com.sdl.proxy_base.handler_queue", DISPATCH_QUEUE_CONCURRENT);
        _firstHMIFullOccurred = NO;
        _firstHMINotNoneOccurred = NO;
        _rpcResponseHandlerDictionary = [[NSMutableDictionary alloc] init];
        _commandHandlerDictionary = [[NSMutableDictionary alloc] init];
        _buttonHandlerDictionary = [[NSMutableDictionary alloc] init];
        _customButtonHandlerDictionary = [[NSMutableDictionary alloc] init];
        
        _onProxyOpenedHandlers = [[NSMutableSet alloc] init];
        _onProxyClosedHandlers = [[NSMutableSet alloc] init];
        _firstHMIFullHandlers = [[NSMutableSet alloc] init];
        _firstHMINotNoneHandlers = [[NSMutableSet alloc] init];
        _proxyErrorHandlers = [[NSMutableSet alloc] init];
        _appRegisteredHandlers = [[NSMutableSet alloc] init];
        _onOnLockScreenNotificationHandlers = [[NSMutableSet alloc] init];
        _onOnLanguageChangeHandlers = [[NSMutableSet alloc] init];
        _onOnPermissionsChangeHandlers = [[NSMutableSet alloc] init];
        _onOnDriverDistractionHandlers = [[NSMutableSet alloc] init];
        _onOnHMIStatusHandlers = [[NSMutableSet alloc] init];
        _onOnAppInterfaceUnregisteredHandlers = [[NSMutableSet alloc] init];
        _onOnAudioPassThruHandlers = [[NSMutableSet alloc] init];
        _onOnButtonEventHandlers = [[NSMutableSet alloc] init];
        _onOnButtonPressHandlers = [[NSMutableSet alloc] init];
        _onOnCommandHandlers = [[NSMutableSet alloc] init];
        _onOnEncodedSyncPDataHandlers = [[NSMutableSet alloc] init];
        _onOnHashChangeHandlers = [[NSMutableSet alloc] init];
        _onOnSyncPDataHandlers = [[NSMutableSet alloc] init];
        _onOnSystemRequestHandlers = [[NSMutableSet alloc] init];
        _onOnTBTClientStateHandlers = [[NSMutableSet alloc] init];
        _onOnTouchEventHandlers = [[NSMutableSet alloc] init];
        _onOnVehicleDataHandlers = [[NSMutableSet alloc] init];
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

- (void)addOnProxyOpenedHandler:(eventHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onProxyOpenedHandlers addObject:[handler copy]];
    });
}

- (void)addOnProxyClosedHandler:(eventHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onProxyClosedHandlers addObject:[handler copy]];
    });
}

- (void)addFirstHMIFullHandler:(eventHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.firstHMIFullHandlers addObject:[handler copy]];
    });
}

- (void)addFirstHMINotNoneHandler:(eventHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.firstHMINotNoneHandlers addObject:[handler copy]];
    });
}

- (void)addProxyErrorHandler:(errorHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.proxyErrorHandlers addObject:[handler copy]];
    });
}

- (void)addAppRegisteredHandler:(rpcResponseHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.appRegisteredHandlers addObject:[handler copy]];
    });
}

- (void)addOnOnLockScreenNotificationHandler:(rpcNotificationHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onOnLockScreenNotificationHandlers addObject:[handler copy]];
    });
}

- (void)addOnOnLanguageChangeHandler:(rpcNotificationHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onOnLanguageChangeHandlers addObject:[handler copy]];
    });
}

- (void)addOnOnPermissionsChangeHandler:(rpcNotificationHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onOnPermissionsChangeHandlers addObject:[handler copy]];
    });
}

- (void)addOnOnDriverDistractionHandler:(rpcNotificationHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onOnDriverDistractionHandlers addObject:[handler copy]];
    });
}

- (void)addOnOnHMIStatusHandler:(rpcNotificationHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onOnHMIStatusHandlers addObject:[handler copy]];
    });
}

- (void)addOnOnAppInterfaceUnregisteredHandler:(rpcNotificationHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onOnAppInterfaceUnregisteredHandlers addObject:[handler copy]];
    });
}

- (void)addOnOnAudioPassThruHandler:(rpcNotificationHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onOnAudioPassThruHandlers addObject:[handler copy]];
    });
}

- (void)addOnOnButtonEventHandler:(rpcNotificationHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onOnButtonEventHandlers addObject:[handler copy]];
    });
}

- (void)addOnOnButtonPressHandler:(rpcNotificationHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onOnButtonPressHandlers addObject:[handler copy]];
    });
}

- (void)addOnOnCommandHandler:(rpcNotificationHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onOnCommandHandlers addObject:[handler copy]];
    });
}

- (void)addOnOnEncodedSyncPDataHandler:(rpcNotificationHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onOnEncodedSyncPDataHandlers addObject:[handler copy]];
    });
}

- (void)addOnOnHashChangeHandler:(rpcNotificationHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onOnHashChangeHandlers addObject:[handler copy]];
    });
}

- (void)addOnOnSyncPDataHandler:(rpcNotificationHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onOnSyncPDataHandlers addObject:[handler copy]];
    });
}

- (void)addOnOnSystemRequestHandler:(rpcNotificationHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onOnSystemRequestHandlers addObject:[handler copy]];
    });
}

- (void)addOnOnTBTClientStateHandler:(rpcNotificationHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onOnTBTClientStateHandlers addObject:[handler copy]];
    });
}

- (void)addOnOnTouchEventHandler:(rpcNotificationHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onOnTouchEventHandlers addObject:[handler copy]];
    });
}

- (void)addOnOnVehicleDataHandler:(rpcNotificationHandler)handler {
    dispatch_barrier_async(self.handlerQueue, ^{
        [self.onOnVehicleDataHandlers addObject:[handler copy]];
    });
}

- (void)runHandlersForEvent:(enum SDLEvent)sdlEvent error:(NSException *)error {
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

- (void)runHandlersForResponse:(SDLRPCResponse *)response {
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

- (void)runHandlersForNotification:(SDLRPCNotification *)notification {
    rpcNotificationHandler handler = nil;
    __weak typeof(self) weakSelf = self;

    void(^handlerEnumBlock)(rpcNotificationHandler, BOOL*) = ^(rpcNotificationHandler hand, BOOL *stop) {
        dispatch_async(dispatch_get_global_queue(self.priority, 0), ^{
            hand(notification);
        });
    };
    
    if ([notification isKindOfClass:[SDLOnHMIStatus class]]) {
        dispatch_async(dispatch_get_global_queue(self.priority, 0), ^{
            [weakSelf onHMIStatus:((SDLOnHMIStatus *)notification)];
        });
    }
    else if ([notification isKindOfClass:[SDLOnCommand class]]) {
        dispatch_async(dispatch_get_global_queue(self.priority, 0), ^{
            [weakSelf runHandlerForCommand:((SDLOnCommand *)notification)];
        });
    }
    // Note: This isn't needed now?
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
        [weakSelf.onOnDriverDistractionHandlers enumerateObjectsUsingBlock:handlerEnumBlock];
    }
    else if ([notification isKindOfClass:[SDLOnAppInterfaceUnregistered class]]) {
        [weakSelf.onOnAppInterfaceUnregisteredHandlers enumerateObjectsUsingBlock:handlerEnumBlock];
    }
    else if ([notification isKindOfClass:[SDLOnAudioPassThru class]]) {
        [weakSelf.onOnAudioPassThruHandlers enumerateObjectsUsingBlock:handlerEnumBlock];
    }
    else if ([notification isKindOfClass:[SDLOnEncodedSyncPData class]]) {
        [weakSelf.onOnEncodedSyncPDataHandlers enumerateObjectsUsingBlock:handlerEnumBlock];
    }
    else if ([notification isKindOfClass:[SDLOnHashChange class]]) {
        [weakSelf.onOnHashChangeHandlers enumerateObjectsUsingBlock:handlerEnumBlock];
    }
    else if ([notification isKindOfClass:[SDLOnLanguageChange class]]) {
        [weakSelf.onOnLanguageChangeHandlers enumerateObjectsUsingBlock:handlerEnumBlock];
    }
    else if ([notification isKindOfClass:[SDLOnPermissionsChange class]]) {
        [weakSelf.onOnPermissionsChangeHandlers enumerateObjectsUsingBlock:handlerEnumBlock];
    }
    else if ([notification isKindOfClass:[SDLOnSyncPData class]]) {
        [weakSelf.onOnSyncPDataHandlers enumerateObjectsUsingBlock:handlerEnumBlock];
    }
    else if ([notification isKindOfClass:[SDLOnSystemRequest class]]) {
        [weakSelf.onOnSystemRequestHandlers enumerateObjectsUsingBlock:handlerEnumBlock];
    }
    else if ([notification isKindOfClass:[SDLOnTBTClientState class]]) {
        [weakSelf.onOnTBTClientStateHandlers enumerateObjectsUsingBlock:handlerEnumBlock];
    }
    else if ([notification isKindOfClass:[SDLOnTouchEvent class]]) {
        [weakSelf.onOnTouchEventHandlers enumerateObjectsUsingBlock:handlerEnumBlock];
    }
    else if ([notification isKindOfClass:[SDLOnVehicleData class]]) {
        [weakSelf.onOnVehicleDataHandlers enumerateObjectsUsingBlock:handlerEnumBlock];
    }
    else if ([notification isKindOfClass:[SDLOnLockScreenStatus class]]) {
        [weakSelf.onOnLockScreenNotificationHandlers enumerateObjectsUsingBlock:handlerEnumBlock];
    }
}

- (void)runHandlerForCommand:(SDLOnCommand *)command {
    // Already dispatched from caller
    rpcNotificationHandler handler = nil;
    @synchronized(self.commandHandlerDictionaryLock) {
        handler = [self.commandHandlerDictionary objectForKey:command.cmdID];
    }
    
    if (handler) {
        handler(command);
    }
    
    // TODO: Should this even be a thing still?
    if ([self.onOnCommandHandlers count] > 0) {
        [self.onOnCommandHandlers enumerateObjectsUsingBlock:^(rpcNotificationHandler hand, BOOL *stop) {
            hand(command);
        }];
    }
}

//TODO: resume here
- (void)runHandlerForButton:(SDLRPCNotification *)notification {
    // Already dispatched from caller
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
    // Already dispatched from caller
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(self.priority, 0), ^{
        if (weakSelf.proxyErrorHandler) {
            weakSelf.proxyErrorHandler(e);
        }
    });
}

- (void)onProxyOpened {
    // Already dispatched from caller
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
    // Already dispatched from caller
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
    // Already dispatched from caller
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
