//  SDLProxyBase.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

typedef NS_ENUM(NSUInteger, SDLEvent) {
    SDLEventError,
    SDLEventClosed,
    SDLEventOpened
};

@class SDLRPCRequest, SDLRPCResponse, SDLRPCNotification, SDLLanguage, SDLPutFile;


NS_ASSUME_NONNULL_BEGIN

@interface SDLManager : NSObject

// Proxy registration objects
@property (copy, nonatomic) NSString *appName;
@property (copy, nonatomic) NSString *appID;
@property (assign, nonatomic) BOOL isMedia;
@property (strong, nonatomic) SDLLanguage *languageDesired;
@property (copy, nonatomic) NSString *shortName;
@property (copy, nonatomic) NSArray<NSString *> *vrSynonyms;
@property (assign, readonly, getter=isConnected) BOOL connected;

+ (instancetype)sharedManager;

// Main proxy methods
- (void)sendRequest:(SDLRPCRequest *)request withCompletionHandler:(nullable SDLRequestCompletionHandler)block;
- (void)startProxyWithAppName:(NSString *)appName appID:(NSString *)appID isMedia:(BOOL)isMedia languageDesired:(SDLLanguage *)languageDesired;
- (void)stopProxy;
- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest;

@end

NS_ASSUME_NONNULL_END
