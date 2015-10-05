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
@property (copy, nonatomic, readonly) NSString *appName;
@property (copy, nonatomic, readonly) NSString *appID;
@property (assign, nonatomic, readonly) BOOL isMedia;
@property (strong, nonatomic, readonly) SDLLanguage *languageDesired;
@property (copy, nonatomic, readonly) NSString *shortName;
@property (copy, nonatomic, readonly) NSArray<NSString *> *vrSynonyms;
@property (assign, nonatomic, readonly, getter=isConnected) BOOL connected;

+ (instancetype)sharedManager;

// Main proxy methods
- (void)sendRequest:(SDLRPCRequest *)request withCompletionHandler:(nullable SDLRequestCompletionHandler)block;
- (void)startProxyWithAppName:(NSString *)appName appID:(NSString *)appID isMedia:(BOOL)isMedia languageDesired:(SDLLanguage *)languageDesired shortName:(nullable NSString *)shortName vrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms;
- (void)stopProxy;
- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest;

@end

NS_ASSUME_NONNULL_END
