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

// Proxy notification and event delegates
@property (nonatomic, strong) NSMutableSet *onProxyOpenedDelegates;
@property (nonatomic, strong) NSMutableSet *onProxyClosedDelegates;
@property (nonatomic, strong) NSMutableSet *firstHMIFullDelegates;
@property (nonatomic, strong) NSMutableSet *firstHMINotNoneDelegates;
@property (nonatomic, strong) NSMutableSet *proxyErrorDelegates;
@property (nonatomic, strong) NSMutableSet *appRegisteredDelegates;

// These delegates are required for the app to implement
@property (nonatomic, strong) NSMutableSet *onOnLockScreenNotificationDelegates;
@property (nonatomic, strong) NSMutableSet *onOnLanguageChangeDelegates;
@property (nonatomic, strong) NSMutableSet *onOnPermissionsChangeDelegates;

// Optional delegates
@property (nonatomic, strong) NSMutableSet *onOnDriverDistractionDelegates;
@property (nonatomic, strong) NSMutableSet *onOnHMIStatusDelegates;
@property (nonatomic, strong) NSMutableSet *onOnAppInterfaceUnregisteredDelegates;
@property (nonatomic, strong) NSMutableSet *onOnAudioPassThruDelegates;
@property (nonatomic, strong) NSMutableSet *onOnButtonEventDelegates;
@property (nonatomic, strong) NSMutableSet *onOnButtonPressDelegates;
@property (nonatomic, strong) NSMutableSet *onOnCommandDelegates;
@property (nonatomic, strong) NSMutableSet *onOnEncodedSyncPDataDelegates;
@property (nonatomic, strong) NSMutableSet *onOnHashChangeDelegates;
@property (nonatomic, strong) NSMutableSet *onOnSyncPDataDelegates;
@property (nonatomic, strong) NSMutableSet *onOnSystemRequestDelegates;
@property (nonatomic, strong) NSMutableSet *onOnTBTClientStateDelegates;
@property (nonatomic, strong) NSMutableSet *onOnTouchEventDelegates;
@property (nonatomic, strong) NSMutableSet *onOnVehicleDataDelegates;

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
        _handlerQueue = dispatch_queue_create("com.sdl.proxy_base.handler_queue", DISPATCH_QUEUE_SERIAL);
        _backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //_mainUIQueue = dispatch_get_main_queue();
        _firstHMIFullOccurred = NO;
        _firstHMINotNoneOccurred = NO;
        _rpcResponseHandlerDictionary = [[NSMutableDictionary alloc] init];
        _commandHandlerDictionary = [[NSMutableDictionary alloc] init];
        _buttonHandlerDictionary = [[NSMutableDictionary alloc] init];
        _customButtonHandlerDictionary = [[NSMutableDictionary alloc] init];
        
        _onProxyOpenedDelegates = [[NSMutableSet alloc] init];
        _onProxyClosedDelegates = [[NSMutableSet alloc] init];
        _firstHMIFullDelegates = [[NSMutableSet alloc] init];
        _firstHMINotNoneDelegates = [[NSMutableSet alloc] init];
        _proxyErrorDelegates = [[NSMutableSet alloc] init];
        _appRegisteredDelegates = [[NSMutableSet alloc] init];
        _onOnLockScreenNotificationDelegates = [[NSMutableSet alloc] init];
        _onOnLanguageChangeDelegates = [[NSMutableSet alloc] init];
        _onOnPermissionsChangeDelegates = [[NSMutableSet alloc] init];
        _onOnDriverDistractionDelegates = [[NSMutableSet alloc] init];
        _onOnHMIStatusDelegates = [[NSMutableSet alloc] init];
        _onOnAppInterfaceUnregisteredDelegates = [[NSMutableSet alloc] init];
        _onOnAudioPassThruDelegates = [[NSMutableSet alloc] init];
        _onOnButtonEventDelegates = [[NSMutableSet alloc] init];
        _onOnButtonPressDelegates = [[NSMutableSet alloc] init];
        _onOnCommandDelegates = [[NSMutableSet alloc] init];
        _onOnEncodedSyncPDataDelegates = [[NSMutableSet alloc] init];
        _onOnHashChangeDelegates = [[NSMutableSet alloc] init];
        _onOnSyncPDataDelegates = [[NSMutableSet alloc] init];
        _onOnSystemRequestDelegates = [[NSMutableSet alloc] init];
        _onOnTBTClientStateDelegates = [[NSMutableSet alloc] init];
        _onOnTouchEventDelegates = [[NSMutableSet alloc] init];
        _onOnVehicleDataDelegates = [[NSMutableSet alloc] init];
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

