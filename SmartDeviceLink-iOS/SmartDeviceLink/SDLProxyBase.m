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

// SDL Delegate
@property (strong) NSHashTable *delegates;

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
        
        _delegates = [NSHashTable weakObjectsHashTable];
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

- (void)addDelegate:(id<SDLManagerDelegate>)delegate {
    if (delegate && self.delegates) {
        @synchronized(self.delegateLock) {
            [self.delegates addObject:delegate];
        }
    }
}

#pragma mark Event, Response, Notification Processing

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
        if (!strongSelf) {
            return;
        }
        NSHashTable *delegateHashTable = strongSelf.delegates;
        void (^enumerationBlock)(id<SDLManagerDelegate> delegate) = nil;
        
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
            enumerationBlock = ^(id<SDLManagerDelegate> delegate) {
                if ([delegate respondsToSelector:@selector(onSDLDriverDistraction:)]) {
                    [delegate onSDLDriverDistraction:((SDLOnDriverDistraction *)notification)];
                }
            };
        }
        else if ([notification isKindOfClass:[SDLOnAppInterfaceUnregistered class]]) {
            enumerationBlock = ^(id<SDLManagerDelegate> delegate) {
                if ([delegate respondsToSelector:@selector(onSDLAppInterfaceUnregistered:)]) {
                    [delegate onSDLAppInterfaceUnregistered:((SDLOnAppInterfaceUnregistered *)notification)];
                }
            };
        }
        else if ([notification isKindOfClass:[SDLOnAudioPassThru class]]) {
            enumerationBlock = ^(id<SDLManagerDelegate> delegate) {
                if ([delegate respondsToSelector:@selector(onSDLAudioPassThru:)]) {
                    [delegate onSDLAudioPassThru:((SDLOnAudioPassThru *)notification)];
                }
            };
        }
        else if ([notification isKindOfClass:[SDLOnEncodedSyncPData class]]) {
            enumerationBlock = ^(id<SDLManagerDelegate> delegate) {
                if ([delegate respondsToSelector:@selector(onSDLEncodedSyncPData:)]) {
                    [delegate onSDLEncodedSyncPData:((SDLOnEncodedSyncPData *)notification)];
                }
            };
        }
        else if ([notification isKindOfClass:[SDLOnHashChange class]]) {
            enumerationBlock = ^(id<SDLManagerDelegate> delegate) {
                if ([delegate respondsToSelector:@selector(onSDLHashChange:)]) {
                    [delegate onSDLHashChange:((SDLOnHashChange *)notification)];
                }
            };
        }
        else if ([notification isKindOfClass:[SDLOnLanguageChange class]]) {
            enumerationBlock = ^(id<SDLManagerDelegate> delegate) {
                if ([delegate respondsToSelector:@selector(onSDLLanguageChange:)]) {
                    [delegate onSDLLanguageChange:((SDLOnLanguageChange *)notification)];
                }
            };
        }
        else if ([notification isKindOfClass:[SDLOnPermissionsChange class]]) {
            enumerationBlock = ^(id<SDLManagerDelegate> delegate) {
                if ([delegate respondsToSelector:@selector(onSDLPermissionsChange:)]) {
                    [delegate onSDLPermissionsChange:((SDLOnPermissionsChange *)notification)];
                }
            };
        }
        else if ([notification isKindOfClass:[SDLOnSyncPData class]]) {
            enumerationBlock = ^(id<SDLManagerDelegate> delegate) {
                if ([delegate respondsToSelector:@selector(onSDLSyncPData:)]) {
                    [delegate onSDLSyncPData:((SDLOnSyncPData *)notification)];
                }
            };
        }
        else if ([notification isKindOfClass:[SDLOnSystemRequest class]]) {
            enumerationBlock = ^(id<SDLManagerDelegate> delegate) {
                if ([delegate respondsToSelector:@selector(onSDLSystemRequest:)]) {
                    [delegate onSDLSystemRequest:((SDLOnSystemRequest *)notification)];
                }
            };
        }
        else if ([notification isKindOfClass:[SDLOnTBTClientState class]]) {
            enumerationBlock = ^(id<SDLManagerDelegate> delegate) {
                if ([delegate respondsToSelector:@selector(onSDLTBTClientState:)]) {
                    [delegate onSDLTBTClientState:((SDLOnTBTClientState *)notification)];
                }
            };
        }
        else if ([notification isKindOfClass:[SDLOnTouchEvent class]]) {
            enumerationBlock = ^(id<SDLManagerDelegate> delegate) {
                if ([delegate respondsToSelector:@selector(onSDLTouchEvent:)]) {
                    [delegate onSDLTouchEvent:((SDLOnTouchEvent *)notification)];
                }
            };
        }
        else if ([notification isKindOfClass:[SDLOnVehicleData class]]) {
            enumerationBlock = ^(id<SDLManagerDelegate> delegate) {
                if ([delegate respondsToSelector:@selector(onSDLVehicleData:)]) {
                    [delegate onSDLVehicleData:((SDLOnVehicleData *)notification)];
                }
            };
        }
        else if ([notification isKindOfClass:[SDLOnLockScreenStatus class]]) {
            enumerationBlock = ^(id<SDLManagerDelegate> delegate) {
                if ([delegate respondsToSelector:@selector(onSDLLockScreenNotification:)]) {
                    [delegate onSDLLockScreenNotification:((SDLOnLockScreenStatus *)notification)];
                }
            };
        }
        
        if (delegateHashTable && enumerationBlock) {
            dispatch_async(strongSelf.mainUIQueue, ^{
                for (id<SDLManagerDelegate> delegate in delegateHashTable) {
                    enumerationBlock(delegate);
                }
            });
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
    dispatch_async(self.mainUIQueue, ^{
        typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            for (id<SDLManagerDelegate> delegate in strongSelf.delegates) {
                if ([delegate respondsToSelector:@selector(onSDLCommand:)]) {
                    [delegate onSDLCommand:command];
                }
            }
        }
    });
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
    if ([notification isKindOfClass:[SDLOnButtonEvent class]]) {
        dispatch_async(self.mainUIQueue, ^{
            typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                for (id<SDLManagerDelegate> delegate in strongSelf.delegates) {
                    if ([delegate respondsToSelector:@selector(onSDLButtonEvent:)]) {
                        [delegate onSDLButtonEvent:((SDLOnButtonEvent *)notification)];
                    }
                }
            }
        });
    }
    else if ([notification isKindOfClass:[SDLOnButtonPress class]]) {
        dispatch_async(self.mainUIQueue, ^{
            typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                for (id<SDLManagerDelegate> delegate in strongSelf.delegates) {
                    if ([delegate respondsToSelector:@selector(onSDLButtonPress:)]) {
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
            // TODO: Use non-null for these
            if (appName && appID && languageDesired)
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
                [SDLDebugTool logInfo:@"Error: One or more parameters (appName, appID, languageDesired) is nil"];
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


#pragma mark Private Methods

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
    dispatch_async(self.mainUIQueue, ^{
        typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            for (id<SDLManagerDelegate> delegate in strongSelf.delegates) {
                if ([delegate respondsToSelector:@selector(onSDLError:)]) {
                    [delegate onSDLError:e];
                }
            }
        }
    });
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
                dispatch_async(strongSelf.mainUIQueue, ^{
                    typeof(self) strongSelf = weakSelf;
                    if (strongSelf) {
                        for (id<SDLManagerDelegate> delegate in strongSelf.delegates) {
                            if ([delegate respondsToSelector:@selector(onSDLRegisterAppInterfaceResponse:)]) {
                                [delegate onSDLRegisterAppInterfaceResponse:((SDLRegisterAppInterfaceResponse *) response)];
                            }
                        }
                    }
                });
            }
        }];
    }
    dispatch_async(self.mainUIQueue, ^{
        typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            for (id<SDLManagerDelegate> delegate in strongSelf.delegates) {
                if ([delegate respondsToSelector:@selector(onSDLProxyOpened)]) {
                    [delegate onSDLProxyOpened];
                }
            }
        }
    });
}

