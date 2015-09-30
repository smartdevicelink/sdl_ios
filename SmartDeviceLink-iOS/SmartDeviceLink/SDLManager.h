//  SDLProxyBase.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

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

// Main proxy methods
- (void)sendRequest:(SDLRPCRequest *)request withCompletionHandler:(SDLRequestCompletionHandler)block;
- (void)startProxyWithAppName:(NSString *)appName appID:(NSString *)appID isMedia:(BOOL)isMedia languageDesired:(SDLLanguage *)languageDesired;
- (void)stopProxy;
- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest;

@end
