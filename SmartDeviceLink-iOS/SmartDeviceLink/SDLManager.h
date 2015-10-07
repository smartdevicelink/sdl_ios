//  SDLProxyBase.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

typedef NS_ENUM(NSUInteger, SDLEvent) {
    SDLEventError,
    SDLEventClosed,
    SDLEventOpened
};

@class SDLLanguage, SDLLifecycleConfiguration, SDLPutFile, SDLRPCNotification, SDLRPCRequest, SDLRPCResponse;


NS_ASSUME_NONNULL_BEGIN

@interface SDLManager : NSObject

@property (assign, nonatomic, readonly, getter=isConnected) BOOL connected;
@property (copy, nonatomic, readonly) SDLLifecycleConfiguration *configuration;

+ (instancetype)sharedManager;

// Main proxy methods
- (void)sendRequest:(SDLRPCRequest *)request withCompletionHandler:(nullable SDLRequestCompletionHandler)block;
- (void)startProxyWithConfiguration:(SDLLifecycleConfiguration *)configuration;
- (void)stopProxy;
- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest;

@end

NS_ASSUME_NONNULL_END
