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
@property (nonatomic, strong) dispatch_queue_t handlerQueue;
@property (nonatomic, strong) dispatch_queue_t backgroundQueue;
//@property (nonatomic, strong) dispatch_queue_t mainUIQueue;
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
@property (assign, nonatomic) BOOL isConnected;

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
        _isConnected = NO;
        _handlerQueue = dispatch_queue_create("com.sdl.proxy_base.handler_queue", DISPATCH_QUEUE_CONCURRENT);
        _backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //_mainUIQueue = dispatch_get_main_queue();
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

- (void)addEventHandler:(eventHandler)handler toSet:(NSMutableSet *)set {
    if (handler) {
        dispatch_barrier_async(self.handlerQueue, ^{
            [set addObject:[handler copy]];
        });
    }
}

- (void)addNotificationHandler:(rpcNotificationHandler)handler toSet:(NSMutableSet *)set {
    if (handler) {
        dispatch_barrier_async(self.handlerQueue, ^{
            [set addObject:[handler copy]];
        });
    }
}

- (void)addProxyErrorHandler:(errorHandler)handler {
    if (handler) {
        dispatch_barrier_async(self.handlerQueue, ^{
            [self.proxyErrorHandlers addObject:[handler copy]];
        });
    }
}

- (void)addAppRegisteredHandler:(rpcResponseHandler)handler {
    if (handler) {
        dispatch_barrier_async(self.handlerQueue, ^{
            [self.appRegisteredHandlers addObject:[handler copy]];
        });
    }
}

- (void)addOnProxyOpenedHandler:(eventHandler)handler {
    [self addEventHandler:handler toSet:self.onProxyOpenedHandlers];
}

- (void)addOnProxyClosedHandler:(eventHandler)handler {
    [self addEventHandler:handler toSet:self.onProxyClosedHandlers];
}

- (void)addFirstHMIFullHandler:(eventHandler)handler {
    [self addEventHandler:handler toSet:self.firstHMIFullHandlers];
}

- (void)addFirstHMINotNoneHandler:(eventHandler)handler {
    [self addEventHandler:handler toSet:self.firstHMINotNoneHandlers];
}

- (void)addOnOnLockScreenNotificationHandler:(rpcNotificationHandler)handler {
    [self addNotificationHandler:handler toSet:self.onOnLockScreenNotificationHandlers];
}

- (void)addOnOnLanguageChangeHandler:(rpcNotificationHandler)handler {
    [self addNotificationHandler:handler toSet:self.onOnLanguageChangeHandlers];
}

- (void)addOnOnPermissionsChangeHandler:(rpcNotificationHandler)handler {
    [self addNotificationHandler:handler toSet:self.onOnPermissionsChangeHandlers];
}

- (void)addOnOnDriverDistractionHandler:(rpcNotificationHandler)handler {
    [self addNotificationHandler:handler toSet:self.onOnDriverDistractionHandlers];
}

- (void)addOnOnHMIStatusHandler:(rpcNotificationHandler)handler {
    [self addNotificationHandler:handler toSet:self.onOnHMIStatusHandlers];
}

- (void)addOnOnAppInterfaceUnregisteredHandler:(rpcNotificationHandler)handler {
    [self addNotificationHandler:handler toSet:self.onOnAppInterfaceUnregisteredHandlers];
}

- (void)addOnOnAudioPassThruHandler:(rpcNotificationHandler)handler {
    [self addNotificationHandler:handler toSet:self.onOnAudioPassThruHandlers];
}

- (void)addOnOnButtonEventHandler:(rpcNotificationHandler)handler {
    [self addNotificationHandler:handler toSet:self.onOnButtonEventHandlers];
}

- (void)addOnOnButtonPressHandler:(rpcNotificationHandler)handler {
    [self addNotificationHandler:handler toSet:self.onOnButtonPressHandlers];
}

- (void)addOnOnCommandHandler:(rpcNotificationHandler)handler {
    [self addNotificationHandler:handler toSet:self.onOnCommandHandlers];
}

