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

// GCD
@property (strong, nonatomic) dispatch_queue_t backgroundQueue;
@property (strong, nonatomic) dispatch_queue_t mainUIQueue;
@property (strong, nonatomic) NSObject *delegateLock;
@property (strong, nonatomic) NSObject *proxyLock;
@property (strong, nonatomic) NSObject *correlationIdLock;
@property (strong, nonatomic) NSObject *hmiStateLock;
@property (strong, nonatomic) NSObject *rpcResponseHandlerMapLock;
@property (strong, nonatomic) NSObject *commandHandlerMapLock;
@property (strong, nonatomic) NSObject *buttonHandlerMapLock;
@property (strong, nonatomic) NSObject *customButtonHandlerMapLock;

// SDL state
@property (strong, nonatomic) SDLProxy *proxy;
@property (assign, nonatomic) int correlationID;
@property (assign, nonatomic) BOOL firstHMIFullOccurred;
@property (assign, nonatomic) BOOL firstHMINotNoneOccurred;
@property (assign, getter=isConnected) BOOL connected;

// These delegates are required for the app to implement
// TODO: should these be required?
@property (strong) NSHashTable *onOnLockScreenNotificationDelegates;
@property (strong) NSHashTable *onOnLanguageChangeDelegates;
@property (strong) NSHashTable *onOnPermissionsChangeDelegates;

// Proxy notification and event delegates
@property (strong) NSHashTable *onProxyOpenedDelegates;
@property (strong) NSHashTable *onProxyClosedDelegates;
@property (strong) NSHashTable *firstHMIFullDelegates;
@property (strong) NSHashTable *firstHMINotNoneDelegates;
@property (strong) NSHashTable *proxyErrorDelegates;
@property (strong) NSHashTable *appRegisteredDelegates;

// Optional delegates
@property (strong) NSHashTable *onOnDriverDistractionDelegates;
@property (strong) NSHashTable *onOnHMIStatusDelegates;
@property (strong) NSHashTable *onOnAppInterfaceUnregisteredDelegates;
@property (strong) NSHashTable *onOnAudioPassThruDelegates;
@property (strong) NSHashTable *onOnButtonEventDelegates;
@property (strong) NSHashTable *onOnButtonPressDelegates;
@property (strong) NSHashTable *onOnCommandDelegates;
@property (strong) NSHashTable *onOnEncodedSyncPDataDelegates;
@property (strong) NSHashTable *onOnHashChangeDelegates;
@property (strong) NSHashTable *onOnSyncPDataDelegates;
@property (strong) NSHashTable *onOnSystemRequestDelegates;
@property (strong) NSHashTable *onOnTBTClientStateDelegates;
@property (strong) NSHashTable *onOnTouchEventDelegates;
@property (strong) NSHashTable *onOnVehicleDataDelegates;

// Dictionaries to link handlers with requests/commands/etc
@property (strong, nonatomic) NSMapTable *rpcResponseHandlerMap;
@property (strong, nonatomic) NSMapTable *commandHandlerMap;
@property (strong, nonatomic) NSMapTable *buttonHandlerMap;
@property (strong, nonatomic) NSMapTable *customButtonHandlerMap;

@end

@implementation SDLProxyBase


#pragma mark Lifecycle

