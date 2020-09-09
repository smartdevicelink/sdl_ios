//
//  SDLTextAndGraphicManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLTextAndGraphicManager.h"

#import "SDLArtwork.h"
#import "SDLConnectionManagerType.h"
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLImage.h"
#import "SDLLogMacros.h"
#import "SDLMetadataTags.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLPredefinedWindows.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLShow.h"
#import "SDLSystemCapability.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLTemplateConfiguration.h"
#import "SDLTextField.h"
#import "SDLTextAndGraphicUpdateOperation.h"
#import "SDLTextAndGraphicState.h"
#import "SDLWindowCapability.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLTextAndGraphicManager()

// Dependencies
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (weak, nonatomic) SDLSystemCapabilityManager *systemCapabilityManager;

/**
 A show describing the current text and images on the screen (not soft buttons, etc.)
 */
@property (strong, nonatomic) SDLShow *currentScreenData;

@property (strong, nonatomic) NSOperationQueue *transactionQueue;

@property (strong, nonatomic, nullable) SDLWindowCapability *windowCapability;
@property (strong, nonatomic, nullable) SDLHMILevel currentLevel;

@property (strong, nonatomic, nullable) SDLArtwork *blankArtwork;

@property (assign, nonatomic) BOOL waitingOnHMILevelUpdateToUpdate;
@property (assign, nonatomic) BOOL isDirty;

@end

@implementation SDLTextAndGraphicManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _systemCapabilityManager = systemCapabilityManager;
    _transactionQueue = [self sdl_newTransactionQueue];

    _alignment = SDLTextAlignmentCenter;

    _currentScreenData = [[SDLShow alloc] init];
    _currentLevel = SDLHMILevelNone;

    _waitingOnHMILevelUpdateToUpdate = NO;
    _isDirty = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiStatusNotification:) name:SDLDidChangeHMIStatusNotification object:nil];

    return self;
}

- (void)start {
    SDLLogD(@"Starting manager");

    // Make sure none of the properties were set after the manager was shut down
    [self sdl_reset];

    [self.systemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeDisplays withObserver:self selector:@selector(sdl_displayCapabilityDidUpdate:)];
}

- (void)stop {
    SDLLogD(@"Stopping manager");
    [self sdl_reset];

    [self.systemCapabilityManager unsubscribeFromCapabilityType:SDLSystemCapabilityTypeDisplays withObserver:self];
}

- (void)sdl_reset {
    SDLLogV(@"Resetting properties");
    _textField1 = nil;
    _textField2 = nil;
    _textField3 = nil;
    _textField4 = nil;
    _mediaTrackTextField = nil;
    _primaryGraphic = nil;
    _secondaryGraphic = nil;
    _alignment = SDLTextAlignmentCenter;
    _textField1Type = nil;
    _textField2Type = nil;
    _textField3Type = nil;
    _textField4Type = nil;

    _currentScreenData = [[SDLShow alloc] init];
    _transactionQueue = [self sdl_newTransactionQueue];
    _windowCapability = nil;
    _currentLevel = SDLHMILevelNone;
    _blankArtwork = nil;
    _waitingOnHMILevelUpdateToUpdate = NO;
    _isDirty = NO;
}

- (NSOperationQueue *)sdl_newTransactionQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"SDLTextAndGraphicManager Transaction Queue";
    queue.maxConcurrentOperationCount = 1;
    queue.qualityOfService = NSQualityOfServiceUserInitiated;
    queue.suspended = YES;

    return queue;
}

/// Suspend the queue if the window capabilities are nil (we assume that text and graphics are not supported yet)
/// OR if the HMI level is NONE since we want to delay sending RPCs until we're in non-NONE
- (void)sdl_updateTransactionQueueSuspended {
    if (self.windowCapability == nil || [self.currentLevel isEqualToEnum:SDLHMILevelNone]) {
        SDLLogD(@"Suspending the transaction queue. Current HMI level is NONE: %@, window capabilities are nil: %@", ([self.currentLevel isEqualToEnum:SDLHMILevelNone] ? @"YES" : @"NO"), (self.windowCapability == nil ? @"YES" : @"NO"));
        self.transactionQueue.suspended = YES;
    } else {
        SDLLogD(@"Starting the transaction queue");
        self.transactionQueue.suspended = NO;
    }
}

