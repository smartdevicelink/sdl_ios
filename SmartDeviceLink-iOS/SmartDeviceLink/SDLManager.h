//  SDLProxyBase.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

#import "SDLManagerDelegate.h"

typedef NS_ENUM(NSUInteger, SDLEvent) {
    SDLEventError,
    SDLEventClosed,
    SDLEventOpened
};

@class SDLRPCRequest, SDLRPCResponse, SDLRPCNotification, SDLLanguage, SDLPutFile;


@interface SDLManager : NSObject

// Proxy registration objects
@property (copy) NSString *appName;
@property (copy) NSString *appID;
@property (assign) BOOL isMedia;
@property (strong) SDLLanguage *languageDesired;
@property (copy) NSString *shortName;
@property (copy) NSArray *vrSynonyms;
@property (assign, readonly, getter=isConnected) BOOL connected;

+ (instancetype)sharedManager;

- (void)addDelegate:(id<SDLManagerDelegate>)delegate;

// Main proxy methods
- (void)sendRPC:(SDLRPCRequest *)rpc responseHandler:(SDLRPCResponseHandler)responseHandler;
- (void)startProxyWithAppName:(NSString *)appName appID:(NSString *)appID isMedia:(BOOL)isMedia languageDesired:(SDLLanguage *)languageDesired;
- (void)stopProxy;
- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest;

@end
