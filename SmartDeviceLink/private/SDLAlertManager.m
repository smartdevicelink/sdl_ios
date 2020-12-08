//
//  SDLAlertManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 11/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLAlertManager.h"

#import "SDLAlertView.h"
#import "SDLCancelIdManager.h"
#import "SDLDisplayCapability.h"
#import "SDLGlobals.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLPermissionManager.h"
#import "SDLPredefinedWindows.h"
#import "SDLPresentAlertOperation.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSystemCapability.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLWindowCapability.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLAlertManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (weak, nonatomic) SDLSystemCapabilityManager *systemCapabilityManager;
@property (weak, nonatomic, nullable) SDLPermissionManager *permissionManager;

@property (copy, nonatomic, nullable) SDLWindowCapability *currentWindowCapability;
@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@property (strong, nonatomic) SDLCancelIdManager *cancelIdManager;
@end

@implementation SDLAlertManager

#pragma mark - Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager permissionManager:(nullable SDLPermissionManager *)permissionManager cancelIdManager:(SDLCancelIdManager *)cancelIdManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _systemCapabilityManager = systemCapabilityManager;
    _permissionManager = permissionManager;
    _cancelIdManager = cancelIdManager;
    _transactionQueue = [self sdl_newTransactionQueue];

    [self sdl_subscribeToPermissions];

    return self;
}

- (void)start {
    SDLLogD(@"Starting manager");

    [self.systemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeDisplays withObserver:self selector:@selector(sdl_displayCapabilityDidUpdate:)];
}

- (void)stop {
    SDLLogD(@"Stopping manager");

    _currentWindowCapability = nil;

    [_transactionQueue cancelAllOperations];
    self.transactionQueue = [self sdl_newTransactionQueue];

    [self.systemCapabilityManager unsubscribeFromCapabilityType:SDLSystemCapabilityTypeDisplays withObserver:self];
}

- (void)presentAlert:(SDLAlertView *)alert withCompletionHandler:(nullable SDLAlertCompletionHandler)handler {
    SDLPresentAlertOperation *op = [[SDLPresentAlertOperation alloc] initWithConnectionManager:self.connectionManager fileManager:self.fileManager systemCapabilityManager:self.systemCapabilityManager currentWindowCapability:self.currentWindowCapability alertView:alert cancelID:self.cancelIdManager.nextCancelId];

    __weak typeof(op) weakPreloadOp = op;
    op.completionBlock = ^{
        SDLLogD(@"Alert finished preloading");

        if (handler != nil) {
            handler(weakPreloadOp.error);
        }
    };

    [self.transactionQueue addOperation:op];
}

/// Creates a new concurrent queue that can send multiple `Alert` RPCs without having to wait for the module to respond to the previous `Alert` request. The queue is initially suspended until the manager knows it can send the `Alert` RPCS without getting a disallowed response.
/// @return A concurrent operation queue
- (NSOperationQueue *)sdl_newTransactionQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"SDLAlertManager Transaction Queue";
    queue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
    queue.qualityOfService = NSQualityOfServiceUserInitiated;
    queue.suspended = YES;

    return queue;
}

#pragma mark - Observers

/// Called when the current window capabilities have updated.
/// @param systemCapability The new current window capabilities.
- (void)sdl_displayCapabilityDidUpdate:(SDLSystemCapability *)systemCapability {
    NSArray<SDLDisplayCapability *> *capabilities = systemCapability.displayCapabilities;
    SDLDisplayCapability *mainDisplay = capabilities[0];
    for (SDLWindowCapability *windowCapability in mainDisplay.windowCapabilities) {
        NSUInteger currentWindowID = windowCapability.windowID != nil ? windowCapability.windowID.unsignedIntegerValue : SDLPredefinedWindowsDefaultWindow;
        if (currentWindowID != SDLPredefinedWindowsDefaultWindow) { continue; }

        self.currentWindowCapability = windowCapability;
        break;
    }
}

/// Subscribes to permission updates for the `Alert` RPC. If the alert is not allowed at the current HMI level, the queue is suspended. Any `Alert` RPCs added while the queue is suspended will be sent when the `Alert` RPC is allowed at the current HMI level and the queue is unsuspended.
/// @discussion If there is no permission manager, the queue is not suspended and the `Alert` RPCs can be sent at any HMI level. This may mean that some requests are rejected due to invalid permissions.
- (void)sdl_subscribeToPermissions {
    if (self.permissionManager == nil) {
        self.transactionQueue.suspended = NO;
    } else {
        SDLPermissionElement *alertPermissionElement = [[SDLPermissionElement alloc] initWithRPCName:SDLRPCFunctionNameAlert parameterPermissions:nil];
        [self.permissionManager subscribeToRPCPermissions:@[alertPermissionElement] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> * _Nonnull updatedPermissionStatuses, SDLPermissionGroupStatus status) {

            self.transactionQueue.suspended = (status != SDLPermissionGroupStatusAllowed);
        }];
    }
}

@end

NS_ASSUME_NONNULL_END
