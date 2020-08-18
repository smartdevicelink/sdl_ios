

#import "SDLNotificationConstants.h"

#import "SDLAudioStreamingState.h"
#import "SDLHMILevel.h"
#import "SDLLanguage.h"
#import "SDLSystemContext.h"

@class SDLConfiguration;
@class SDLFileManager;
@class SDLLifecycleConfiguration;
@class SDLLockScreenConfiguration;
@class SDLPermissionManager;
@class SDLProxy;
@class SDLPutFile;
@class SDLRegisterAppInterfaceResponse;
@class SDLRPCMessage;
@class SDLRPCNotification;
@class SDLRPCRequest;
@class SDLRPCResponse;
@class SDLScreenManager;
@class SDLStreamingMediaManager;
@class SDLSystemCapabilityManager;

@protocol SDLManagerDelegate;


NS_ASSUME_NONNULL_BEGIN

/// The block called when the manager is ready to be used or an error occurs while attempting to become ready.
///
/// @param success a bool value if the set up succeeded
/// @param error the error is any exists
typedef void (^SDLManagerReadyBlock)(BOOL success, NSError *_Nullable error);

/// The top level manager object for all of SDL's interactions with the app and the head unit
@interface SDLManager : NSObject

/**
 *  The configuration the manager was set up with.
 */
@property (copy, nonatomic, readonly) SDLConfiguration *configuration;

/**
 *  The current HMI level of the running app.
 */
@property (copy, nonatomic, readonly, nullable) SDLHMILevel hmiLevel;

/**
 *  The current audio streaming state of the running app.
 */
@property (copy, nonatomic, readonly) SDLAudioStreamingState audioStreamingState;

/**
 *  The current system context of the running app.
 */
@property (copy, nonatomic, readonly) SDLSystemContext systemContext;

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
 *  The screen manager for sending UI related RPCs.
 */
@property (strong, nonatomic, readonly) SDLScreenManager *screenManager;

/**
 *  Centralized manager for retrieving all system capabilities.
 */
@property (strong, nonatomic, readonly) SDLSystemCapabilityManager *systemCapabilityManager;

/**
 *  The response of a register call after it has been received.
 */
@property (strong, nonatomic, readonly, nullable) SDLRegisterAppInterfaceResponse *registerResponse;

/**
 *  The auth token, if received. This should be used to log into a user account. Primarily used for cloud apps with companion app stores.
 */
@property (strong, nonatomic, readonly, nullable) NSString *authToken;

/**
 *  The manager's delegate.
 */
@property (weak, nonatomic, nullable) id<SDLManagerDelegate> delegate;

/**
 The currently pending RPC request send transactions
 */
@property (copy, nonatomic, readonly) NSArray<__kindof NSOperation *> *pendingRPCTransactions;

/**
 * The version number of the SDL V4 interface, string representation
 * Optional
 */
@property (nonatomic, nullable) NSString *sdlMsgVersionString;

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
- (void)startWithReadyHandler:(SDLManagerReadyBlock)readyHandler NS_SWIFT_NAME(start(readyHandler:));

/**
 *  Stop the manager, it will disconnect if needed and no longer look for a connection. You probably don't need to call this method ever.
 *  
 *  If you do call this method, you must wait for SDLManagerDelegate's managerDidDisconnect callback to call startWithReadyHandler:.
 */
- (void)stop;

/**
 *  Start the encryption lifecycle manager, which will attempt to open a secure service.
 *
 *  Please call this method in the successful callback of startWithReadyHandler. If you do call this method, you must wait for SDLServiceEncryptionDelegate's serviceEncryptionUpdatedOnService delegate method before you send any encrypted RPCs.
 */
- (void)startRPCEncryption;

#pragma mark Manually Send RPC Requests

/**
 *  Send an RPC of type `Response`, `Notification` or `Request`. Responses and notifications sent to Core do not a response back from Core. Each request sent to Core does get a response, so if you need the response and/or error, call `sendRequest:withResponseHandler:` instead.
 *
 *  @param rpc An RPC of type `SDLRPCResponse`, `SDLRPCNotification` or `SDLRPCRequest`
 */
- (void)sendRPC:(__kindof SDLRPCMessage *)rpc;

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
- (void)sendRequest:(SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler NS_SWIFT_NAME(send(request:responseHandler:));

/**
 Send all of the requests given as quickly as possible, but in order. Call the completionHandler after all requests have either failed or given a response.

 @param requests The requests to be sent
 @param progressHandler A handler called every time a response is received
 @param completionHandler A handler to call when all requests have been responded to
 */
- (void)sendRequests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleAsyncRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler;

/**
 Send all of the requests one at a time, with the next one going out only after the previous one has received a response. Call the completionHandler after all requests have either failed or given a response.

 @param requests The requests to be sent
 @param progressHandler A handler called every time a response is received. Return NO to cancel any requests that have not yet been sent, YES to continue sending requests.
 @param completionHandler A handler to call when all requests have been responded to
 */
- (void)sendSequentialRequests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleSequentialRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler NS_SWIFT_NAME(sendSequential(requests:progressHandler:completionHandler:));


#pragma mark - RPC Subscriptions

/// The block that will be called every time an RPC is received when subscribed to an RPC.
///
/// @param message The RPC message
typedef void (^SDLRPCUpdatedBlock) (__kindof SDLRPCMessage *message);

/**
 * Subscribe to callbacks about a particular RPC request, notification, or response with a block callback.
 *
 * @param rpcName The name of the RPC request, response, or notification to subscribe to.
 * @param block The block that will be called every time an RPC of the name and type specified is received.
 * @return An object that can be passed to `unsubscribeFromRPC:ofType:withObserver:` to unsubscribe the block.
 */
- (id)subscribeToRPC:(SDLNotificationName)rpcName withBlock:(SDLRPCUpdatedBlock)block NS_SWIFT_NAME(subscribe(to:block:));

/**
 * Subscribe to callbacks about a particular RPC request, notification, or response with a selector callback.
 *
 * The selector supports the following parameters:
 *
 * 1. Zero parameters e.g. `- (void)registerAppInterfaceResponse`
 * 2. One parameter e.g. `- (void)registerAppInterfaceResponse:(NSNotification *)notification;`
 *
 * Note that using this method to get a response instead of the `sendRequest:withResponseHandler:` method of getting a response, you will not be notifed of any `SDLGenericResponse` errors where the head unit doesn't understand the request.
 *
 * @param rpcName The name of the RPC request, response, or notification to subscribe to.
 * @param observer The object that will have its selector called every time an RPC of the name and type specified is received.
 * @param selector The selector on `observer` that will be called every time an RPC of the name and type specified is received.
 */
- (void)subscribeToRPC:(SDLNotificationName)rpcName withObserver:(id)observer selector:(SEL)selector NS_SWIFT_NAME(subscribe(to:observer:selector:));

/**
 * Unsubscribe to callbacks about a particular RPC request, notification, or response.
 *
 * @param rpcName The name of the RPC request, response, or notification to unsubscribe from.
 * @param observer The object representing a block callback or selector callback to be unsubscribed
 */
- (void)unsubscribeFromRPC:(SDLNotificationName)rpcName withObserver:(id)observer NS_SWIFT_NAME(unsubscribe(from:observer:));

@end

NS_ASSUME_NONNULL_END
