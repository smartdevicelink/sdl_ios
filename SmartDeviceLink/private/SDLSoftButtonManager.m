//
//  SDLSoftButtonManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLSoftButtonManager.h"

#import "SDLConnectionManagerType.h"
#import "SDLDisplayCapabilities.h"
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLGlobals.h"
#import "SDLLogMacros.h"
#import "SDLOnHMIStatus.h"
#import "SDLPredefinedWindows.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLShow.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonCapabilities.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonReplaceOperation.h"
#import "SDLSoftButtonState.h"
#import "SDLSoftButtonTransitionOperation.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLWindowCapability.h"
#import "SDLSystemCapability.h"
#import "SDLDisplayCapability.h"

NS_ASSUME_NONNULL_BEGIN

static const int SDLShowSoftButtonIDMin = 1;
static const int SDLShowSoftButtonIDCount = 8;

@interface SDLSoftButtonObject()

@property (assign, nonatomic) NSUInteger buttonId;
@property (weak, nonatomic) SDLSoftButtonManager *manager;

@end

@interface SDLSoftButtonManager()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (weak, nonatomic) SDLSystemCapabilityManager *systemCapabilityManager;
@property (assign, nonatomic, getter=isDynamicGraphicSupported) BOOL dynamicGraphicSupported;

@property (strong, nonatomic) NSOperationQueue *transactionQueue;

@property (strong, nonatomic, nullable) SDLSoftButtonCapabilities *softButtonCapabilities;
@property (copy, nonatomic, nullable) SDLHMILevel currentLevel;

@property (strong, nonatomic) NSMutableArray<SDLAsynchronousOperation *> *batchQueue;

@end

@implementation SDLSoftButtonManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _systemCapabilityManager = systemCapabilityManager;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    _dynamicGraphicSupported = systemCapabilityManager.displayCapabilities.graphicSupported ? systemCapabilityManager.displayCapabilities.graphicSupported.boolValue : YES;
#pragma clang diagnostic pop
    _softButtonObjects = @[];

    _currentLevel = nil;
    _transactionQueue = [self sdl_newTransactionQueue];
    _batchQueue = [NSMutableArray array];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiStatusNotification:) name:SDLDidChangeHMIStatusNotification object:nil];

    return self;
}

- (void)start {
    [self.systemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeDisplays withObserver:self selector:@selector(sdl_displayCapabilityDidUpdate)];
}

- (void)stop {
    _softButtonObjects = @[];
    _currentMainField1 = nil;
    _currentLevel = nil;
    _softButtonCapabilities = nil;

    [_transactionQueue cancelAllOperations];
    self.transactionQueue = [self sdl_newTransactionQueue];

    [self.systemCapabilityManager unsubscribeFromCapabilityType:SDLSystemCapabilityTypeDisplays withObserver:self];
}

- (NSOperationQueue *)sdl_newTransactionQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"SDLSoftButtonManager Transaction Queue";
    queue.maxConcurrentOperationCount = 1;
    queue.qualityOfService = NSQualityOfServiceUserInteractive;
    queue.underlyingQueue = [SDLGlobals sharedGlobals].sdlConcurrentQueue;
    queue.suspended = YES;

    return queue;
}

/// Suspend the queue if the soft button capabilities are nil (we assume that soft buttons are not supported)
/// OR if the HMI level is NONE since we want to delay sending RPCs until we're in non-NONE
- (void)sdl_updateTransactionQueueSuspended {
    if (self.softButtonCapabilities == nil || [self.currentLevel isEqualToEnum:SDLHMILevelNone]) {
        SDLLogD(@"Suspending the transaction queue. Current HMI level is NONE: %@, soft button capabilities are nil: %@", ([self.currentLevel isEqualToEnum:SDLHMILevelNone] ? @"YES" : @"NO"), (self.softButtonCapabilities == nil ? @"YES" : @"NO"));
        self.transactionQueue.suspended = YES;
    } else {
        SDLLogD(@"Starting the transaction queue");
        self.transactionQueue.suspended = NO;
    }
}


#pragma mark - Sending Soft Buttons

