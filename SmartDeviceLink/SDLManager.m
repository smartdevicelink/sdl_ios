

#import <Foundation/Foundation.h>

#import "SDLManager.h"

#import "NSMapTable+Subscripting.h"
#import "SDLConfiguration.h"
#import "SDLConnectionManagerType.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLifecycleManager.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLLockScreenManager.h"
#import "SDLLockScreenPresenter.h"
#import "SDLLogConfiguration.h"
#import "SDLManagerDelegate.h"
#import "SDLNotificationDispatcher.h"
#import "SDLResponseDispatcher.h"
#import "SDLSoftButtonManager.h"
#import "SDLStateMachine.h"
#import "SDLTextAndGraphicManager.h"


NS_ASSUME_NONNULL_BEGIN

#pragma mark - SDLManager Private Interface

@interface SDLManager ()

@property (strong, nonatomic) SDLLifecycleManager *lifecycleManager;

@end


#pragma mark - SDLManager Implementation

@implementation SDLManager

#pragma mark Lifecycle

- (instancetype)init {
    return [self initWithConfiguration:[SDLConfiguration configurationWithLifecycle:[SDLLifecycleConfiguration defaultConfigurationWithAppName:@"SDL APP" appId:@"001"] lockScreen:[SDLLockScreenConfiguration enabledConfiguration] logging:[SDLLogConfiguration defaultConfiguration]] delegate:nil];
}

- (instancetype)initWithConfiguration:(SDLConfiguration *)configuration delegate:(nullable id<SDLManagerDelegate>)delegate {
    self = [super init];
    if (!self) {
        return nil;
    }

    _lifecycleManager = [[SDLLifecycleManager alloc] initWithConfiguration:configuration delegate:delegate];

    return self;
}

- (void)startWithReadyHandler:(SDLManagerReadyBlock)readyHandler {
    [self.lifecycleManager startWithReadyHandler:readyHandler];
}

- (void)stop {
    [self.lifecycleManager stop];
}


#pragma mark - Passthrough getters / setters

- (SDLConfiguration *)configuration {
    return self.lifecycleManager.configuration;
}

- (nullable SDLHMILevel)hmiLevel {
    return self.lifecycleManager.hmiLevel;
}

- (SDLFileManager *)fileManager {
    return self.lifecycleManager.fileManager;
}

- (SDLPermissionManager *)permissionManager {
    return self.lifecycleManager.permissionManager;
}

- (nullable SDLStreamingMediaManager *)streamManager {
    return self.lifecycleManager.streamManager;
}

- (SDLScreenManager *)screenManager {
    return self.lifecycleManager.screenManager;
}

- (SDLSystemCapabilityManager *)systemCapabilityManager {
    return self.lifecycleManager.systemCapabilityManager;
}

- (nullable SDLRegisterAppInterfaceResponse *)registerResponse {
    return self.lifecycleManager.registerResponse;
}

- (nullable id<SDLManagerDelegate>)delegate {
    return self.lifecycleManager.delegate;
}

- (void)setDelegate:(nullable id<SDLManagerDelegate>)delegate {
    self.lifecycleManager.delegate = delegate;
}

- (NSArray<__kindof NSOperation *> *)pendingRPCTransactions {
    return self.lifecycleManager.rpcOperationQueue.operations;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (nullable SDLProxy *)proxy {
    return self.lifecycleManager.proxy;
}
#pragma clang diagnostic pop


#pragma mark SDLConnectionManager Protocol

- (void)sendRequest:(SDLRPCRequest *)request {
    [self sendRequest:request withResponseHandler:nil];
}

- (void)sendRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    [self.lifecycleManager sendRequest:request withResponseHandler:handler];
}

- (void)sendRequests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleAsyncRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler {
    [self.lifecycleManager sendRequests:requests progressHandler:progressHandler completionHandler:completionHandler];
}

- (void)sendSequentialRequests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleSequentialRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler {
    [self.lifecycleManager sendSequentialRequests:requests progressHandler:progressHandler completionHandler:completionHandler];
}

@end

NS_ASSUME_NONNULL_END