- (void)addDelegate:(id<NSObject>)delegate toSet:(NSMutableSet *)set {
    if (delegate) {
        dispatch_barrier_async(self.handlerQueue, ^{
            [set addObject:delegate];
        });
    }
}

- (void)addOnProxyOpenedDelegate:(id<SDLProxyOpenedDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onProxyOpenedDelegates];
}

- (void)addOnProxyClosedDelegate:(id<SDLProxyClosedDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onProxyClosedDelegates];
}

- (void)addProxyErrorDelegate:(id<SDLProxyErrorDelegate>)delegate {
    [self addDelegate:delegate toSet:self.proxyErrorDelegates];
}

- (void)addAppRegisteredDelegate:(id<SDLAppRegisteredDelegate>)delegate {
    [self addDelegate:delegate toSet:self.appRegisteredDelegates];
}

- (void)addFirstHMIFullDelegate:(id<SDLFirstHMIFullDelegate>)delegate {
    [self addDelegate:delegate toSet:self.firstHMIFullDelegates];
}

- (void)addFirstHMINotNoneDelegate:(id<SDLFirstHMINotNoneDelegate>)delegate {
    [self addDelegate:delegate toSet:self.firstHMINotNoneDelegates];
}

- (void)addOnOnLockScreenNotificationDelegate:(id<SDLOnLockScreenNotificationDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onOnLockScreenNotificationDelegates];
}

- (void)addOnOnLanguageChangeDelegate:(id<SDLOnLanguageChangeDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onOnLanguageChangeDelegates];
}

- (void)addOnOnPermissionsChangeDelegate:(id<SDLOnPermissionsChangeDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onOnPermissionsChangeDelegates];
}

- (void)addOnOnDriverDistractionDelegate:(id<SDLOnDriverDistractionDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onOnDriverDistractionDelegates];
}

- (void)addOnOnHMIStatusDelegate:(id<SDLOnHMIStatusDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onOnHMIStatusDelegates];
}

- (void)addOnOnAppInterfaceUnregisteredDelegate:(id<SDLAppUnregisteredDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onOnAppInterfaceUnregisteredDelegates];
}

- (void)addOnOnAudioPassThruDelegate:(id<SDLOnAudioPassThruDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onOnAudioPassThruDelegates];
}

- (void)addOnOnButtonEventDelegate:(id<SDLOnButtonEventDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onOnButtonEventDelegates];
}

- (void)addOnOnButtonPressDelegate:(id<SDLOnButtonPressDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onOnButtonPressDelegates];
}

- (void)addOnOnCommandDelegate:(id<SDLOnCommandDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onOnCommandDelegates];
}

- (void)addOnOnEncodedSyncPDataDelegate:(id<SDLOnEncodedSyncPDataDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onOnEncodedSyncPDataDelegates];
}

- (void)addOnOnHashChangeDelegate:(id<SDLOnHashChangeDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onOnHashChangeDelegates];
}

- (void)addOnOnSyncPDataDelegate:(id<SDLOnSyncPDataDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onOnSyncPDataDelegates];
}

- (void)addOnOnSystemRequestDelegate:(id<SDLOnSystemRequestDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onOnSystemRequestDelegates];
}

- (void)addOnOnTBTClientStateDelegate:(id<SDLOnTBTClientStateDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onOnTBTClientStateDelegates];
}

- (void)addOnOnTouchEventDelegate:(id<SDLOnTouchEventDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onOnTouchEventDelegates];
}

- (void)addOnOnVehicleDataDelegate:(id<SDLOnVehicleDataDelegate>)delegate {
    [self addDelegate:delegate toSet:self.onOnVehicleDataDelegates];
}


- (void)notifyDelegatesOfEvent:(enum SDLEvent)sdlEvent error:(NSException *)error {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.backgroundQueue, ^{
        typeof(self) strongSelf = weakSelf;
        if (sdlEvent == OnError) {
            strongSelf.proxyError = error;
            [strongSelf onError:strongSelf.proxyError];
        }
        else if (sdlEvent == ProxyClosed) {
            [strongSelf onProxyClosed];
        }
        else if (sdlEvent == ProxyOpened) {
            [strongSelf onProxyOpened];
        }
    });
}

