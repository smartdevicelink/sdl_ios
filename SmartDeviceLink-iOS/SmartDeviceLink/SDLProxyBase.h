//  SDLProxyBase.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

#import "SDLHandlers.h"

enum SDLEvent {OnError, ProxyClosed, ProxyOpened};

@class SDLRPCRequest, SDLRPCResponse, SDLRPCNotification, SDLLanguage, SDLPutFile;

@interface SDLProxyBase : NSObject

// Proxy notification and event handlers
@property (copy) eventHandler onProxyOpenedHandler;
@property (copy) eventHandler onProxyClosedHandler;
@property (copy) eventHandler firstHMIFullHandler;
@property (copy) eventHandler firstHMINotNoneHandler;
@property (copy) errorHandler proxyErrorHandler;
@property (copy) rpcResponseHandler appRegisteredHandler;

// These handlers are required for the app to implement
@property (copy) rpcNotificationHandler onOnLockScreenNotificationHandler;
@property (copy) rpcNotificationHandler onOnLanguageChangeHandler;
@property (copy) rpcNotificationHandler onOnPermissionsChangeHandler;

// Optional handlers
@property (copy) rpcNotificationHandler onOnDriverDistractionHandler;
@property (copy) rpcNotificationHandler onOnHMIStatusHandler;
@property (copy) rpcNotificationHandler onOnAppInterfaceUnregisteredHandler;
@property (copy) rpcNotificationHandler onOnAudioPassThruHandler;
@property (copy) rpcNotificationHandler onOnButtonEventHandler;
@property (copy) rpcNotificationHandler onOnButtonPressHandler;
@property (copy) rpcNotificationHandler onOnCommandHandler;
@property (copy) rpcNotificationHandler onOnEncodedSyncPDataHandler;
@property (copy) rpcNotificationHandler onOnHashChangeHandler;
@property (copy) rpcNotificationHandler onOnSyncPDataHandler;
@property (copy) rpcNotificationHandler onOnSystemRequestHandler;
@property (copy) rpcNotificationHandler onOnTBTClientStateHandler;
@property (copy) rpcNotificationHandler onOnTouchEventHandler;
@property (copy) rpcNotificationHandler onOnVehicleDataHandler;

// Proxy registration objects
@property (strong, nonatomic) NSString *appName;
@property (strong, nonatomic) NSString *appID;
@property (assign, nonatomic) BOOL isMedia;
@property (strong, nonatomic) SDLLanguage *languageDesired;
@property (strong, nonatomic) NSString *shortName;
@property (strong, nonatomic) NSArray *vrSynonyms;

- (void)runHandlerForEvent:(enum SDLEvent)sdlEvent error:(NSException *)error;
- (void)runHandlerForResponse:(SDLRPCResponse *)response;
- (void)runHandlerForNotification:(SDLRPCNotification *)notification;
- (void)sendRPC:(SDLRPCRequest *)rpc responseHandler:(rpcResponseHandler)responseHandler;
- (void)startProxyWithLockscreenHandler:(rpcNotificationHandler)lockscreenHandler
                  languageChangeHandler:(rpcNotificationHandler)languageChangeHandler
               permissionsChangeHandler:(rpcNotificationHandler)permissionsChangeHandler appName:(NSString *)appName appID:(NSString *)appID isMedia:(BOOL)isMedia languageDesired:(SDLLanguage *)languageDesired;
- (void)stopProxy;
- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest;

@end
