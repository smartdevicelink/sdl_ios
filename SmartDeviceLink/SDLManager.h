

#import "SDLNotificationConstants.h"

@class SDLConfiguration;
@class SDLFileManager;
@class SDLHMILevel;
@class SDLLanguage;
@class SDLLifecycleConfiguration;
@class SDLLockScreenConfiguration;
@class SDLPermissionManager;
@class SDLProxy;
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
 *  The response of a register call after it has been received.
 */
@property (strong, nonatomic, readonly, nullable) SDLRegisterAppInterfaceResponse *registerResponse;

/**
 *  The manager's delegate.
 */
@property (weak, nonatomic, nullable) id<SDLManagerDelegate> delegate;

/**
 * Deprecated internal proxy object. This should only be accessed when the Manager is READY. This property may go to nil at any time.
 * The only reason to use this is to access the `putFileStream:withRequest:` method. All other functionality exists on managers in 4.3. This will be removed in 5.0 and the functionality replicated on `SDLFileManager`.
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (strong, nonatomic, readonly, nullable) SDLProxy *proxy;
#pragma clang diagnostic pop


#pragma mark Lifecycle

/**
 *  Initialize the manager with a configuration. Call `startWithHandler` to begin waiting for a connection.
 *
 *  @param configuration Your app's unique configuration for setup.
 *  @param delegate An optional delegate to be notified of hmi level changes and startup and shutdown. It is recommended that you implement this.
 *
 *  @return An instance of SDLManager
 */
- (instancetype)initWithConfiguration:(SDLConfiguration *)configuration delegate:(nullable id<SDLManagerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/**
 *  Start the manager, which will tell it to start looking for a connection. Once one does, it will automatically run the setup process and call the readyBlock when done.
 *
 *  @param readyHandler The block called when the manager is ready to be used or an error occurs while attempting to become ready.
 */
- (void)startWithReadyHandler:(SDLManagerReadyBlock)readyHandler;

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
- (void)sendRequest:(SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler;

@end

NS_ASSUME_NONNULL_END
