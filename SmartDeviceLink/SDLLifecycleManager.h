//
//  SDLLifecycleManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/19/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLNotificationConstants.h"

@class SDLConfiguration;
@class SDLFileManager;
@class SDLHMILevel;
@class SDLLanguage;
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
@class SDLStateMachine;
@class SDLStreamingMediaManager;

@protocol SDLManagerDelegate;


NS_ASSUME_NONNULL_BEGIN

// TODO: Should these be private only (and those like them) so that we can change them without requiring minor / major version changes?
typedef NSString SDLLifecycleState;
extern SDLLifecycleState *const SDLLifecycleStateDisconnected;
extern SDLLifecycleState *const SDLLifecycleStateTransportConnected;
extern SDLLifecycleState *const SDLLifecycleStateRegistered;
extern SDLLifecycleState *const SDLLifecycleStateSettingUpManagers;
extern SDLLifecycleState *const SDLLifecycleStatePostManagerProcessing;
extern SDLLifecycleState *const SDLLifecycleStateUnregistering;
extern SDLLifecycleState *const SDLLifecycleStateReady;


@interface SDLLifecycleManager : NSObject

@property (copy, nonatomic, readonly) SDLConfiguration *configuration;
@property (strong, nonatomic) SDLFileManager *fileManager;
@property (strong, nonatomic) SDLPermissionManager *permissionManager;
@property (strong, nonatomic, readonly, nullable) SDLStreamingMediaManager *streamManager;
@property (strong, nonatomic) SDLLockScreenManager *lockScreenManager;
@property (strong, nonatomic, readonly) SDLNotificationDispatcher *notificationDispatcher;
@property (strong, nonatomic, readonly) SDLResponseDispatcher *responseDispatcher;
@property (weak, nonatomic, readonly, nullable) id<SDLManagerDelegate> delegate;
@property (copy, nonatomic, readonly) NSString *stateTransitionNotificationName;
@property (strong, nonatomic, readonly) SDLStateMachine *lifecycleStateMachine;

// Deprecated internal proxy object
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (strong, nonatomic, readonly, nullable) SDLProxy *proxy;
#pragma clang diagnostic pop

@property (assign, nonatomic, readonly) UInt16 lastCorrelationId;
@property (strong, nonatomic, readonly, nullable) SDLOnHashChange *resumeHash;
@property (strong, nonatomic, readonly, nullable) SDLRegisterAppInterfaceResponse *registerAppInterfaceResponse;
@property (assign, nonatomic, readonly) NSString *lifecycleState;
@property (assign, nonatomic, readonly) BOOL firstHMIFullOccurred;
@property (assign, nonatomic, readonly) BOOL firstHMINotNoneOccurred;
@property (copy, nonatomic, readonly) SDLHMILevel *currentHMILevel;

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
- (void)sendRequest:(SDLRPCRequest *)request withCompletionHandler:(nullable SDLRequestCompletionHandler)handler;

@end

NS_ASSUME_NONNULL_END