

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


NS_ASSUME_NONNULL_BEGIN

extern NSString *const SDLLifecycleStateTransportDisconnected;
extern NSString *const SDLLifecycleStateTransportConnected;
extern NSString *const SDLLifecycleStateRegistered;
extern NSString *const SDLLifecycleStateSettingUpManagers;
extern NSString *const SDLLifecycleStateReady;

typedef NS_ENUM(NSUInteger, SDLEvent) {
    SDLEventError,
    SDLEventClosed,
    SDLEventOpened
};


@interface SDLManager : NSObject <SDLConnectionManagerType>

@property (assign, nonatomic, readonly) SDLState *lifecycleState;
@property (copy, nonatomic, readonly) SDLConfiguration *configuration;
@property (copy, nonatomic, readonly) SDLHMILevel *currentHMILevel;
@property (strong, nonatomic, readonly) SDLFileManager *fileManager;
@property (strong, nonatomic, readonly) SDLPermissionManager *permissionManager;

#pragma mark Lifecycle
+ (instancetype)sharedManager;
- (void)startWithConfiguration:(SDLConfiguration *)configuration;
- (void)stop;

#pragma mark Manually Send RPC Requests
- (void)sendRequest:(SDLRPCRequest *)request withCompletionHandler:(nullable SDLRequestCompletionHandler)handler;

@end

NS_ASSUME_NONNULL_END