#pragma mark - Upload / Send

- (void)updateWithCompletionHandler:(nullable SDLTextAndGraphicUpdateCompletionHandler)handler {
    if (self.isBatchingUpdates) { return; }

    if (self.isDirty) {
        self.isDirty = NO;
        [self sdl_updateWithCompletionHandler:handler];
    }
}

- (void)sdl_updateWithCompletionHandler:(nullable SDLTextAndGraphicUpdateCompletionHandler)handler {
    SDLLogD(@"Updating text and graphics");
    if (self.transactionQueue.operationCount > 0) {
        SDLLogV(@"Transactions already exist, cancelling them");
        [self.transactionQueue cancelAllOperations];
    }

    __weak typeof(self) weakSelf = self;
    SDLTextAndGraphicUpdateOperation *updateOperation = [[SDLTextAndGraphicUpdateOperation alloc] initWithConnectionManager:self.connectionManager fileManager:self.fileManager currentCapabilities:self.windowCapability currentScreenData:self.currentScreenData newState:[self currentState] currentScreenDataUpdatedHandler:^(SDLShow * _Nonnull newScreenData) {
        weakSelf.currentScreenData = newScreenData;
        [weakSelf sdl_updatePendingOperationsWithNewScreenData:newScreenData];
    } updateCompletionHandler:handler];

    __weak typeof(updateOperation) weakOp = updateOperation;
    updateOperation.completionBlock = ^{
        if (weakOp.error != nil) {
            SDLLogE(@"Update operation failed with error: %@", weakOp.error);
        }
    };
    [self.transactionQueue addOperation:updateOperation];
}

- (void)sdl_updatePendingOperationsWithNewScreenData:(SDLShow *)newScreenData {
    for (NSOperation *operation in self.transactionQueue.operations) {
        if (![operation isMemberOfClass:SDLTextAndGraphicUpdateOperation.class] || operation.isExecuting) { continue; }
        SDLTextAndGraphicUpdateOperation *updateOp = (SDLTextAndGraphicUpdateOperation *)operation;

        updateOp.currentScreenData = newScreenData;
    }
}

#pragma mark - Change Layout

- (void)changeLayout:(SDLTemplateConfiguration *)templateConfiguration withCompletionHandler:(nullable SDLTextAndGraphicUpdateCompletionHandler)handler {
    self.templateConfiguration = templateConfiguration;

    [self updateWithCompletionHandler:handler];
}

#pragma mark - Convert to State

- (SDLTextAndGraphicState *)currentState {
    return [[SDLTextAndGraphicState alloc] initWithTextField1:_textField1 textField2:_textField2 textField3:_textField3 textField4:_textField4 mediaText:_mediaTrackTextField title:_title primaryGraphic:_primaryGraphic secondaryGraphic:_secondaryGraphic alignment:_alignment textField1Type:_textField1Type textField2Type:_textField2Type textField3Type:_textField3Type textField4Type:_textField4Type templateConfiguration:_templateConfiguration];
}

#pragma mark - Helpers

- (NSArray<NSString *> *)sdl_findNonNilTextFields {
    NSMutableArray *array = [NSMutableArray array];
    (self.textField1.length > 0) ? [array addObject:self.textField1] : nil;
    (self.textField2.length > 0) ? [array addObject:self.textField2] : nil;
    (self.textField3.length > 0) ? [array addObject:self.textField3] : nil;
    (self.textField4.length > 0) ? [array addObject:self.textField4] : nil;

    return [array copy];
}

- (BOOL)sdl_hasData {
    BOOL hasTextFields = ([self sdl_findNonNilTextFields].count > 0) || (self.title.length > 0) || (self.mediaTrackTextField.length > 0);
    BOOL hasImageFields = (self.primaryGraphic != nil) || (self.secondaryGraphic != nil);

    return hasTextFields || hasImageFields;
}

#pragma mark - Getters / Setters

- (void)setTextField1:(nullable NSString *)textField1 {
    _textField1 = textField1;
    _isDirty = YES;
    if (!self.isBatchingUpdates) {
        // If we aren't batching, send the update immediately, if we are, set ourselves as dirty (so we know we should send an update after the batch ends)
        [self updateWithCompletionHandler:nil];
    }
}

