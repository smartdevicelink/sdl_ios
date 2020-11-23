//
//  SDLAlertManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 11/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLAlertManager.h"

#import "SDLAlertView.h"
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
@property (weak, nonatomic) SDLPermissionManager *permissionManager;

@property (copy, nonatomic, nullable) SDLWindowCapability *currentWindowCapability;
@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@property (copy, nonatomic) dispatch_queue_t readWriteQueue;
@property (assign, nonatomic) UInt16 nextCancelId;

@end

UInt16 const AlertCancelIdMin = 1;

@implementation SDLAlertManager

#pragma mark - Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager permissionManager:(SDLPermissionManager *)permissionManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _systemCapabilityManager = systemCapabilityManager;
    _permissionManager = permissionManager;

    _transactionQueue = [self sdl_newTransactionQueue];
    _readWriteQueue = dispatch_queue_create_with_target("com.sdl.screenManager.alertManager.readWriteQueue", DISPATCH_QUEUE_SERIAL, [SDLGlobals sharedGlobals].sdlProcessingQueue);
    _nextCancelId = AlertCancelIdMin;

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
    _nextCancelId = AlertCancelIdMin;

    [_transactionQueue cancelAllOperations];
    self.transactionQueue = [self sdl_newTransactionQueue];

    [self.systemCapabilityManager unsubscribeFromCapabilityType:SDLSystemCapabilityTypeDisplays withObserver:self];
}

- (void)presentAlert:(SDLAlertView *)alert withCompletionHandler:(nullable SDLAlertCompletionHandler)handler {
    SDLPresentAlertOperation *op = [[SDLPresentAlertOperation alloc] initWithConnectionManager:self.connectionManager fileManager:self.fileManager systemCapabilityManager:self.systemCapabilityManager currentWindowCapability:self.currentWindowCapability alertView:[alert copy] cancelID:self.nextCancelId];

    __weak typeof(op) weakPreloadOp = op;
    op.completionBlock = ^{
        SDLLogD(@"Alert finished preloading");

        if (handler != nil) {
            handler(weakPreloadOp.error);
        }
    };

    [self.transactionQueue addOperation:op];
}

- (NSOperationQueue *)sdl_newTransactionQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"SDLAlertManager Transaction Queue";
    queue.maxConcurrentOperationCount = 3;
    queue.qualityOfService = NSQualityOfServiceUserInitiated;
    queue.suspended = YES;

    return queue;
}

#pragma mark - Observers

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

- (void)sdl_subscribeToPermissions {
    SDLPermissionElement *alertPermissionElement = [[SDLPermissionElement alloc] initWithRPCName:SDLRPCFunctionNameAlert parameterPermissions:nil];
    [self.permissionManager subscribeToRPCPermissions:@[alertPermissionElement] groupType:SDLPermissionGroupTypeAny withHandler:^(NSDictionary<SDLRPCFunctionName,SDLRPCPermissionStatus *> * _Nonnull updatedPermissionStatuses, SDLPermissionGroupStatus status) {
        self.transactionQueue.suspended = (status != SDLPermissionGroupStatusAllowed);
    }];
}

#pragma mark - Getters

- (UInt16)nextCancelId {
    __block UInt16 cancelId = 0;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        cancelId = self->_nextCancelId;
        self->_nextCancelId = cancelId + 1;
    }];

    return cancelId;
}


@end

NS_ASSUME_NONNULL_END