- (void)setSoftButtonObjects:(NSArray<SDLSoftButtonObject *> *)softButtonObjects {
    // Only update if something changed. This prevents, for example, an empty array being reset
    if (_softButtonObjects == softButtonObjects) {
        SDLLogD(@"New soft button objects are equivalent to existing soft button objects, skipping...");
        return;
    }

    // Set the soft button ids. The number of soft buttons is maxed at 8 according to the RPC spec. We will only send the first 8 soft buttons if more are set into the array.
    // Check to make sure no two soft buttons have the same name, there aren't many soft buttons, so n^2 isn't going to be bad
    NSUInteger softButtonCount = MIN(softButtonObjects.count, SDLShowSoftButtonIDCount);
    for (NSUInteger i = 0; i < softButtonCount; i++) {
        NSString *buttonName = softButtonObjects[i].name;
        // HAX: Due to a SYNC 3.0 bug (https://github.com/smartdevicelink/sdl_ios/issues/1793#issue-708356008), a `buttonId` can not be zero. As a workaround we will start the `buttonId`s from 1.
        // Offset the soft buttons based on the minimum ID number to prevent clashes with other managers.
        softButtonObjects[i].buttonId = i + SDLShowSoftButtonIDMin;
        for (NSUInteger j = (i + 1); j < softButtonCount; j++) {
            if ([softButtonObjects[j].name isEqualToString:buttonName]) {
                _softButtonObjects = @[];
                SDLLogE(@"Attempted to set soft button objects, but two buttons had the same name: %@", softButtonObjects);
                @throw [NSException sdl_duplicateSoftButtonsNameException];
            }
        }
    }

    for (SDLSoftButtonObject *button in softButtonObjects) {
        button.manager = self;
    }

    _softButtonObjects = softButtonObjects;

    // We only need to pass the first `softButtonCapabilities` in the array due to the fact that all soft button capabilities are the same (i.e. there is no way to assign a `softButtonCapabilities` to a specific soft button).
    SDLSoftButtonReplaceOperation *op = [[SDLSoftButtonReplaceOperation alloc] initWithConnectionManager:self.connectionManager fileManager:self.fileManager capabilities:self.softButtonCapabilities dynamicGraphicSupported:self.isDynamicGraphicSupported softButtonObjects:_softButtonObjects mainField1:self.currentMainField1];

    if (self.isBatchingUpdates) {
        [self.batchQueue removeAllObjects];
        [self.batchQueue addObject:op];
    } else {
        [self.transactionQueue cancelAllOperations];
        [self.transactionQueue addOperation:op];
    }
}

- (void)sdl_transitionSoftButton:(SDLSoftButtonObject *)softButton {
    SDLSoftButtonTransitionOperation *op = [[SDLSoftButtonTransitionOperation alloc] initWithConnectionManager:self.connectionManager capabilities:self.softButtonCapabilities softButtons:self.softButtonObjects mainField1:self.currentMainField1];

    if (self.isBatchingUpdates) {
        for (SDLAsynchronousOperation *sbOperation in self.batchQueue) {
            if ([sbOperation isMemberOfClass:[SDLSoftButtonTransitionOperation class]]) {
                [self.batchQueue removeObject:sbOperation];
            }
        }

        [self.batchQueue addObject:op];
    } else {
        [self.transactionQueue addOperation:op];
    }
}


#pragma mark - Getting Soft Buttons

- (nullable SDLSoftButtonObject *)softButtonObjectNamed:(NSString *)name {
    for (SDLSoftButtonObject *object in self.softButtonObjects) {
        if ([object.name isEqualToString:name]) {
            return object;
        }
    }

    return nil;
}


#pragma mark - Getters / Setters

- (void)setBatchUpdates:(BOOL)batchUpdates {
    _batchUpdates = batchUpdates;

    if (!_batchUpdates) {
        [self.transactionQueue addOperations:[self.batchQueue copy] waitUntilFinished:NO];
        [self.batchQueue removeAllObjects];
    }
}

- (void)setCurrentMainField1:(nullable NSString *)currentMainField1 {
    _currentMainField1 = currentMainField1;

    for (NSUInteger i = 0; i < self.transactionQueue.operations.count; i++) {
        if ([self.transactionQueue.operations[i] isMemberOfClass:[SDLSoftButtonReplaceOperation class]]) {
            SDLSoftButtonReplaceOperation *op = self.transactionQueue.operations[i];
            op.mainField1 = currentMainField1;
        } else if ([self.transactionQueue.operations[i] isMemberOfClass:[SDLSoftButtonTransitionOperation class]]) {
            SDLSoftButtonTransitionOperation *op = self.transactionQueue.operations[i];
            op.mainField1 = currentMainField1;
        }
    }
}

#pragma mark - Observers

- (void)sdl_displayCapabilityDidUpdate {
    SDLSoftButtonCapabilities *oldCapabilities = self.softButtonCapabilities;

    // Extract and update the capabilities
    SDLWindowCapability *currentWindowCapability = self.systemCapabilityManager.defaultMainWindowCapability;
    self.softButtonCapabilities = currentWindowCapability.softButtonCapabilities.firstObject;

    // Update the queue's suspend state
    [self sdl_updateTransactionQueueSuspended];

    // Auto-send an updated Show if we have new capabilities
    if (self.softButtonObjects.count > 0
        && self.softButtonCapabilities != nil
        && ![self.softButtonCapabilities isEqual:oldCapabilities]) {
        SDLSoftButtonReplaceOperation *op = [[SDLSoftButtonReplaceOperation alloc] initWithConnectionManager:self.connectionManager fileManager:self.fileManager capabilities:self.softButtonCapabilities dynamicGraphicSupported:self.isDynamicGraphicSupported softButtonObjects:self.softButtonObjects mainField1:self.currentMainField1];
        [self.transactionQueue addOperation:op];
    }
}

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus *)notification.notification;

    if (hmiStatus.windowID != nil && hmiStatus.windowID.integerValue != SDLPredefinedWindowsDefaultWindow) {
        return;
    }

    self.currentLevel = hmiStatus.hmiLevel;

    [self sdl_updateTransactionQueueSuspended];
}

@end

NS_ASSUME_NONNULL_END
