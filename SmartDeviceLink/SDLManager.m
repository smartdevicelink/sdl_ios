

#import <Foundation/Foundation.h>

#import "SDLManager.h"

#import "NSMapTable+Subscripting.h"
#import "SDLConfiguration.h"
#import "SDLConnectionManagerType.h"
#import "SDLFileManagerConfiguration.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLifecycleManager.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLLockScreenManager.h"
#import "SDLLogConfiguration.h"
#import "SDLManagerDelegate.h"
#import "SDLNotificationDispatcher.h"
#import "SDLResponseDispatcher.h"
#import "SDLRPCRequestNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSoftButtonManager.h"
#import "SDLStateMachine.h"
#import "SDLTextAndGraphicManager.h"
#import "SDLStreamingMediaManager.h"


NS_ASSUME_NONNULL_BEGIN

#pragma mark - SDLManager Private Interface

@interface SDLManager ()

@property (strong, nonatomic) SDLLifecycleManager *lifecycleManager;

@end


#pragma mark - SDLManager Implementation

@implementation SDLManager

#pragma mark Lifecycle

- (instancetype)init {
    return [self initWithConfiguration:[[SDLConfiguration alloc] initWithLifecycle:[SDLLifecycleConfiguration defaultConfigurationWithAppName:@"SDL APP" fullAppId:@"001"] lockScreen:[SDLLockScreenConfiguration enabledConfiguration] logging:[SDLLogConfiguration defaultConfiguration] fileManager:[SDLFileManagerConfiguration defaultConfiguration] encryption:nil] delegate:nil];
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

- (void)startRPCEncryption {
    [self.lifecycleManager startRPCEncryption];
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

- (nullable NSString *)authToken {
    return self.lifecycleManager.authToken;
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

- (void)setSdlMsgVersionString:(nullable NSString *)versionString {
    self.lifecycleManager.sdlMsgVersionString = versionString;
}

- (nullable NSString *)sdlMsgVersionString {
    return self.lifecycleManager.sdlMsgVersionString;
}

#pragma mark SDLConnectionManager Protocol

- (void)sendRPC:(__kindof SDLRPCMessage *)rpc {
    [self.lifecycleManager sendRPC:rpc];
}

- (void)sendRequest:(SDLRPCRequest *)request {
    [self sendRequest:request withResponseHandler:nil];
}

- (void)sendRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    [self.lifecycleManager sendRequest:(__kindof SDLRPCMessage *)request withResponseHandler:handler];
}

- (void)sendRequests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleAsyncRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler {
    [self.lifecycleManager sendRequests:requests progressHandler:progressHandler completionHandler:completionHandler];
}

- (void)sendSequentialRequests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleSequentialRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler {
    [self.lifecycleManager sendSequentialRequests:requests progressHandler:progressHandler completionHandler:completionHandler];
}


#pragma mark - RPC Subscriptions

- (id)subscribeToRPC:(SDLNotificationName)rpcName withBlock:(SDLRPCUpdatedBlock)block {
    return [[NSNotificationCenter defaultCenter] addObserverForName:rpcName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        SDLRPCMessage *message = note.userInfo[SDLNotificationUserInfoObject];
        block(message);
    }];
}

- (void)subscribeToRPC:(SDLNotificationName)rpcName withObserver:(id)observer selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:rpcName object:nil];
}

- (void)unsubscribeFromRPC:(SDLNotificationName)rpcName withObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:rpcName object:nil];
}

@end

NS_ASSUME_NONNULL_END
