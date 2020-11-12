//
//  SDLAlertManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 11/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLAlertManager.h"

#import "SDLDisplayCapability.h"
#import "SDLGlobals.h"
#import "SDLLogMacros.h"
#import "SDLPermissionManager.h"
#import "SDLPredefinedWindows.h"
#import "SDLPresentAlertOperation.h"
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

@end

@implementation SDLAlertManager

#pragma mark - Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager permissionManager:(SDLPermissionManager *)permissionManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _systemCapabilityManager = systemCapabilityManager;
    _permissionManager = permissionManager;

    return self;
}

- (void)start {
    SDLLogD(@"Starting manager");

    [self.systemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeDisplays withObserver:self selector:@selector(sdl_displayCapabilityDidUpdate:)];
}

- (void)stop {
    SDLLogD(@"Stopping manager");
}

- (void)presentAlert:(SDLAlertView *)alert withCompletionHandler:(nullable SDLAlertCompletionHandler)handler {
    // TODO: upload alert icon image, alert sound file, soft button images.
}

- (NSOperationQueue *)sdl_newTransactionQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"SDLAlertManager Transaction Queue";
    queue.maxConcurrentOperationCount = 3;
    queue.qualityOfService = NSQualityOfServiceUserInitiated;
    queue.suspended = YES;

    return queue;
}

#pragma mark - RPC Responses / Notifications

- (void)sdl_displayCapabilityDidUpdate:(SDLSystemCapability *)systemCapability {
    NSArray<SDLDisplayCapability *> *capabilities = systemCapability.displayCapabilities;
    if (capabilities == nil || capabilities.count == 0) {
        self.currentWindowCapability = nil;
    } else {
        SDLDisplayCapability *mainDisplay = capabilities[0];
        for (SDLWindowCapability *windowCapability in mainDisplay.windowCapabilities) {
            NSUInteger currentWindowID = windowCapability.windowID != nil ? windowCapability.windowID.unsignedIntegerValue : SDLPredefinedWindowsDefaultWindow;
            if (currentWindowID != SDLPredefinedWindowsDefaultWindow) { continue; }

            self.currentWindowCapability = windowCapability;
            break;
        }
    }

    // [self sdl_updateTransactionQueueSuspended];
}

@end

NS_ASSUME_NONNULL_END