- (void)notifyDelegatesOfNotification:(SDLRPCNotification *)notification {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.backgroundQueue, ^{
        @autoreleasepool {
            typeof(self) strongSelf = weakSelf;
            NSMutableSet *delegateSet = nil;
            void (^enumerationBlock)(id<NSObject> delegate, BOOL *stop) = nil;
            
            if ([notification isKindOfClass:[SDLOnHMIStatus class]]) {
                [strongSelf onHMIStatus:((SDLOnHMIStatus *)notification)];
            }
            else if ([notification isKindOfClass:[SDLOnCommand class]]) {
                [strongSelf runHandlerForCommand:((SDLOnCommand *)notification)];
            }
            else if ([notification isKindOfClass:[SDLOnButtonPress class]]) {
                [strongSelf runHandlerForButton:((SDLRPCNotification *)notification)];
            }
            else if ([notification isKindOfClass:[SDLOnDriverDistraction class]]) {
                delegateSet = strongSelf.onOnDriverDistractionDelegates;
                enumerationBlock = ^(id<NSObject> delegate, BOOL *stop) {
                    [((id<SDLOnDriverDistractionDelegate>)delegate) onSDLDriverDistraction:((SDLOnDriverDistraction *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnAppInterfaceUnregistered class]]) {
                delegateSet = strongSelf.onOnAppInterfaceUnregisteredDelegates;
                enumerationBlock = ^(id<NSObject> delegate, BOOL *stop) {
                    [((id<SDLAppUnregisteredDelegate>)delegate) onSDLAppInterfaceUnregistered:((SDLOnAppInterfaceUnregistered *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnAudioPassThru class]]) {
                delegateSet = strongSelf.onOnAudioPassThruDelegates;
                enumerationBlock = ^(id<NSObject> delegate, BOOL *stop) {
                    [((id<SDLOnAudioPassThruDelegate>)delegate) onSDLAudioPassThru:((SDLOnAudioPassThru *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnEncodedSyncPData class]]) {
                delegateSet = strongSelf.onOnEncodedSyncPDataDelegates;
                enumerationBlock = ^(id<NSObject> delegate, BOOL *stop) {
                    [((id<SDLOnEncodedSyncPDataDelegate>)delegate) onSDLEncodedSyncPData:((SDLOnEncodedSyncPData *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnHashChange class]]) {
                delegateSet = strongSelf.onOnHashChangeDelegates;
                enumerationBlock = ^(id<NSObject> delegate, BOOL *stop) {
                    [((id<SDLOnHashChangeDelegate>)delegate) onSDLHashChange:((SDLOnHashChange *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnLanguageChange class]]) {
                delegateSet = strongSelf.onOnLanguageChangeDelegates;
                enumerationBlock = ^(id<NSObject> delegate, BOOL *stop) {
                    [((id<SDLOnLanguageChangeDelegate>)delegate) onSDLLanguageChange:((SDLOnLanguageChange *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnPermissionsChange class]]) {
                delegateSet = strongSelf.onOnPermissionsChangeDelegates;
                enumerationBlock = ^(id<NSObject> delegate, BOOL *stop) {
                    [((id<SDLOnPermissionsChangeDelegate>)delegate) onSDLPermissionsChange:((SDLOnPermissionsChange *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnSyncPData class]]) {
                delegateSet = strongSelf.onOnSyncPDataDelegates;
                enumerationBlock = ^(id<NSObject> delegate, BOOL *stop) {
                    [((id<SDLOnSyncPDataDelegate>)delegate) onSDLSyncPData:((SDLOnSyncPData *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnSystemRequest class]]) {
                delegateSet = strongSelf.onOnSystemRequestDelegates;
                enumerationBlock = ^(id<NSObject> delegate, BOOL *stop) {
                    [((id<SDLOnSystemRequestDelegate>)delegate) onSDLSystemRequest:((SDLOnSystemRequest *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnTBTClientState class]]) {
                delegateSet = strongSelf.onOnTBTClientStateDelegates;
                enumerationBlock = ^(id<NSObject> delegate, BOOL *stop) {
                    [((id<SDLOnTBTClientStateDelegate>)delegate) onSDLTBTClientState:((SDLOnTBTClientState *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnTouchEvent class]]) {
                delegateSet = strongSelf.onOnTouchEventDelegates;
                enumerationBlock = ^(id<NSObject> delegate, BOOL *stop) {
                    [((id<SDLOnTouchEventDelegate>)delegate) onSDLTouchEvent:((SDLOnTouchEvent *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnVehicleData class]]) {
                delegateSet = strongSelf.onOnVehicleDataDelegates;
                enumerationBlock = ^(id<NSObject> delegate, BOOL *stop) {
                    [((id<SDLOnVehicleDataDelegate>)delegate) onSDLVehicleData:((SDLOnVehicleData *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnLockScreenStatus class]]) {
                delegateSet = strongSelf.onOnLockScreenNotificationDelegates;
                enumerationBlock = ^(id<NSObject> delegate, BOOL *stop) {
                    [((id<SDLOnLockScreenNotificationDelegate>)delegate) onSDLLockScreenNotification:((SDLOnLockScreenStatus *)notification)];
                };
            }
            
            if (delegateSet && enumerationBlock) {
                dispatch_async(strongSelf.handlerQueue, ^{
                    [delegateSet enumerateObjectsUsingBlock:enumerationBlock];
                });
            }
        }
    });
}

- (void)runHandlersForResponse:(SDLRPCResponse *)response {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.backgroundQueue, ^{
        @autoreleasepool {
            typeof(self) strongSelf = weakSelf;
            @synchronized(strongSelf.rpcResponseHandlerDictionaryLock) {
                rpcResponseHandler handler = [strongSelf.rpcResponseHandlerDictionary objectForKey:response.correlationID];
                [strongSelf.rpcResponseHandlerDictionary removeObjectForKey:response.correlationID];
                if (handler) {
                    dispatch_async(strongSelf.handlerQueue, ^{
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
        if ([self.onOnCommandDelegates count] > 0) {
            dispatch_async(self.handlerQueue, ^{
                typeof(self) strongSelf = weakSelf;
                [strongSelf.onOnCommandDelegates enumerateObjectsUsingBlock:^(id<SDLOnCommandDelegate> delegate, BOOL *stop) {
                    [delegate onSDLCommand:command];
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
        if ([notification isKindOfClass:[SDLOnButtonEvent class]] && [self.onOnButtonEventDelegates count] > 0) {
            dispatch_async(self.handlerQueue, ^{
                typeof(self) strongSelf = weakSelf;
                [strongSelf.onOnButtonEventDelegates enumerateObjectsUsingBlock:^(id<SDLOnButtonEventDelegate> delegate, BOOL *stop) {
                    [delegate onSDLButtonEvent:((SDLOnButtonEvent *)notification)];
                }];
            });
        }
        else if ([notification isKindOfClass:[SDLOnButtonPress class]] && [self.onOnButtonPressDelegates count] > 0) {
            dispatch_async(self.handlerQueue, ^{
                typeof(self) strongSelf = weakSelf;
                [strongSelf.onOnButtonPressDelegates enumerateObjectsUsingBlock:^(id<SDLOnButtonPressDelegate> delegate, BOOL *stop) {
                    [delegate onSDLButtonPress:((SDLOnButtonPress *)notification)];
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
                typeof(self) strongSelf = weakSelf;
                // Add a correlation ID
                SDLRPCRequest *rpcWithCorrID = rpc;
                NSNumber *corrID = [strongSelf getNextCorrelationId];
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
                            @synchronized(strongSelf.customButtonHandlerDictionaryLock) {
                                strongSelf.customButtonHandlerDictionary[sb.softButtonID] = ((SDLSoftButtonWithHandler *)sb).onButtonHandler;
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
                    @synchronized(strongSelf.commandHandlerDictionaryLock) {
                        strongSelf.commandHandlerDictionary[((SDLAddCommandWithHandler *)rpcWithCorrID).cmdID] = ((SDLAddCommandWithHandler *)rpcWithCorrID).onCommandHandler;
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
                    @synchronized(strongSelf.buttonHandlerDictionaryLock) {
                        strongSelf.buttonHandlerDictionary[buttonName] = ((SDLSubscribeButtonWithHandler *)rpcWithCorrID).onButtonHandler;
                    }
                }
                
                if (responseHandler) {
                    @synchronized(strongSelf.rpcResponseHandlerDictionaryLock) {
                        strongSelf.rpcResponseHandlerDictionary[corrID] = responseHandler;
                    }
                }
                @synchronized(strongSelf.proxyLock) {
                    [strongSelf.proxy sendRPC:rpcWithCorrID];
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
            typeof(self) strongSelf = weakSelf;
            if (appName && appID && languageDesired && [self.onOnLockScreenNotificationDelegates count] > 0 && [self.onOnLanguageChangeDelegates count] > 0 && [self.onOnPermissionsChangeDelegates count] > 0)
            {
                [SDLDebugTool logInfo:@"Start Proxy"];
                strongSelf.appName = appName;
                strongSelf.appID = appID;
                strongSelf.isMedia = isMedia;
                strongSelf.languageDesired = languageDesired;
                SDLProxyListenerBase *listener = [[SDLProxyListenerBase alloc] initWithProxyBase:strongSelf];
                @synchronized(self.proxyLock) {
                    [SDLProxy enableSiphonDebug];
                    strongSelf.proxy = [SDLProxyFactory buildSDLProxyWithListener:listener];
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
        typeof(self) strongSelf = weakSelf;
        [strongSelf disposeProxy];
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
        if ([self.proxyErrorDelegates count] > 0) {
            dispatch_async(self.handlerQueue, ^{
                typeof(self) strongSelf = weakSelf;
                [strongSelf.proxyErrorDelegates enumerateObjectsUsingBlock:^(id<SDLProxyErrorDelegate> delegate, BOOL *stop) {
                    [delegate onSDLError:e];
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
            if ([self.appRegisteredDelegates count] > 0) {
                dispatch_async(self.handlerQueue, ^{
                    typeof(self) strongSelf = weakSelf;
                    [strongSelf.appRegisteredDelegates enumerateObjectsUsingBlock:^(id<SDLAppRegisteredDelegate> delegate, BOOL *stop) {
                        [delegate onSDLRegisterAppInterfaceResponse:((SDLRegisterAppInterfaceResponse *) response)];
                    }];
                });
            }
        }];
        if ([self.onProxyOpenedDelegates count] > 0) {
            dispatch_async(self.handlerQueue, ^{
                typeof(self) strongSelf = weakSelf;
                [strongSelf.onProxyOpenedDelegates enumerateObjectsUsingBlock:^(id<SDLProxyOpenedDelegate> delegate, BOOL *stop) {
                    [delegate onSDLProxyOpened];
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
        if ([self.onProxyClosedDelegates count] > 0) {
            dispatch_async(self.handlerQueue, ^{
                typeof(self) strongSelf = weakSelf;
                [strongSelf.onProxyClosedDelegates enumerateObjectsUsingBlock:^(id<SDLProxyClosedDelegate> delegate, BOOL *stop) {
                    [delegate onSDLProxyClosed];
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
                if ([self.firstHMINotNoneDelegates count] > 0) {
                    dispatch_async(self.handlerQueue, ^{
                        typeof(self) strongSelf = weakSelf;
                        [strongSelf.firstHMINotNoneDelegates enumerateObjectsUsingBlock:^(id<SDLFirstHMINotNoneDelegate> delegate, BOOL *stop) {
                            [delegate onSDLFirstHMINotNone:notification];
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
                if ([self.firstHMIFullDelegates count] > 0) {
                    dispatch_async(self.handlerQueue, ^{
                        typeof(self) strongSelf = weakSelf;
                        [strongSelf.firstHMIFullDelegates enumerateObjectsUsingBlock:^(id<SDLFirstHMIFullDelegate> delegate, BOOL *stop) {
                            [delegate onSDLFirstHMIFull:notification];
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
                if ([self.firstHMINotNoneDelegates count] > 0) {
                    dispatch_async(self.handlerQueue, ^{
                        typeof(self) strongSelf = weakSelf;
                        [strongSelf.firstHMINotNoneDelegates enumerateObjectsUsingBlock:^(id<SDLFirstHMINotNoneDelegate> delegate, BOOL *stop) {
                            [delegate onSDLFirstHMINotNone:notification];
                        }];
                    });
                }
            }
            @synchronized(self.hmiStateLock) {
                self.firstHMINotNoneOccurred = YES;
            }
        }
        if ([self.onOnHMIStatusDelegates count] > 0) {
            dispatch_async(self.handlerQueue, ^{
                typeof(self) strongSelf = weakSelf;
                [strongSelf.onOnHMIStatusDelegates enumerateObjectsUsingBlock:^(id<SDLOnHMIStatusDelegate> delegate, BOOL *stop) {
                    [delegate onSDLHMIStatus:notification];
                }];
            });
        }
    }
}

- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.backgroundQueue, ^{
        @autoreleasepool {
            typeof(self) strongSelf = weakSelf;
            // Add a correlation ID
            SDLRPCRequest *rpcWithCorrID = putFileRPCRequest;
            NSNumber *corrID = [strongSelf getNextCorrelationId];
            rpcWithCorrID.correlationID = corrID;
            
            @synchronized(strongSelf.proxyLock) {
                [strongSelf.proxy putFileStream:inputStream withRequest:(SDLPutFile *)rpcWithCorrID];
            }
        }
    });
}

@end