- (id)init {
    self = [super init];
    if (self) {
        _delegateLock = [[NSObject alloc] init];
        _proxyLock = [[NSObject alloc] init];
        _correlationIdLock = [[NSObject alloc] init];
        _hmiStateLock = [[NSObject alloc] init];
        _rpcResponseHandlerMapLock = [[NSObject alloc] init];
        _commandHandlerMapLock = [[NSObject alloc] init];
        _buttonHandlerMapLock = [[NSObject alloc] init];
        _customButtonHandlerMapLock = [[NSObject alloc] init];
        _correlationID = 1;
        _connected = NO;
        _backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _mainUIQueue = dispatch_get_main_queue();
        _firstHMIFullOccurred = NO;
        _firstHMINotNoneOccurred = NO;
        _rpcResponseHandlerMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];
        _commandHandlerMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];
        _buttonHandlerMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];
        _customButtonHandlerMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];
        
        _onProxyOpenedDelegates = [NSHashTable weakObjectsHashTable];
        _onProxyClosedDelegates = [NSHashTable weakObjectsHashTable];
        _firstHMIFullDelegates = [NSHashTable weakObjectsHashTable];
        _firstHMINotNoneDelegates = [NSHashTable weakObjectsHashTable];
        _proxyErrorDelegates = [NSHashTable weakObjectsHashTable];
        _appRegisteredDelegates = [NSHashTable weakObjectsHashTable];
        _onOnLockScreenNotificationDelegates = [NSHashTable weakObjectsHashTable];
        _onOnLanguageChangeDelegates = [NSHashTable weakObjectsHashTable];
        _onOnPermissionsChangeDelegates = [NSHashTable weakObjectsHashTable];
        _onOnDriverDistractionDelegates = [NSHashTable weakObjectsHashTable];
        _onOnHMIStatusDelegates = [NSHashTable weakObjectsHashTable];
        _onOnAppInterfaceUnregisteredDelegates = [NSHashTable weakObjectsHashTable];
        _onOnAudioPassThruDelegates = [NSHashTable weakObjectsHashTable];
        _onOnButtonEventDelegates = [NSHashTable weakObjectsHashTable];
        _onOnButtonPressDelegates = [NSHashTable weakObjectsHashTable];
        _onOnCommandDelegates = [NSHashTable weakObjectsHashTable];
        _onOnEncodedSyncPDataDelegates = [NSHashTable weakObjectsHashTable];
        _onOnHashChangeDelegates = [NSHashTable weakObjectsHashTable];
        _onOnSyncPDataDelegates = [NSHashTable weakObjectsHashTable];
        _onOnSystemRequestDelegates = [NSHashTable weakObjectsHashTable];
        _onOnTBTClientStateDelegates = [NSHashTable weakObjectsHashTable];
        _onOnTouchEventDelegates = [NSHashTable weakObjectsHashTable];
        _onOnVehicleDataDelegates = [NSHashTable weakObjectsHashTable];
    }
    return self;
}


#pragma mark Exceptions

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


#pragma mark Delegates

- (void)addDelegate:(id<NSObject>)delegate toHashTable:(NSHashTable *)table {
    if (delegate && table) {
        @synchronized (self.delegateLock) {
            [table addObject:delegate];
        }
    }
}

- (void)addOnProxyOpenedDelegate:(id<SDLProxyOpenedDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onProxyOpenedDelegates];
}

- (void)addOnProxyClosedDelegate:(id<SDLProxyClosedDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onProxyClosedDelegates];
}

- (void)addProxyErrorDelegate:(id<SDLProxyErrorDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.proxyErrorDelegates];
}

- (void)addAppRegisteredDelegate:(id<SDLAppRegisteredDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.appRegisteredDelegates];
}

- (void)addFirstHMIFullDelegate:(id<SDLFirstHMIFullDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.firstHMIFullDelegates];
}

- (void)addFirstHMINotNoneDelegate:(id<SDLFirstHMINotNoneDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.firstHMINotNoneDelegates];
}

- (void)addOnOnLockScreenNotificationDelegate:(id<SDLOnLockScreenNotificationDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onOnLockScreenNotificationDelegates];
}

- (void)addOnOnLanguageChangeDelegate:(id<SDLOnLanguageChangeDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onOnLanguageChangeDelegates];
}

- (void)addOnOnPermissionsChangeDelegate:(id<SDLOnPermissionsChangeDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onOnPermissionsChangeDelegates];
}

- (void)addOnOnDriverDistractionDelegate:(id<SDLOnDriverDistractionDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onOnDriverDistractionDelegates];
}

- (void)addOnOnHMIStatusDelegate:(id<SDLOnHMIStatusDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onOnHMIStatusDelegates];
}

- (void)addOnOnAppInterfaceUnregisteredDelegate:(id<SDLAppUnregisteredDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onOnAppInterfaceUnregisteredDelegates];
}

- (void)addOnOnAudioPassThruDelegate:(id<SDLOnAudioPassThruDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onOnAudioPassThruDelegates];
}

- (void)addOnOnButtonEventDelegate:(id<SDLOnButtonEventDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onOnButtonEventDelegates];
}

