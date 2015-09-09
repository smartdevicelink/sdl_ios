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
@property (copy) NSSet *onOnLockScreenNotificationDelegates;
@property (copy) NSSet *onOnLanguageChangeDelegates;
@property (copy) NSSet *onOnPermissionsChangeDelegates;

// Proxy notification and event delegates
@property (copy) NSSet *onProxyOpenedDelegates;
@property (copy) NSSet *onProxyClosedDelegates;
@property (copy) NSSet *firstHMIFullDelegates;
@property (copy) NSSet *firstHMINotNoneDelegates;
@property (copy) NSSet *proxyErrorDelegates;
@property (copy) NSSet *appRegisteredDelegates;

// Optional delegates
@property (copy) NSSet *onOnDriverDistractionDelegates;
@property (copy) NSSet *onOnHMIStatusDelegates;
@property (copy) NSSet *onOnAppInterfaceUnregisteredDelegates;
@property (copy) NSSet *onOnAudioPassThruDelegates;
@property (copy) NSSet *onOnButtonEventDelegates;
@property (copy) NSSet *onOnButtonPressDelegates;
@property (copy) NSSet *onOnCommandDelegates;
@property (copy) NSSet *onOnEncodedSyncPDataDelegates;
@property (copy) NSSet *onOnHashChangeDelegates;
@property (copy) NSSet *onOnSyncPDataDelegates;
@property (copy) NSSet *onOnSystemRequestDelegates;
@property (copy) NSSet *onOnTBTClientStateDelegates;
@property (copy) NSSet *onOnTouchEventDelegates;
@property (copy) NSSet *onOnVehicleDataDelegates;

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
        
        _onProxyOpenedDelegates = [[NSSet alloc] init];
        _onProxyClosedDelegates = [[NSSet alloc] init];
        _firstHMIFullDelegates = [[NSSet alloc] init];
        _firstHMINotNoneDelegates = [[NSSet alloc] init];
        _proxyErrorDelegates = [[NSSet alloc] init];
        _appRegisteredDelegates = [[NSSet alloc] init];
        _onOnLockScreenNotificationDelegates = [[NSSet alloc] init];
        _onOnLanguageChangeDelegates = [[NSSet alloc] init];
        _onOnPermissionsChangeDelegates = [[NSSet alloc] init];
        _onOnDriverDistractionDelegates = [[NSSet alloc] init];
        _onOnHMIStatusDelegates = [[NSSet alloc] init];
        _onOnAppInterfaceUnregisteredDelegates = [[NSSet alloc] init];
        _onOnAudioPassThruDelegates = [[NSSet alloc] init];
        _onOnButtonEventDelegates = [[NSSet alloc] init];
        _onOnButtonPressDelegates = [[NSSet alloc] init];
        _onOnCommandDelegates = [[NSSet alloc] init];
        _onOnEncodedSyncPDataDelegates = [[NSSet alloc] init];
        _onOnHashChangeDelegates = [[NSSet alloc] init];
        _onOnSyncPDataDelegates = [[NSSet alloc] init];
        _onOnSystemRequestDelegates = [[NSSet alloc] init];
        _onOnTBTClientStateDelegates = [[NSSet alloc] init];
        _onOnTouchEventDelegates = [[NSSet alloc] init];
        _onOnVehicleDataDelegates = [[NSSet alloc] init];
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

