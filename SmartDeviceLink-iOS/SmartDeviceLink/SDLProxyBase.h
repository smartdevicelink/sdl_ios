//  SDLProxyBase.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

#import "SDLHandlers.h"

enum SDLEvent {OnError, ProxyClosed, ProxyOpened};

@class SDLRPCRequest, SDLRPCResponse, SDLRPCNotification, SDLLanguage, SDLPutFile;

@interface SDLProxyBase : NSObject

// Proxy registration objects
@property (strong, nonatomic) NSString *appName;
@property (strong, nonatomic) NSString *appID;
@property (assign, nonatomic) BOOL isMedia;
@property (strong, nonatomic) SDLLanguage *languageDesired;
@property (strong, nonatomic) NSString *shortName;
@property (strong, nonatomic) NSArray *vrSynonyms;

// Methods to add RPC notification handlers
// Note: Handlers are NOT run in the main/UI thread. Apps must take this in to account if/when updating the UI from a handler.
- (void)addOnProxyOpenedHandler:(eventHandler)handler;
- (void)addOnProxyClosedHandler:(eventHandler)handler;
- (void)addFirstHMIFullHandler:(eventHandler)handler;
- (void)addFirstHMINotNoneHandler:(eventHandler)handler;
- (void)addProxyErrorHandler:(errorHandler)handler;
- (void)addAppRegisteredHandler:(rpcResponseHandler)handler;
- (void)addOnOnLockScreenNotificationHandler:(rpcNotificationHandler)handler;
- (void)addOnOnLanguageChangeHandler:(rpcNotificationHandler)handler;
- (void)addOnOnPermissionsChangeHandler:(rpcNotificationHandler)handler;
- (void)addOnOnDriverDistractionHandler:(rpcNotificationHandler)handler;
- (void)addOnOnHMIStatusHandler:(rpcNotificationHandler)handler;
- (void)addOnOnAppInterfaceUnregisteredHandler:(rpcNotificationHandler)handler;
- (void)addOnOnAudioPassThruHandler:(rpcNotificationHandler)handler;
- (void)addOnOnButtonEventHandler:(rpcNotificationHandler)handler;
- (void)addOnOnButtonPressHandler:(rpcNotificationHandler)handler;
- (void)addOnOnCommandHandler:(rpcNotificationHandler)handler;
- (void)addOnOnEncodedSyncPDataHandler:(rpcNotificationHandler)handler;
- (void)addOnOnHashChangeHandler:(rpcNotificationHandler)handler;
- (void)addOnOnSyncPDataHandler:(rpcNotificationHandler)handler;
- (void)addOnOnSystemRequestHandler:(rpcNotificationHandler)handler;
- (void)addOnOnTBTClientStateHandler:(rpcNotificationHandler)handler;
- (void)addOnOnTouchEventHandler:(rpcNotificationHandler)handler;
- (void)addOnOnVehicleDataHandler:(rpcNotificationHandler)handler;

// Methods called by SDLProxyListenerBase in response to Events, and RPC Responses and Notifications
- (void)runHandlersForEvent:(enum SDLEvent)sdlEvent error:(NSException *)error;
- (void)runHandlersForResponse:(SDLRPCResponse *)response;
- (void)runHandlersForNotification:(SDLRPCNotification *)notification;

// Main proxy methods
- (void)sendRPC:(SDLRPCRequest *)rpc responseHandler:(rpcResponseHandler)responseHandler;
- (void)startProxyWithAppName:(NSString *)appName appID:(NSString *)appID isMedia:(BOOL)isMedia languageDesired:(SDLLanguage *)languageDesired;
- (void)stopProxy;
- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest;

@end