- (void)addOnOnButtonPressDelegate:(id<SDLOnButtonPressDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onOnButtonPressDelegates];
}

- (void)addOnOnCommandDelegate:(id<SDLOnCommandDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onOnCommandDelegates];
}

- (void)addOnOnEncodedSyncPDataDelegate:(id<SDLOnEncodedSyncPDataDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onOnEncodedSyncPDataDelegates];
}

- (void)addOnOnHashChangeDelegate:(id<SDLOnHashChangeDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onOnHashChangeDelegates];
}

- (void)addOnOnSyncPDataDelegate:(id<SDLOnSyncPDataDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onOnSyncPDataDelegates];
}

- (void)addOnOnSystemRequestDelegate:(id<SDLOnSystemRequestDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onOnSystemRequestDelegates];
}

- (void)addOnOnTBTClientStateDelegate:(id<SDLOnTBTClientStateDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onOnTBTClientStateDelegates];
}

- (void)addOnOnTouchEventDelegate:(id<SDLOnTouchEventDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onOnTouchEventDelegates];
}

- (void)addOnOnVehicleDataDelegate:(id<SDLOnVehicleDataDelegate>)delegate {
    [self addDelegate:delegate toHashTable:self.onOnVehicleDataDelegates];
}

#pragma mark 

- (void)notifyDelegatesOfEvent:(enum SDLEvent)sdlEvent error:(NSException *)error {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.backgroundQueue, ^{
        typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (sdlEvent == OnError) {
                [strongSelf onError:error];
            }
            else if (sdlEvent == ProxyClosed) {
                [strongSelf onProxyClosed];
            }
            else if (sdlEvent == ProxyOpened) {
                [strongSelf onProxyOpened];
            }
        }
    });
}