- (void)addOnOnEncodedSyncPDataHandler:(rpcNotificationHandler)handler {
    [self addNotificationHandler:handler toSet:self.onOnEncodedSyncPDataHandlers];
}

- (void)addOnOnHashChangeHandler:(rpcNotificationHandler)handler {
    [self addNotificationHandler:handler toSet:self.onOnHashChangeHandlers];
}

- (void)addOnOnSyncPDataHandler:(rpcNotificationHandler)handler {
    [self addNotificationHandler:handler toSet:self.onOnSyncPDataHandlers];
}

- (void)addOnOnSystemRequestHandler:(rpcNotificationHandler)handler {
    [self addNotificationHandler:handler toSet:self.onOnSystemRequestHandlers];
}

- (void)addOnOnTBTClientStateHandler:(rpcNotificationHandler)handler {
    [self addNotificationHandler:handler toSet:self.onOnTBTClientStateHandlers];
}

- (void)addOnOnTouchEventHandler:(rpcNotificationHandler)handler {
    [self addNotificationHandler:handler toSet:self.onOnTouchEventHandlers];
}

- (void)addOnOnVehicleDataHandler:(rpcNotificationHandler)handler {
    [self addNotificationHandler:handler toSet:self.onOnVehicleDataHandlers];
}

- (void)runHandlersForEvent:(enum SDLEvent)sdlEvent error:(NSException *)error {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.backgroundQueue, ^{
        if (sdlEvent == OnError) {
            weakSelf.proxyError = error;
            [weakSelf onError:weakSelf.proxyError];
        }
        else if (sdlEvent == ProxyClosed) {
            [weakSelf onProxyClosed];
        }
        else if (sdlEvent == ProxyOpened) {
            [weakSelf onProxyOpened];
        }
    });
}

- (void)runHandlersForResponse:(SDLRPCResponse *)response {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.backgroundQueue, ^{
        @synchronized(weakSelf.rpcResponseHandlerDictionaryLock) {
            @autoreleasepool {
                rpcResponseHandler handler = [weakSelf.rpcResponseHandlerDictionary objectForKey:response.correlationID];
                [weakSelf.rpcResponseHandlerDictionary removeObjectForKey:response.correlationID];
                if (handler) {
                    dispatch_async(weakSelf.handlerQueue, ^{
                        handler(response);
                    });
                }
            }
        }
        // Check for UnsubscribeButton, DeleteCommand and remove handlers
        if ([response isKindOfClass:[SDLDeleteCommandResponse class]]) {
            // TODO
            // The Command ID needs to be stored from the request RPC and then used here
        }
        else if ([response isKindOfClass:[SDLUnsubscribeButtonResponse class]]) {
            // TODO
        }
    });
}

