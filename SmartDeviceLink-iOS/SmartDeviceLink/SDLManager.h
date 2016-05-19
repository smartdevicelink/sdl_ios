

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
@class SDLStreamingMediaManager;


NS_ASSUME_NONNULL_BEGIN

extern NSString *const SDLLifecycleStateDisconnected;
extern NSString *const SDLLifecycleStateTransportConnected;
extern NSString *const SDLLifecycleStateRegistered;
extern NSString *const SDLLifecycleStateSettingUpManagers;
extern NSString *const SDLLifecycleStateUnregistering;
extern NSString *const SDLLifecycleStateReady;


@interface SDLManager : NSObject <SDLConnectionManagerType>

@property (assign, nonatomic, readonly) NSString *lifecycleState;
@property (copy, nonatomic, readonly) SDLConfiguration *configuration;
@property (copy, nonatomic, readonly) SDLHMILevel *currentHMILevel;
@property (strong, nonatomic, readonly) SDLFileManager *fileManager;
@property (strong, nonatomic, readonly) SDLPermissionManager *permissionManager;
@property (strong, nonatomic, readonly, nullable) SDLStreamingMediaManager *streamManager;

#pragma mark Lifecycle
/**
 *  Start the manager with a configuration. The manager will then begin waiting for a connection to occur. Once one does, it will automatically run the setup process. You will be notified of its completion via an NSNotification you will want to observe, `SDLDidBecomeReadyNotification`.
 *
 *  @param configuration Your app's unique configuration for setup.
 *
 *  @return An instance of SDLManager
 */
- (instancetype)initWithConfiguration:(SDLConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

- (void)start;
- (void)stop;

#pragma mark Manually Send RPC Requests
- (void)sendRequest:(SDLRPCRequest *)request withCompletionHandler:(nullable SDLRequestCompletionHandler)handler;

@end

NS_ASSUME_NONNULL_END
