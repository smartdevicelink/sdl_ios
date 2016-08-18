

#import "SDLNotificationConstants.h"

@class SDLConfiguration;
@class SDLFileManager;
@class SDLHMILevel;
@class SDLLanguage;
@class SDLLifecycleConfiguration;
@class SDLLockScreenConfiguration;
@class SDLPermissionManager;
@class SDLPutFile;
@class SDLRegisterAppInterfaceResponse;
@class SDLRPCNotification;
@class SDLRPCRequest;
@class SDLRPCResponse;
@class SDLStreamingMediaManager;

@protocol SDLManagerDelegate;


NS_ASSUME_NONNULL_BEGIN

typedef void (^SDLManagerReadyBlock)(BOOL success, NSError *_Nullable error);


@interface SDLManager : NSObject

/**
 *  The current state of the lifecycle.
 */
@property (assign, nonatomic, readonly) NSString *lifecycleState;

/**
 *  The configuration the manager was set up with.
 */
@property (copy, nonatomic, readonly) SDLConfiguration *configuration;

/**
 *  The current HMI level of the running app.
 */
@property (copy, nonatomic, readonly) SDLHMILevel *hmiLevel;

/**
 *  The file manager to be used by the running app.
 */
@property (strong, nonatomic, readonly) SDLFileManager *fileManager;

/**
 *  The permission manager monitoring RPC permissions.
 */
@property (strong, nonatomic, readonly) SDLPermissionManager *permissionManager;

/**
 *  The streaming media manager to be used for starting video sessions.
 */
@property (strong, nonatomic, readonly, nullable) SDLStreamingMediaManager *streamManager;

/**
 *  The manager's delegate.
 */
@property (weak, nonatomic, nullable) id<SDLManagerDelegate> delegate;

/**
 *  The response of a register call after it has been received.
 */
@property (strong, nonatomic, readonly, nullable) SDLRegisterAppInterfaceResponse *registerResponse;


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
- (void)startWithHandler:(SDLManagerReadyBlock)readyBlock;

/**
 *  Stop the manager, it will disconnect if needed and no longer look for a connection. You probably don't need to call this method ever.
 */
- (void)stop;

/**
 *  Call this method within your AppDelegate's `applicationWillTerminate` method to properly shut down SDL. If you do not, you will not be able to reregister with the remote device.
 */
- (void)applicationWillTerminate;


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
