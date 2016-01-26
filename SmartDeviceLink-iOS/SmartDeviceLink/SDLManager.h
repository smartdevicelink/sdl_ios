

typedef NS_ENUM(NSUInteger, SDLEvent) {
    SDLEventError,
    SDLEventClosed,
    SDLEventOpened
};

#import "SDLConnectionManagerType.h"
#import "SDLNotificationConstants.h"

@class SDLConfiguration;
@class SDLFileManager;
@class SDLHMILevel;
@class SDLLanguage;
@class SDLLifecycleConfiguration;
@class SDLLockScreenConfiguration;
@class SDLPermissionManager;
@class SDLPutFile;
@class SDLRPCNotification;
@class SDLRPCRequest;
@class SDLRPCResponse;


typedef NS_ENUM(NSUInteger, SDLLifecycleState) {
    SDLLifecycleStateNotConnected,
    SDLLifecycleStateNotReady,
    SDLLifecycleStateReady
};


NS_ASSUME_NONNULL_BEGIN

@interface SDLManager : NSObject <SDLConnectionManagerType>

@property (assign, nonatomic, readonly) SDLLifecycleState lifecycleState;
@property (copy, nonatomic, readonly) SDLConfiguration *configuration;
@property (copy, nonatomic, readonly) SDLHMILevel *currentHMILevel;
@property (strong, nonatomic, readonly) SDLFileManager *fileManager;
@property (strong, nonatomic, readonly) SDLPermissionManager *permissionManager;

#pragma mark Lifecycle
+ (instancetype)sharedManager;
- (void)startProxyWithConfiguration:(SDLConfiguration *)configuration;
- (void)stopProxy;

#pragma mark Manually Send RPC Requests
- (void)sendRequest:(SDLRPCRequest *)request withCompletionHandler:(nullable SDLRequestCompletionHandler)handler;

#pragma mark File Streaming
- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest; // TODO: Remove when file manager is tested

@end

NS_ASSUME_NONNULL_END
