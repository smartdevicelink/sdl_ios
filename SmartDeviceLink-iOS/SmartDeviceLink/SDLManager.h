//  SDLProxyBase.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

typedef NS_ENUM(NSUInteger, SDLEvent) {
    SDLEventError,
    SDLEventClosed,
    SDLEventOpened
};

@class SDLConfiguration;
@class SDLLanguage;
@class SDLLifecycleConfiguration;
@class SDLLockScreenConfiguration;
@class SDLPutFile;
@class SDLRPCNotification;
@class SDLRPCRequest;
@class SDLRPCResponse;


NS_ASSUME_NONNULL_BEGIN

@interface SDLManager : NSObject

@property (assign, nonatomic, readonly, getter=isConnected) BOOL connected;
@property (copy, nonatomic, readonly) SDLConfiguration *configuration;
@property (copy, nonatomic) SDLLockScreenConfiguration *lockScreenConfiguration;

+ (instancetype)sharedManager;

#pragma mark Lifecycle
- (void)sendRequest:(SDLRPCRequest *)request withCompletionHandler:(nullable SDLRequestCompletionHandler)block;
- (void)startProxyWithConfiguration:(SDLConfiguration *)configuration;
- (void)stopProxy;

#pragma mark File Streaming
- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest;

@end

NS_ASSUME_NONNULL_END