- (void)runHandlersForNotification:(SDLRPCNotification *)notification {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.backgroundQueue, ^{
        @autoreleasepool {
            NSMutableSet *handlerSet = nil;
            
            if ([notification isKindOfClass:[SDLOnHMIStatus class]]) {
                [weakSelf onHMIStatus:((SDLOnHMIStatus *)notification)];
            }
            else if ([notification isKindOfClass:[SDLOnCommand class]]) {
                [weakSelf runHandlerForCommand:((SDLOnCommand *)notification)];
            }
            // Note: This isn't needed now?
            /*else if ([notification isKindOfClass:[SDLOnButtonEvent class]]) {
                handler = ^(SDLRPCNotification *notification){
                    [weakSelf runHandlerForButton:((SDLRPCNotification *)notification)];
                };
            }*/
            else if ([notification isKindOfClass:[SDLOnButtonPress class]]) {
                [weakSelf runHandlerForButton:((SDLRPCNotification *)notification)];
            }
            else if ([notification isKindOfClass:[SDLOnDriverDistraction class]]) {
                handlerSet = weakSelf.onOnDriverDistractionHandlers;
            }
            else if ([notification isKindOfClass:[SDLOnAppInterfaceUnregistered class]]) {
                handlerSet = weakSelf.onOnAppInterfaceUnregisteredHandlers;
            }
            else if ([notification isKindOfClass:[SDLOnAudioPassThru class]]) {
                handlerSet = weakSelf.onOnAudioPassThruHandlers;
            }
            else if ([notification isKindOfClass:[SDLOnEncodedSyncPData class]]) {
                handlerSet = weakSelf.onOnEncodedSyncPDataHandlers;
            }
            else if ([notification isKindOfClass:[SDLOnHashChange class]]) {
                handlerSet = weakSelf.onOnHashChangeHandlers;
            }
            else if ([notification isKindOfClass:[SDLOnLanguageChange class]]) {
                handlerSet = weakSelf.onOnLanguageChangeHandlers;
            }
            else if ([notification isKindOfClass:[SDLOnPermissionsChange class]]) {
                handlerSet = weakSelf.onOnPermissionsChangeHandlers;
            }
            else if ([notification isKindOfClass:[SDLOnSyncPData class]]) {
                handlerSet = weakSelf.onOnSyncPDataHandlers;
            }
            else if ([notification isKindOfClass:[SDLOnSystemRequest class]]) {
                handlerSet = weakSelf.onOnSystemRequestHandlers;
            }
            else if ([notification isKindOfClass:[SDLOnTBTClientState class]]) {
                handlerSet = weakSelf.onOnTBTClientStateHandlers;
            }
            else if ([notification isKindOfClass:[SDLOnTouchEvent class]]) {
                handlerSet = weakSelf.onOnTouchEventHandlers;
            }
            else if ([notification isKindOfClass:[SDLOnVehicleData class]]) {
                handlerSet = weakSelf.onOnVehicleDataHandlers;
            }
            else if ([notification isKindOfClass:[SDLOnLockScreenStatus class]]) {
                handlerSet = weakSelf.onOnLockScreenNotificationHandlers;
            }

            if (handlerSet) {
                dispatch_async(weakSelf.handlerQueue, ^{
                    [handlerSet enumerateObjectsUsingBlock:^(rpcNotificationHandler hand, BOOL *stop) {
                        hand(notification);
                    }];
                });
            }
        }
    });
}

- (void)runHandlerForCommand:(SDLOnCommand *)command {
    // Already background dispatched from caller
    @autoreleasepool {
        __weak typeof(self) weakSelf = self;
        rpcNotificationHandler handler = nil;
        @synchronized(self.commandHandlerDictionaryLock) {
            handler = [self.commandHandlerDictionary objectForKey:command.cmdID];
        }
        
        if (handler) {
            dispatch_async(self.handlerQueue, ^{
                handler(command);
            });
        }
        
        // TODO: Should this even be a thing still?
        if ([self.onOnCommandHandlers count] > 0) {
            dispatch_async(self.handlerQueue, ^{
                [weakSelf.onOnCommandHandlers enumerateObjectsUsingBlock:^(rpcNotificationHandler hand, BOOL *stop) {
                    hand(command);
                }];
            });
        }
    }
}

- (void)runHandlerForButton:(SDLRPCNotification *)notification {
    // Already background dispatched from caller
    @autoreleasepool {
        __weak typeof(self) weakSelf = self;
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
            dispatch_async(self.handlerQueue, ^{
                handler(notification);
            });
        }
        
        // TODO: Should this even be a thing still?
        if ([notification isKindOfClass:[SDLOnButtonEvent class]] && [self.onOnButtonEventHandlers count] > 0) {
            dispatch_async(self.handlerQueue, ^{
                [weakSelf.onOnButtonEventHandlers enumerateObjectsUsingBlock:^(rpcNotificationHandler hand, BOOL *stop) {
                    hand(notification);
                }];
            });
        }
        else if ([notification isKindOfClass:[SDLOnButtonPress class]] && [self.onOnButtonPressHandlers count] > 0) {
            dispatch_async(self.handlerQueue, ^{
                [weakSelf.onOnButtonPressHandlers enumerateObjectsUsingBlock:^(rpcNotificationHandler hand, BOOL *stop) {
                    hand(notification);
                }];
            });
        }
    }
}

