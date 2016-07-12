

#import "SDLManagerDelegate.h"
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


@interface SDLManager : NSObject

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
- (instancetype)initWithConfiguration:(SDLConfiguration *)configuration delegate:(nullable id<SDLManagerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/**
 *  Start the manager, which will tell it to start looking for a connection.
 */
- (void)start;

/**
 *  Stop the manager, it will disconnect if needed and no longer look for a connection. You probably don't need to call this method ever.
 */
- (void)stop;


#pragma mark Manually Send RPC Requests

/**
 *  Send an RPC request and don't bother with the response or error. If you need the response or error, call sendRequest:withCompletionHandler: instead.
 *
 *  @param request The RPC request to send
 */
- (void)sendRequest:(SDLRPCRequest *)request;

/**
 *  Send an RPC request and set a completion handler that will be called with the response when the response returns.
 *
 *  @param request The RPC request to send
 *  @param handler The handler that will be called when the response returns
 */
- (void)sendRequest:(SDLRPCRequest *)request withCompletionHandler:(nullable SDLRequestCompletionHandler)handler;

@end

NS_ASSUME_NONNULL_END