- (void)onProxyClosed {
    // Already background dispatched from caller
    __weak typeof(self) weakSelf = self;
    [SDLDebugTool logInfo:@"onProxyClosed"];
    self.connected = NO;
    [self disposeProxy];    // call this method instead of stopProxy to avoid double-dispatching
    dispatch_async(self.mainUIQueue, ^{
        typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            for (id<SDLManagerDelegate> delegate in strongSelf.delegates) {
                if ([delegate respondsToSelector:@selector(onSDLProxyClosed)]) {
                    [delegate onSDLProxyClosed];
                }
            }
        }
    });
    [self startProxy];
}

- (void)onHMIStatus:(SDLOnHMIStatus *)notification {
    // Already background dispatched from caller
    // TODO: Don't need strongself weakSelf if there's no stored block
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
            dispatch_async(self.mainUIQueue, ^{
                typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    for (id<SDLManagerDelegate> delegate in strongSelf.delegates) {
                        if ([delegate respondsToSelector:@selector(onSDLFirstHMINotNone:)]) {
                            [delegate onSDLFirstHMINotNone:notification];
                        }
                    }
                }
            });
        }
        @synchronized(self.hmiStateLock) {
            self.firstHMINotNoneOccurred = YES;
        }
        
        @synchronized(self.hmiStateLock) {
            occurred = self.firstHMIFullOccurred;
        }
        if (!occurred)
        {
            dispatch_async(self.mainUIQueue, ^{
                typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    for (id<SDLManagerDelegate> delegate in strongSelf.delegates) {
                        if ([delegate respondsToSelector:@selector(onSDLFirstHMIFull:)]) {
                            [delegate onSDLFirstHMIFull:notification];
                        }
                    }
                }
            });
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
            dispatch_async(self.mainUIQueue, ^{
                typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    for (id<SDLManagerDelegate> delegate in strongSelf.delegates) {
                        if ([delegate respondsToSelector:@selector(onSDLFirstHMINotNone:)]) {
                            [delegate onSDLFirstHMINotNone:notification];

                        }
                    }
                }
            });
        }
        @synchronized(self.hmiStateLock) {
            self.firstHMINotNoneOccurred = YES;
        }
    }
    dispatch_async(self.mainUIQueue, ^{
        typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            for (id<SDLManagerDelegate> delegate in strongSelf.delegates) {
                if ([delegate respondsToSelector:@selector(onSDLHMIStatus:)]) {
                    [delegate onSDLHMIStatus:notification];
                }
            }
        }
    });
}

@end
