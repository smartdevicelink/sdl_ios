//
//  SDLLifecycleManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/19/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLNotificationConstants.h"
#import <Foundation/Foundation.h>

#import "SDLAudioStreamingState.h"
#import "SDLHMILevel.h"
#import "SDLLanguage.h"
#import "SDLSystemContext.h"

@class SDLConfiguration;
@class SDLFileManager;
@class SDLLifecycleConfiguration;
@class SDLLockScreenConfiguration;
@class SDLLockScreenManager;
@class SDLNotificationDispatcher;
@class SDLOnHashChange;
@class SDLPermissionManager;
@class SDLProxy;
@class SDLPutFile;
@class SDLRegisterAppInterfaceResponse;
@class SDLResponseDispatcher;
@class SDLRPCNotification;
@class SDLRPCRequest;
@class SDLRPCResponse;
@class SDLScreenManager;
@class SDLStateMachine;
@class SDLStreamingMediaManager;

@protocol SDLManagerDelegate;


NS_ASSUME_NONNULL_BEGIN

typedef NSString SDLLifecycleState;
extern SDLLifecycleState *const SDLLifecycleStateStopped;
extern SDLLifecycleState *const SDLLifecycleStateStarted;
extern SDLLifecycleState *const SDLLifecycleStateReconnecting;
extern SDLLifecycleState *const SDLLifecycleStateConnected;
extern SDLLifecycleState *const SDLLifecycleStateRegistered;
extern SDLLifecycleState *const SDLLifecycleStateUpdatingConfiguration;
extern SDLLifecycleState *const SDLLifecycleStateSettingUpManagers;
extern SDLLifecycleState *const SDLLifecycleStateSettingUpAppIcon;
extern SDLLifecycleState *const SDLLifecycleStateSettingUpHMI;
extern SDLLifecycleState *const SDLLifecycleStateUnregistering;
extern SDLLifecycleState *const SDLLifecycleStateReady;

typedef void (^SDLMultipleRequestCompletionHandler)(BOOL success);
typedef BOOL (^SDLMultipleSequentialRequestProgressHandler)(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *__nullable response, NSError *__nullable error, float percentComplete);
typedef void (^SDLMultipleAsyncRequestProgressHandler)(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *__nullable response, NSError *__nullable error, float percentComplete);
typedef void (^SDLManagerReadyBlock)(BOOL success, NSError *_Nullable error);


@interface SDLLifecycleManager : NSObject

@property (copy, nonatomic, readonly) SDLConfiguration *configuration;
@property (weak, nonatomic, nullable) id<SDLManagerDelegate> delegate;

@property (strong, nonatomic) SDLFileManager *fileManager;
@property (strong, nonatomic) SDLPermissionManager *permissionManager;
@property (strong, nonatomic, nullable) SDLStreamingMediaManager *streamManager;
@property (strong, nonatomic) SDLLockScreenManager *lockScreenManager;
@property (strong, nonatomic, readonly) SDLScreenManager *screenManager;

@property (strong, nonatomic, readonly) SDLNotificationDispatcher *notificationDispatcher;
@property (strong, nonatomic, readonly) SDLResponseDispatcher *responseDispatcher;
@property (strong, nonatomic, readonly) SDLStateMachine *lifecycleStateMachine;

// Deprecated internal proxy object
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (strong, nonatomic, nullable) SDLProxy *proxy;
#pragma clang diagnostic pop

@property (assign, nonatomic) UInt16 lastCorrelationId;
@property (copy, nonatomic, readonly) SDLLifecycleState *lifecycleState;
@property (copy, nonatomic, nullable) SDLHMILevel hmiLevel;
@property (copy, nonatomic, nullable) SDLAudioStreamingState audioStreamingState;
@property (copy, nonatomic, nullable) SDLSystemContext systemContext;
@property (strong, nonatomic, nullable) SDLRegisterAppInterfaceResponse *registerResponse;

@property (strong, nonatomic) NSOperationQueue *rpcOperationQueue;


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


#pragma mark Send RPC Requests

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

/**
 Send all of the requests given as quickly as possible, but in order. Call the completionHandler after all requests have either failed or given a response.

 @param requests The requests to be sent
 @param progressHandler A handler called every time a response is received.
 @param completionHandler A handler to call when all requests have been responded to
 */
- (void)sendRequests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleAsyncRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler;

/**
 Send all of the requests one at a time, with the next one going out only after the previous one has received a response. Call the completionHandler after all requests have either failed or given a response.

 @param requests The requests to be sent
 @param progressHandler A handler called every time a response is received
 @param completionHandler A handler to call when all requests have been responded to
 */
- (void)sendSequentialRequests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleSequentialRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