- (void)sendRPC:(SDLRPCRequest *)rpc responseHandler:(rpcResponseHandler)responseHandler {
    __weak typeof(self) weakSelf = self;
    if (self.isConnected) {
        dispatch_async(self.backgroundQueue, ^{
            @autoreleasepool {
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
            }
        });
    }
    else {
        [SDLDebugTool logInfo:@"Proxy not connected! Not sending RPC."];
    }
}

- (void)startProxyWithAppName:(NSString *)appName appID:(NSString *)appID isMedia:(BOOL)isMedia languageDesired:(SDLLanguage *)languageDesired {
    
    __weak typeof(self) weakSelf = self;
    dispatch_barrier_async(self.handlerQueue, ^{
        @autoreleasepool {
            if (appName && appID && languageDesired && [self.onOnLockScreenNotificationHandlers count] > 0 && [self.onOnLanguageChangeHandlers count] > 0 && [self.onOnPermissionsChangeHandlers count] > 0)
            {
                [SDLDebugTool logInfo:@"Start Proxy"];
                weakSelf.appName = appName;
                weakSelf.appID = appID;
                weakSelf.isMedia = isMedia;
                weakSelf.languageDesired = languageDesired;
                SDLProxyListenerBase *listener = [[SDLProxyListenerBase alloc] initWithProxyBase:weakSelf];
                @synchronized(self.proxyLock) {
                    [SDLProxy enableSiphonDebug];
                    weakSelf.proxy = [SDLProxyFactory buildSDLProxyWithListener:listener];
                }
            }
            else {
                [SDLDebugTool logInfo:@"Error: One or more parameters is nil"];
            }
        }
    });
}

- (void)startProxy {
    [self startProxyWithAppName:self.appName appID:self.appID isMedia:self.isMedia languageDesired:self.languageDesired];
}

- (void)stopProxy {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.backgroundQueue, ^{
        [weakSelf disposeProxy];
    });
}

- (void)disposeProxy {
    @autoreleasepool {
        [SDLDebugTool logInfo:@"Stop Proxy"];
        @synchronized(self.proxyLock) {
            [self.proxy dispose];
            self.proxy = nil;
        }
        @synchronized(self.hmiStateLock) {
            self.firstHMIFullOccurred = NO;
            self.firstHMINotNoneOccurred = NO;
        }
    }
}

- (NSNumber *)getNextCorrelationId {
    @autoreleasepool {
        NSNumber *corrId = nil;
        @synchronized(self.correlationIdLock) {
            self.correlationID++;
            corrId = [NSNumber numberWithInt:self.correlationID];
        }
        return corrId;
    }
}

- (void)onError:(NSException *)e {
    // Already background dispatched from caller
    @autoreleasepool {
        __weak typeof(self) weakSelf = self;
        if ([self.proxyErrorHandlers count] > 0) {
            dispatch_async(self.handlerQueue, ^{
                [weakSelf.proxyErrorHandlers enumerateObjectsUsingBlock:^(errorHandler hand, BOOL *stop) {
                    hand(e);
                }];
            });
        }
    }
}

