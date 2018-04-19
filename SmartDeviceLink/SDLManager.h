

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
@class SDLRPCNotification;
@class SDLRPCRequest;
@class SDLRPCResponse;
@class SDLScreenManager;
@class SDLStreamingMediaManager;
@class SDLSystemCapabilityManager;

@protocol SDLManagerDelegate;


NS_ASSUME_NONNULL_BEGIN

/**
 A completion handler called after a sequential or simultaneous set of requests have completed sending.

 @param success True if every request succeeded, false if any failed. See the progress handler for more details on failures.
 */
typedef void (^SDLMultipleRequestCompletionHandler)(BOOL success);

/**
 A handler called after each response to a request comes in in a multiple request send.

 @param request The request that received a response
 @param response The response received
 @param error The error that occurred during the request if any occurred.
 @param percentComplete The percentage of requests that have received a response
 @return continueSendingRequests NO to cancel any requests that have not yet been sent. This is really only useful for a sequential send (sendSequentialRequests:progressHandler:completionHandler:). Return YES to continue sending requests.
 */
typedef BOOL (^SDLMultipleSequentialRequestProgressHandler)(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *__nullable response, NSError *__nullable error, float percentComplete);

/**
 A handler called after each response to a request comes in in a multiple request send.

 @param request The request that received a response
 @param response The response received
 @param error The error that occurred during the request if any occurred.
 @param percentComplete The percentage of requests that have received a response
 */
typedef void (^SDLMultipleAsyncRequestProgressHandler)(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *__nullable response, NSError *__nullable error, float percentComplete);


typedef void (^SDLManagerReadyBlock)(BOOL success, NSError *_Nullable error);


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
 *  The manager's delegate.
 */
@property (weak, nonatomic, nullable) id<SDLManagerDelegate> delegate;

/**
 The currently pending RPC request send transactions
 */
@property (copy, nonatomic, readonly) NSArray<__kindof NSOperation *> *pendingRPCTransactions;

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
- (void)startWithReadyHandler:(SDLManagerReadyBlock)readyHandler NS_SWIFT_NAME(start(readyHandler:));

/**
 *  Stop the manager, it will disconnect if needed and no longer look for a connection. You probably don't need to call this method ever.
 *  
 *  If you do call this method, you must wait for SDLManagerDelegate's managerDidDisconnect callback to call startWithReadyHandler:.
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

@end

NS_ASSUME_NONNULL_END