- (void)addOnProxyOpenedDelegate:(id<SDLProxyOpenedDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onProxyOpenedDelegates = [self.onProxyOpenedDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnProxyClosedDelegate:(id<SDLProxyClosedDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onProxyClosedDelegates = [self.onProxyClosedDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addProxyErrorDelegate:(id<SDLProxyErrorDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.proxyErrorDelegates = [self.proxyErrorDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addAppRegisteredDelegate:(id<SDLAppRegisteredDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.appRegisteredDelegates = [self.appRegisteredDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addFirstHMIFullDelegate:(id<SDLFirstHMIFullDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.firstHMIFullDelegates = [self.firstHMIFullDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addFirstHMINotNoneDelegate:(id<SDLFirstHMINotNoneDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.firstHMINotNoneDelegates = [self.firstHMINotNoneDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnOnLockScreenNotificationDelegate:(id<SDLOnLockScreenNotificationDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onOnLockScreenNotificationDelegates = [self.onOnLockScreenNotificationDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnOnLanguageChangeDelegate:(id<SDLOnLanguageChangeDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onOnLanguageChangeDelegates = [self.onOnLanguageChangeDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnOnPermissionsChangeDelegate:(id<SDLOnPermissionsChangeDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onOnPermissionsChangeDelegates = [self.onOnPermissionsChangeDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnOnDriverDistractionDelegate:(id<SDLOnDriverDistractionDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onOnDriverDistractionDelegates = [self.onOnDriverDistractionDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnOnHMIStatusDelegate:(id<SDLOnHMIStatusDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onOnHMIStatusDelegates = [self.onOnHMIStatusDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnOnAppInterfaceUnregisteredDelegate:(id<SDLAppUnregisteredDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onOnAppInterfaceUnregisteredDelegates = [self.onOnAppInterfaceUnregisteredDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnOnAudioPassThruDelegate:(id<SDLOnAudioPassThruDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onOnAudioPassThruDelegates = [self.onOnAudioPassThruDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnOnButtonEventDelegate:(id<SDLOnButtonEventDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onOnButtonEventDelegates = [self.onOnButtonEventDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnOnButtonPressDelegate:(id<SDLOnButtonPressDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onOnButtonPressDelegates = [self.onOnButtonPressDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnOnCommandDelegate:(id<SDLOnCommandDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onOnCommandDelegates = [self.onOnCommandDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnOnEncodedSyncPDataDelegate:(id<SDLOnEncodedSyncPDataDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onOnEncodedSyncPDataDelegates = [self.onOnEncodedSyncPDataDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnOnHashChangeDelegate:(id<SDLOnHashChangeDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onOnHashChangeDelegates = [self.onOnHashChangeDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnOnSyncPDataDelegate:(id<SDLOnSyncPDataDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onOnSyncPDataDelegates = [self.onOnSyncPDataDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnOnSystemRequestDelegate:(id<SDLOnSystemRequestDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onOnSystemRequestDelegates = [self.onOnSystemRequestDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnOnTBTClientStateDelegate:(id<SDLOnTBTClientStateDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onOnTBTClientStateDelegates = [self.onOnTBTClientStateDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnOnTouchEventDelegate:(id<SDLOnTouchEventDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onOnTouchEventDelegates = [self.onOnTouchEventDelegates setByAddingObject:delegate];
        }
    }
}

- (void)addOnOnVehicleDataDelegate:(id<SDLOnVehicleDataDelegate>)delegate {
    if (delegate) {
        @synchronized (self.delegateLock) {
            self.onOnVehicleDataDelegates = [self.onOnVehicleDataDelegates setByAddingObject:delegate];
        }
    }
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
            NSSet *delegateSet = nil;
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
                dispatch_async(strongSelf.mainUIQueue, ^{
                    [delegateSet enumerateObjectsUsingBlock:enumerationBlock];
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
                [strongSelf.onOnCommandDelegates enumerateObjectsUsingBlock:^(id<SDLOnCommandDelegate> delegate, BOOL *stop) {
                    [delegate onSDLCommand:command];
                }];
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
                [strongSelf.onOnButtonEventDelegates enumerateObjectsUsingBlock:^(id<SDLOnButtonEventDelegate> delegate, BOOL *stop) {
                    [delegate onSDLButtonEvent:((SDLOnButtonEvent *)notification)];
                }];
            }
        });
    }
    else if ([notification isKindOfClass:[SDLOnButtonPress class]] && [self.onOnButtonPressDelegates count] > 0) {
        dispatch_async(self.mainUIQueue, ^{
            typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf.onOnButtonPressDelegates enumerateObjectsUsingBlock:^(id<SDLOnButtonPressDelegate> delegate, BOOL *stop) {
                    [delegate onSDLButtonPress:((SDLOnButtonPress *)notification)];
                }];
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
                [strongSelf.proxyErrorDelegates enumerateObjectsUsingBlock:^(id<SDLProxyErrorDelegate> delegate, BOOL *stop) {
                    [delegate onSDLError:e];
                }];
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
                            [strongSelf.appRegisteredDelegates enumerateObjectsUsingBlock:^(id<SDLAppRegisteredDelegate> delegate, BOOL *stop) {
                                [delegate onSDLRegisterAppInterfaceResponse:((SDLRegisterAppInterfaceResponse *) response)];
                            }];
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
                [strongSelf.onProxyOpenedDelegates enumerateObjectsUsingBlock:^(id<SDLProxyOpenedDelegate> delegate, BOOL *stop) {
                    [delegate onSDLProxyOpened];
                }];
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
                [strongSelf.onProxyClosedDelegates enumerateObjectsUsingBlock:^(id<SDLProxyClosedDelegate> delegate, BOOL *stop) {
                    [delegate onSDLProxyClosed];
                }];
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
                        [strongSelf.firstHMINotNoneDelegates enumerateObjectsUsingBlock:^(id<SDLFirstHMINotNoneDelegate> delegate, BOOL *stop) {
                            [delegate onSDLFirstHMINotNone:notification];
                        }];
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
                        [strongSelf.firstHMIFullDelegates enumerateObjectsUsingBlock:^(id<SDLFirstHMIFullDelegate> delegate, BOOL *stop) {
                            [delegate onSDLFirstHMIFull:notification];
                        }];
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
                        [strongSelf.firstHMINotNoneDelegates enumerateObjectsUsingBlock:^(id<SDLFirstHMINotNoneDelegate> delegate, BOOL *stop) {
                            [delegate onSDLFirstHMINotNone:notification];
                        }];
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
                [strongSelf.onOnHMIStatusDelegates enumerateObjectsUsingBlock:^(id<SDLOnHMIStatusDelegate> delegate, BOOL *stop) {
                    [delegate onSDLHMIStatus:notification];
                }];
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
