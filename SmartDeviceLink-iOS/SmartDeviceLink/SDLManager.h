//  SDLProxyBase.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

typedef NS_ENUM(NSUInteger, SDLEvent) {
    SDLEventError,
    SDLEventClosed,
    SDLEventOpened
};

#import "SDLConnectionManager.h"
#import "SDLNotificationConstants.h"

@class SDLConfiguration;
@class SDLHMILevel;
@class SDLLanguage;
@class SDLLifecycleConfiguration;
@class SDLLockScreenConfiguration;
@class SDLPutFile;
@class SDLRPCNotification;
@class SDLRPCRequest;
@class SDLRPCResponse;


NS_ASSUME_NONNULL_BEGIN

@interface SDLManager : NSObject <SDLConnectionManager>

@property (assign, nonatomic, readonly, getter=isConnected) BOOL connected;
@property (copy, nonatomic, readonly) SDLConfiguration *configuration;
@property (copy, nonatomic, readonly) SDLHMILevel *currentHMILevel;

+ (instancetype)sharedManager;

#pragma mark Lifecycle
- (void)startProxyWithConfiguration:(SDLConfiguration *)configuration;
- (void)stopProxy;

#pragma mark File Streaming
- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest; // TODO: Remove when file manager is tested

@end

NS_ASSUME_NONNULL_END