- (void)notifyDelegatesOfNotification:(SDLRPCNotification *)notification {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.backgroundQueue, ^{
        typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            NSHashTable *delegateHashTable = nil;
            void (^enumerationBlock)(id<NSObject> delegate) = nil;
            
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
                delegateHashTable = strongSelf.onOnDriverDistractionDelegates;
                enumerationBlock = ^(id<NSObject> delegate) {
                    [((id<SDLOnDriverDistractionDelegate>)delegate) onSDLDriverDistraction:((SDLOnDriverDistraction *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnAppInterfaceUnregistered class]]) {
                delegateHashTable = strongSelf.onOnAppInterfaceUnregisteredDelegates;
                enumerationBlock = ^(id<NSObject> delegate) {
                    [((id<SDLAppUnregisteredDelegate>)delegate) onSDLAppInterfaceUnregistered:((SDLOnAppInterfaceUnregistered *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnAudioPassThru class]]) {
                delegateHashTable = strongSelf.onOnAudioPassThruDelegates;
                enumerationBlock = ^(id<NSObject> delegate) {
                    [((id<SDLOnAudioPassThruDelegate>)delegate) onSDLAudioPassThru:((SDLOnAudioPassThru *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnEncodedSyncPData class]]) {
                delegateHashTable = strongSelf.onOnEncodedSyncPDataDelegates;
                enumerationBlock = ^(id<NSObject> delegate) {
                    [((id<SDLOnEncodedSyncPDataDelegate>)delegate) onSDLEncodedSyncPData:((SDLOnEncodedSyncPData *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnHashChange class]]) {
                delegateHashTable = strongSelf.onOnHashChangeDelegates;
                enumerationBlock = ^(id<NSObject> delegate) {
                    [((id<SDLOnHashChangeDelegate>)delegate) onSDLHashChange:((SDLOnHashChange *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnLanguageChange class]]) {
                delegateHashTable = strongSelf.onOnLanguageChangeDelegates;
                enumerationBlock = ^(id<NSObject> delegate) {
                    [((id<SDLOnLanguageChangeDelegate>)delegate) onSDLLanguageChange:((SDLOnLanguageChange *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnPermissionsChange class]]) {
                delegateHashTable = strongSelf.onOnPermissionsChangeDelegates;
                enumerationBlock = ^(id<NSObject> delegate) {
                    [((id<SDLOnPermissionsChangeDelegate>)delegate) onSDLPermissionsChange:((SDLOnPermissionsChange *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnSyncPData class]]) {
                delegateHashTable = strongSelf.onOnSyncPDataDelegates;
                enumerationBlock = ^(id<NSObject> delegate) {
                    [((id<SDLOnSyncPDataDelegate>)delegate) onSDLSyncPData:((SDLOnSyncPData *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnSystemRequest class]]) {
                delegateHashTable = strongSelf.onOnSystemRequestDelegates;
                enumerationBlock = ^(id<NSObject> delegate) {
                    [((id<SDLOnSystemRequestDelegate>)delegate) onSDLSystemRequest:((SDLOnSystemRequest *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnTBTClientState class]]) {
                delegateHashTable = strongSelf.onOnTBTClientStateDelegates;
                enumerationBlock = ^(id<NSObject> delegate) {
                    [((id<SDLOnTBTClientStateDelegate>)delegate) onSDLTBTClientState:((SDLOnTBTClientState *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnTouchEvent class]]) {
                delegateHashTable = strongSelf.onOnTouchEventDelegates;
                enumerationBlock = ^(id<NSObject> delegate) {
                    [((id<SDLOnTouchEventDelegate>)delegate) onSDLTouchEvent:((SDLOnTouchEvent *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnVehicleData class]]) {
                delegateHashTable = strongSelf.onOnVehicleDataDelegates;
                enumerationBlock = ^(id<NSObject> delegate) {
                    [((id<SDLOnVehicleDataDelegate>)delegate) onSDLVehicleData:((SDLOnVehicleData *)notification)];
                };
            }
            else if ([notification isKindOfClass:[SDLOnLockScreenStatus class]]) {
                delegateHashTable = strongSelf.onOnLockScreenNotificationDelegates;
                enumerationBlock = ^(id<NSObject> delegate) {
                    [((id<SDLOnLockScreenNotificationDelegate>)delegate) onSDLLockScreenNotification:((SDLOnLockScreenStatus *)notification)];
                };
            }
            
            if (delegateHashTable && enumerationBlock) {
                dispatch_async(strongSelf.mainUIQueue, ^{
                    @synchronized (strongSelf.delegateLock) {
                        for (id<NSObject> delegate in delegateHashTable) {
                            enumerationBlock(delegate);
                        }
                    }
                });
            }
        }
    });
}

- (void)runHandlersForResponse:(SDLRPCResponse *)response {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.backgroundQueue, ^{
        typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            @synchronized(strongSelf.rpcResponseHandlerMapLock) {
                RPCResponseHandler handler = [strongSelf.rpcResponseHandlerMap objectForKey:response.correlationID];
                [strongSelf.rpcResponseHandlerMap removeObjectForKey:response.correlationID];
                if (handler) {
                    dispatch_async(strongSelf.mainUIQueue, ^{
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
    __weak typeof(self) weakSelf = self;
    RPCNotificationHandler handler = nil;
    @synchronized(self.commandHandlerMapLock) {
        handler = [self.commandHandlerMap objectForKey:command.cmdID];
    }
    
    if (handler) {
        dispatch_async(self.mainUIQueue, ^{
            handler(command);
        });
    }
    
    // TODO: Should this even be a thing still?
    if ([self.onOnCommandDelegates count] > 0) {
        dispatch_async(self.mainUIQueue, ^{
            typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                @synchronized (strongSelf.delegateLock) {
                    for (id<SDLOnCommandDelegate> delegate in strongSelf.onOnCommandDelegates) {
                        [delegate onSDLCommand:command];
                    }
                }
            }
        });
    }
}

- (void)runHandlerForButton:(SDLRPCNotification *)notification {
    // Already background dispatched from caller
    __weak typeof(self) weakSelf = self;
    RPCNotificationHandler handler = nil;
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
        @synchronized(self.customButtonHandlerMapLock) {
            handler = [self.customButtonHandlerMap objectForKey:customID];
        }
    }
    else {
        @synchronized(self.buttonHandlerMapLock) {
            handler = [self.buttonHandlerMap objectForKey:name.value];
        }
    }
    
    if (handler) {
        dispatch_async(self.mainUIQueue, ^{
            handler(notification);
        });
    }
    
    // TODO: Should this even be a thing still?
    if ([notification isKindOfClass:[SDLOnButtonEvent class]] && [self.onOnButtonEventDelegates count] > 0) {
        dispatch_async(self.mainUIQueue, ^{
            typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                @synchronized (strongSelf.delegateLock) {
                    for (id<SDLOnButtonEventDelegate> delegate in strongSelf.onOnButtonEventDelegates) {
                        [delegate onSDLButtonEvent:((SDLOnButtonEvent *)notification)];
                    }
                }
            }
        });
    }
    else if ([notification isKindOfClass:[SDLOnButtonPress class]] && [self.onOnButtonPressDelegates count] > 0) {
        dispatch_async(self.mainUIQueue, ^{
            typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                @synchronized (strongSelf.delegateLock) {
                    for (id<SDLOnButtonPressDelegate> delegate in strongSelf.onOnButtonPressDelegates) {
                        [delegate onSDLButtonPress:((SDLOnButtonPress *)notification)];
                    }
                }
            }
        });
    }
}


#pragma mark SDLProxyBase

- (void)sendRPC:(SDLRPCRequest *)rpc responseHandler:(RPCResponseHandler)responseHandler {
    __weak typeof(self) weakSelf = self;
    if (self.isConnected) {
        dispatch_async(self.backgroundQueue, ^{
            typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
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
                            @synchronized(strongSelf.customButtonHandlerMapLock) {
                                [strongSelf.customButtonHandlerMap setObject:((SDLSoftButtonWithHandler *)sb).onButtonHandler forKey:sb.softButtonID];
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
                    @synchronized(strongSelf.commandHandlerMapLock) {
                        [strongSelf.commandHandlerMap setObject:((SDLAddCommandWithHandler *)rpcWithCorrID).onCommandHandler forKey:((SDLAddCommandWithHandler *)rpcWithCorrID).cmdID];
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
                    @synchronized(strongSelf.buttonHandlerMapLock) {
                        [strongSelf.buttonHandlerMap setObject:((SDLSubscribeButtonWithHandler *)rpcWithCorrID).onButtonHandler forKey:buttonName];
                    }
                }
                
                if (responseHandler) {
                    @synchronized(strongSelf.rpcResponseHandlerMapLock) {
                        [strongSelf.rpcResponseHandlerMap setObject:responseHandler forKey:corrID];
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
    dispatch_async(self.backgroundQueue, ^{
        typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (appName && appID && languageDesired && [strongSelf.onOnLockScreenNotificationDelegates count] > 0 && [strongSelf.onOnLanguageChangeDelegates count] > 0 && [strongSelf.onOnPermissionsChangeDelegates count] > 0)
            {
                [SDLDebugTool logInfo:@"Start Proxy"];
                strongSelf.appName = appName;
                strongSelf.appID = appID;
                strongSelf.isMedia = isMedia;
                strongSelf.languageDesired = languageDesired;
                SDLProxyListenerBase *listener = [[SDLProxyListenerBase alloc] initWithProxyBase:strongSelf];
                @synchronized(strongSelf.proxyLock) {
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
        if (strongSelf) {
            [strongSelf disposeProxy];
        }
    });
}

- (void)disposeProxy {
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

- (NSNumber *)getNextCorrelationId {
    NSNumber *corrId = nil;
    @synchronized(self.correlationIdLock) {
        self.correlationID++;
        corrId = [NSNumber numberWithInt:self.correlationID];
    }
    return corrId;
}

- (void)onError:(NSException *)e {
    // Already background dispatched from caller
    __weak typeof(self) weakSelf = self;
    if ([self.proxyErrorDelegates count] > 0) {
        dispatch_async(self.mainUIQueue, ^{
            typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                @synchronized (strongSelf.delegateLock) {
                    for (id<SDLProxyErrorDelegate> delegate in strongSelf.proxyErrorDelegates) {
                        [delegate onSDLError:e];
                    }
                }
            }
        });
    }
}

- (void)onProxyOpened {
    // Already background dispatched from caller
    __weak typeof(self) weakSelf = self;
    [SDLDebugTool logInfo:@"onProxyOpened"];
    self.connected = YES;
    @autoreleasepool {
        SDLRegisterAppInterface *regRequest = [SDLRPCRequestFactory buildRegisterAppInterfaceWithAppName:self.appName languageDesired:self.languageDesired appID:self.appID];
        regRequest.isMediaApplication = [NSNumber numberWithBool:self.isMedia];
        regRequest.ngnMediaScreenAppName = self.shortName;
        if (self.vrSynonyms) {
            regRequest.vrSynonyms = [NSMutableArray arrayWithArray:self.vrSynonyms];
        }
        [self sendRPC:regRequest responseHandler:^(SDLRPCResponse *response){
            typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                if ([strongSelf.appRegisteredDelegates count] > 0) {
                    dispatch_async(strongSelf.mainUIQueue, ^{
                        typeof(self) strongSelf = weakSelf;
                        if (strongSelf) {
                            @synchronized (strongSelf.delegateLock) {
                                for (id<SDLAppRegisteredDelegate> delegate in strongSelf.appRegisteredDelegates) {
                                    [delegate onSDLRegisterAppInterfaceResponse:((SDLRegisterAppInterfaceResponse *) response)];
                                }
                            }
                        }
                    });
                }
            }
        }];
    }
    if ([self.onProxyOpenedDelegates count] > 0) {
        dispatch_async(self.mainUIQueue, ^{
            typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                @synchronized (strongSelf.delegateLock) {
                    for (id<SDLProxyOpenedDelegate> delegate in strongSelf.onProxyOpenedDelegates) {
                        [delegate onSDLProxyOpened];
                    }
                }
            }
        });
    }
}

- (void)onProxyClosed {
    // Already background dispatched from caller
    __weak typeof(self) weakSelf = self;
    [SDLDebugTool logInfo:@"onProxyClosed"];
    self.connected = NO;
    [self disposeProxy];    // call this method instead of stopProxy to avoid double-dispatching
    if ([self.onProxyClosedDelegates count] > 0) {
        dispatch_async(self.mainUIQueue, ^{
            typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                @synchronized (strongSelf.delegateLock) {
                    for (id<SDLProxyClosedDelegate> delegate in strongSelf.onProxyClosedDelegates) {
                        [delegate onSDLProxyClosed];
                    }
                }
            }
        });
    }
    [self startProxy];
}

- (void)onHMIStatus:(SDLOnHMIStatus *)notification {
    // Already background dispatched from caller
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
                dispatch_async(self.mainUIQueue, ^{
                    typeof(self) strongSelf = weakSelf;
                    if (strongSelf) {
                        @synchronized (strongSelf.delegateLock) {
                            for (id<SDLFirstHMINotNoneDelegate> delegate in strongSelf.firstHMINotNoneDelegates) {
                                [delegate onSDLFirstHMINotNone:notification];
                            }
                        }
                    }
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
                dispatch_async(self.mainUIQueue, ^{
                    typeof(self) strongSelf = weakSelf;
                    if (strongSelf) {
                        @synchronized (strongSelf.delegateLock) {
                            for (id<SDLFirstHMIFullDelegate> delegate in strongSelf.firstHMIFullDelegates) {
                                [delegate onSDLFirstHMIFull:notification];
                            }
                        }
                    }
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
                dispatch_async(self.mainUIQueue, ^{
                    typeof(self) strongSelf = weakSelf;
                    if (strongSelf) {
                        @synchronized (strongSelf.delegateLock) {
                            for (id<SDLFirstHMINotNoneDelegate> delegate in strongSelf.firstHMINotNoneDelegates) {
                                [delegate onSDLFirstHMINotNone:notification];
                            }
                        }
                    }
                });
            }
        }
        @synchronized(self.hmiStateLock) {
            self.firstHMINotNoneOccurred = YES;
        }
    }
    if ([self.onOnHMIStatusDelegates count] > 0) {
        dispatch_async(self.mainUIQueue, ^{
            typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                @synchronized (strongSelf.delegateLock) {
                    for (id<SDLOnHMIStatusDelegate> delegate in strongSelf.onOnHMIStatusDelegates) {
                        [delegate onSDLHMIStatus:notification];
                    }
                }
            }
        });
    }
}

- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.backgroundQueue, ^{
        typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
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