- (void)setTextField2:(nullable NSString *)textField2 {
    _textField2 = textField2;
    _isDirty = YES;
    if (!self.isBatchingUpdates) {
        [self updateWithCompletionHandler:nil];
    }
}

- (void)setTextField3:(nullable NSString *)textField3 {
    _textField3 = textField3;
    _isDirty = YES;
    if (!self.isBatchingUpdates) {
        [self updateWithCompletionHandler:nil];
    }
}

- (void)setTextField4:(nullable NSString *)textField4 {
    _textField4 = textField4;
    _isDirty = YES;
    if (!self.isBatchingUpdates) {
        [self updateWithCompletionHandler:nil];
    }
}

- (void)setMediaTrackTextField:(nullable NSString *)mediaTrackTextField {
    _mediaTrackTextField = mediaTrackTextField;
    _isDirty = YES;
    if (!self.isBatchingUpdates) {
        [self updateWithCompletionHandler:nil];
    }
}

- (void)setTitle:(nullable NSString *)title {
    _title = title;
    _isDirty = YES;
    if (!self.isBatchingUpdates) {
        [self updateWithCompletionHandler:nil];
    }
}

- (void)setPrimaryGraphic:(nullable SDLArtwork *)primaryGraphic {
    _primaryGraphic = primaryGraphic;
    _isDirty = YES;
    if (!self.isBatchingUpdates) {
        [self updateWithCompletionHandler:nil];
    }
}

- (void)setSecondaryGraphic:(nullable SDLArtwork *)secondaryGraphic {
    _secondaryGraphic = secondaryGraphic;
    _isDirty = YES;
    if (!self.isBatchingUpdates) {
        [self updateWithCompletionHandler:nil];
    }
}

- (void)setAlignment:(nullable SDLTextAlignment)alignment {
    _alignment = alignment ? alignment : SDLTextAlignmentCenter;
    _isDirty = YES;
    if (!self.isBatchingUpdates) {
        [self updateWithCompletionHandler:nil];
    }
}

- (void)setTextField1Type:(nullable SDLMetadataType)textField1Type {
    _textField1Type = textField1Type;
    _isDirty = YES;
    if (!self.isBatchingUpdates) {
        [self updateWithCompletionHandler:nil];
    }
}

- (void)setTextField2Type:(nullable SDLMetadataType)textField2Type {
    _textField2Type = textField2Type;
    _isDirty = YES;
    if (!self.isBatchingUpdates) {
        [self updateWithCompletionHandler:nil];
    }
}

- (void)setTextField3Type:(nullable SDLMetadataType)textField3Type {
    _textField3Type = textField3Type;
    _isDirty = YES;
    if (!self.isBatchingUpdates) {
        [self updateWithCompletionHandler:nil];
    }
}

- (void)setTextField4Type:(nullable SDLMetadataType)textField4Type {
    _textField4Type = textField4Type;
    _isDirty = YES;
    if (!self.isBatchingUpdates) {
        [self updateWithCompletionHandler:nil];
    }
}

- (void)setTemplateConfiguration:(SDLTemplateConfiguration *)templateConfiguration {
    _templateConfiguration = templateConfiguration;
    _isDirty = YES;
    // Don't do the `isBatchingUpdates` like elsewhere because the call is already handled in `changeLayout:withCompletionHandler:`
}

- (nullable SDLArtwork *)blankArtwork {
    if (_blankArtwork != nil) {
        return _blankArtwork;
    }

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(5, 5), NO, 0.0);
    UIImage *blankImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    _blankArtwork = [SDLArtwork artworkWithImage:blankImage name:@"sdl_BlankArt" asImageFormat:SDLArtworkImageFormatPNG];

    return _blankArtwork;
}

#pragma mark - Subscribed notifications

- (void)sdl_displayCapabilityDidUpdate:(SDLSystemCapability *)systemCapability {
    // Check if the window capability is equal to the one we already have. If it is, abort.
    if ([self.windowCapability isEqual:self.systemCapabilityManager.defaultMainWindowCapability]) { return; }

    // We won't use the object in the parameter but the convenience method of the system capability manager
    self.windowCapability = self.systemCapabilityManager.defaultMainWindowCapability;
    [self sdl_updateTransactionQueueSuspended];
    
    // Auto-send an updated show
    if ([self sdl_hasData]) {
        [self sdl_updateWithCompletionHandler:nil];
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