- (void)onProxyOpened {
    // Already background dispatched from caller
    @autoreleasepool {
        __weak typeof(self) weakSelf = self;
        [SDLDebugTool logInfo:@"onProxyOpened"];
        self.isConnected = YES;
        SDLRegisterAppInterface *regRequest = [SDLRPCRequestFactory buildRegisterAppInterfaceWithAppName:self.appName languageDesired:self.languageDesired appID:self.appID];
        regRequest.isMediaApplication = [NSNumber numberWithBool:self.isMedia];
        regRequest.ngnMediaScreenAppName = self.shortName;
        if (self.vrSynonyms) {
            regRequest.vrSynonyms = [NSMutableArray arrayWithArray:self.vrSynonyms];
        }
        [self sendRPC:regRequest responseHandler:^(SDLRPCResponse *response){
            if ([self.appRegisteredHandlers count] > 0) {
                dispatch_async(self.handlerQueue, ^{
                    [weakSelf.appRegisteredHandlers enumerateObjectsUsingBlock:^(rpcResponseHandler hand, BOOL *stop) {
                        hand(response);
                    }];
                });
            }
        }];
        if ([self.onProxyOpenedHandlers count] > 0) {
            dispatch_async(self.handlerQueue, ^{
                [weakSelf.onProxyOpenedHandlers enumerateObjectsUsingBlock:^(eventHandler hand, BOOL *stop) {
                    hand();
                }];
            });
        }
    }
}

- (void)onProxyClosed {
    // Already background dispatched from caller
    @autoreleasepool {
        __weak typeof(self) weakSelf = self;
        [SDLDebugTool logInfo:@"onProxyClosed"];
        self.isConnected = NO;
        [self disposeProxy];    // call this method instead of stopProxy to avoid double-dispatching
        if ([self.onProxyClosedHandlers count] > 0) {
            dispatch_async(self.handlerQueue, ^{
                [weakSelf.onProxyClosedHandlers enumerateObjectsUsingBlock:^(eventHandler hand, BOOL *stop) {
                    hand();
                }];
            });
        }
        [self startProxy];
    }
}

- (void)onHMIStatus:(SDLOnHMIStatus *)notification {
    // Already background dispatched from caller
    @autoreleasepool {
        __weak typeof(self) weakSelf = self;
        [SDLDebugTool logInfo:@"onOnHMIStatus"];
        if (notification.hmiLevel == [SDLHMILevel FULL])
        {
            BOOL occurred = NO;
            @synchronized(self.hmiStateLock) {
                occurred = self.firstHMINotNoneOccurred;
            }
            if (!occurred)
            {
                if ([self.firstHMINotNoneHandlers count] > 0) {
                    dispatch_async(self.handlerQueue, ^{
                        [weakSelf.firstHMINotNoneHandlers enumerateObjectsUsingBlock:^(eventHandler hand, BOOL *stop) {
                            hand();
                        }];
                    });
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
                if ([self.firstHMIFullHandlers count] > 0) {
                    dispatch_async(self.handlerQueue, ^{
                        [weakSelf.firstHMIFullHandlers enumerateObjectsUsingBlock:^(eventHandler hand, BOOL *stop) {
                            hand();
                        }];
                    });
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
                if ([self.firstHMINotNoneHandlers count] > 0) {
                    dispatch_async(self.handlerQueue, ^{
                        [weakSelf.firstHMINotNoneHandlers enumerateObjectsUsingBlock:^(eventHandler hand, BOOL *stop) {
                            hand();
                        }];
                    });
                }
            }
            @synchronized(self.hmiStateLock) {
                self.firstHMINotNoneOccurred = YES;
            }
        }
        if ([self.onOnHMIStatusHandlers count] > 0) {
            dispatch_async(self.handlerQueue, ^{
                [weakSelf.onOnHMIStatusHandlers enumerateObjectsUsingBlock:^(rpcNotificationHandler hand, BOOL *stop) {
                    hand(notification);
                }];
            });
        }
    }
}

- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.backgroundQueue, ^{
        @autoreleasepool {
            // Add a correlation ID
            SDLRPCRequest *rpcWithCorrID = putFileRPCRequest;
            NSNumber *corrID = [weakSelf getNextCorrelationId];
            rpcWithCorrID.correlationID = corrID;
            
            @synchronized(weakSelf.proxyLock) {
                [weakSelf.proxy putFileStream:inputStream withRequest:(SDLPutFile *)rpcWithCorrID];
            }
        }
    });
}

@end
