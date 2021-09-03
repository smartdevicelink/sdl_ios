//
//  SDLPreloadChoicesOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLPreloadPresentChoicesOperation.h"

#import "SDLCancelInteraction.h"
#import "SDLChoice.h"
#import "SDLChoiceCell.h"
#import "SDLChoiceSet.h"
#import "SDLChoiceSetDelegate.h"
#import "SDLConnectionManagerType.h"
#import "SDLCreateInteractionChoiceSet.h"
#import "SDLCreateInteractionChoiceSetResponse.h"
#import "SDLDisplayType.h"
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLGlobals.h"
#import "SDLImage.h"
#import "SDLKeyboardProperties.h"
#import "SDLLogMacros.h"
#import "SDLOnKeyboardInput.h"
#import "SDLPreloadPresentChoicesOperationUtilities.h"
#import "SDLPerformInteraction.h"
#import "SDLPerformInteractionResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSetGlobalProperties.h"
#import "SDLVersion.h"
#import "SDLWindowCapability.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SDLPreloadPresentChoicesOperationState) {
    SDLPreloadPresentChoicesOperationStateNotStarted,
    SDLPreloadPresentChoicesOperationStateUploadingImages,
    SDLPreloadPresentChoicesOperationStateUploadingChoices,
    SDLPreloadPresentChoicesOperationStateUpdatingKeyboardProperties,
    SDLPreloadPresentChoicesOperationStatePresentingChoices,
    SDLPreloadPresentChoicesOperationStateCancellingPresentChoices,
    SDLPreloadPresentChoicesOperationStateResettingKeyboardProperties,
    SDLPreloadPresentChoicesOperationStateFinishing
};

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;
@property (copy, nonatomic, readwrite, nullable) NSString *secondaryText;
@property (copy, nonatomic, readwrite, nullable) NSString *tertiaryText;
@property (copy, nonatomic, readwrite, nullable) NSArray<NSString *> *voiceCommands;
@property (strong, nonatomic, readwrite, nullable) SDLArtwork *artwork;
@property (strong, nonatomic, readwrite, nullable) SDLArtwork *secondaryArtwork;

@property (assign, nonatomic) NSUInteger uniqueTextId;

@end

@interface SDLChoiceSet()

@property (copy, nonatomic) SDLChoiceSetCanceledHandler canceledHandler;

@end

@interface SDLPreloadPresentChoicesOperation()

// Dependencies
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (strong, nonatomic) SDLWindowCapability *windowCapability;

// Preload Dependencies
@property (strong, nonatomic) NSMutableOrderedSet<SDLChoiceCell *> *cellsToUpload;
@property (strong, nonatomic) NSString *displayName;
@property (assign, nonatomic, getter=isVROptional) BOOL vrOptional;
@property (copy, nonatomic) SDLUploadChoicesCompletionHandler preloadCompletionHandler;

// Present Dependencies
@property (strong, nonatomic) SDLChoiceSet *choiceSet;
@property (strong, nonatomic, nullable) SDLInteractionMode presentationMode;
@property (strong, nonatomic, nullable) SDLKeyboardProperties *originalKeyboardProperties;
@property (strong, nonatomic, nullable) SDLKeyboardProperties *customKeyboardProperties;
@property (weak, nonatomic, nullable) id<SDLKeyboardDelegate> keyboardDelegate;
@property (assign, nonatomic) UInt16 cancelId;

// Internal operation properties
@property (assign, nonatomic) SDLPreloadPresentChoicesOperationState currentState;
@property (strong, nonatomic) NSUUID *operationId;
@property (copy, nonatomic, nullable) NSError *internalError;

// Mutable state
@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *mutableLoadedCells;

// Present completion handler properties
@property (strong, nonatomic, nullable) SDLChoiceCell *selectedCell;
@property (strong, nonatomic, nullable) SDLTriggerSource selectedTriggerSource;
@property (assign, nonatomic) NSUInteger selectedCellRow;

@end

@implementation SDLPreloadPresentChoicesOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager displayName:(NSString *)displayName windowCapability:(SDLWindowCapability *)windowCapability isVROptional:(BOOL)isVROptional cellsToPreload:(NSArray<SDLChoiceCell *> *)cellsToPreload loadedCells:(NSSet<SDLChoiceCell *> *)loadedCells preloadCompletionHandler:(SDLUploadChoicesCompletionHandler)preloadCompletionHandler {
    self = [super init];
    if (!self) { return nil; }

    _currentState = SDLPreloadPresentChoicesOperationStateNotStarted;
    _operationId = [NSUUID UUID];

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _cancelId = UINT16_MAX;
    _displayName = displayName;
    _windowCapability = windowCapability;
    _vrOptional = isVROptional;

    _cellsToUpload = [NSMutableOrderedSet orderedSetWithArray:cellsToPreload];
    _mutableLoadedCells = [loadedCells mutableCopy];
    _preloadCompletionHandler = preloadCompletionHandler;

    return self;
}

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager choiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode keyboardProperties:(nullable SDLKeyboardProperties *)originalKeyboardProperties keyboardDelegate:(nullable id<SDLKeyboardDelegate>)keyboardDelegate cancelID:(UInt16)cancelID displayName:(NSString *)displayName windowCapability:(SDLWindowCapability *)windowCapability isVROptional:(BOOL)isVROptional loadedCells:(NSSet<SDLChoiceCell *> *)loadedCells preloadCompletionHandler:(SDLUploadChoicesCompletionHandler)preloadCompletionHandler {
    self = [super init];
    if (!self) { return nil; }

    _currentState = SDLPreloadPresentChoicesOperationStateNotStarted;
    _operationId = [NSUUID UUID];

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _choiceSet = choiceSet;
    _presentationMode = mode;

    __weak typeof(self) weakSelf = self;
    _choiceSet.canceledHandler = ^{
        [weakSelf sdl_cancelInteraction];
    };

    _originalKeyboardProperties = originalKeyboardProperties;
    _customKeyboardProperties = originalKeyboardProperties;
    _keyboardDelegate = keyboardDelegate;
    _cancelId = cancelID;

    _displayName = displayName;
    _windowCapability = windowCapability;
    _vrOptional = isVROptional;
    _mutableLoadedCells = [loadedCells mutableCopy];
    _cellsToUpload = [NSMutableOrderedSet orderedSetWithArray:choiceSet.choices];
    _preloadCompletionHandler = preloadCompletionHandler;

    _selectedCellRow = NSNotFound;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    // If we have no loaded cells, reset choice ids to ensure reconnections restart numbering
    if (self.loadedCells.count == 0) {
        SDLPreloadPresentChoicesOperationUtilities.choiceId = 0;
        SDLPreloadPresentChoicesOperationUtilities.reachedMaxId = NO;
    }

    // Remove cells that are already loaded so that we don't try to re-upload them
    [self.cellsToUpload minusSet:self.loadedCells];

    // If loaded cells is full and we need to upload cells, just fail the operation since we can't successfully upload or present
    if ((self.loadedCells.count == UINT16_MAX) && (self.cellsToUpload.count > 0)) {
        return [self finishOperation:[NSError sdl_choiceSetManager_noIdsAvailable]];
    }

    // Assign Ids, then make cells to upload unique so that they upload properly (if necessary)
    [SDLPreloadPresentChoicesOperationUtilities assignIdsToCells:self.cellsToUpload loadedCells:self.loadedCells];
    [SDLPreloadPresentChoicesOperationUtilities makeCellsToUploadUnique:self.cellsToUpload basedOnLoadedCells:self.mutableLoadedCells windowCapability:self.windowCapability];

    // If we have a choice set, we need to replace the choices with the cells that we're uploading (with new ids and unique text) and the cells that are already on the head unit (with the correct cell ids and unique text)
    if (self.choiceSet != nil) {
        [SDLPreloadPresentChoicesOperationUtilities updateChoiceSet:self.choiceSet withLoadedCells:self.loadedCells cellsToUpload:self.cellsToUpload.set];
    }

    // Start uploading cell artworks, then cells themselves, then determine if we want to present, then update keyboard properties if necessary, then present the choice set, then revert keyboard properties if necessary
    [self sdl_uploadCellArtworksWithCompletionHandler:^(NSError * _Nullable uploadArtError) {
        // If some artworks failed to upload, we are still going to try to load the cells
        if (self.isCancelled || uploadArtError != nil) { return [self finishOperation:uploadArtError]; }

        [self sdl_uploadCellsWithCompletionHandler:^(NSError * _Nullable uploadCellsError) {
            // If this operation has been cancelled or if there was an error with loading the cells, we don't want to present, so we'll end the operation
            if (self.isCancelled || uploadCellsError != nil) { return [self finishOperation:uploadCellsError]; }

            // If necessary, present the choice set
            if (self.choiceSet == nil) { return [self finishOperation]; }
            [self sdl_updateKeyboardPropertiesWithCompletionHandler:^(NSError * _Nullable updateKeyboardPropertiesError) {
                if (self.isCancelled || updateKeyboardPropertiesError != nil) { return [self finishOperation]; }

                [self sdl_presentChoiceSetWithCompletionHandler:^(NSError * _Nullable presentError) {
                    [self sdl_resetKeyboardPropertiesWithCompletionHandler:^(NSError * _Nullable resetKeyboardPropertiesError) {
                        if (presentError != nil) { return [self finishOperation:presentError]; }
                        return [self finishOperation:resetKeyboardPropertiesError];
                    }];
                }];
            }];
        }];
    }];
}

#pragma mark - Getters / Setters

- (void)setLoadedCells:(NSSet<SDLChoiceCell *> *)loadedCells {
    _mutableLoadedCells = [loadedCells mutableCopy];
}

- (NSSet<SDLChoiceCell *> *)loadedCells {
    return [_mutableLoadedCells copy];
}

#pragma mark - Uploading Choice Data

- (void)sdl_uploadCellArtworksWithCompletionHandler:(void(^)(NSError *_Nullable error))completionHandler {
    self.currentState = SDLPreloadPresentChoicesOperationStateUploadingImages;

    NSMutableArray<SDLArtwork *> *artworksToUpload = [NSMutableArray arrayWithCapacity:self.cellsToUpload.count];
    for (SDLChoiceCell *cell in self.cellsToUpload) {
        if ([self.class sdl_shouldSendChoicePrimaryImageBasedOnWindowCapability:self.windowCapability] && [self.fileManager fileNeedsUpload:cell.artwork]) {
            [artworksToUpload addObject:cell.artwork];
        }
        if ([self.class sdl_shouldSendChoiceSecondaryImageBasedOnWindowCapability:self.windowCapability] && [self.fileManager fileNeedsUpload:cell.secondaryArtwork]) {
            [artworksToUpload addObject:cell.secondaryArtwork];
        }
    }

    if (artworksToUpload.count == 0) {
        SDLLogD(@"No choice artworks to be uploaded");
        return completionHandler(nil);
    }

    [self.fileManager uploadArtworks:[artworksToUpload copy] completionHandler:^(NSArray<NSString *> * _Nonnull artworkNames, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Error uploading choice artworks: %@", error);
        } else {
            SDLLogD(@"Finished uploading choice artworks");
            SDLLogV(@"%@", artworkNames);
        }

        completionHandler(error);
    }];
}

- (void)sdl_uploadCellsWithCompletionHandler:(void(^)(NSError *_Nullable error))completionHandler {
    self.currentState = SDLPreloadPresentChoicesOperationStateUploadingChoices;
    if (self.cellsToUpload.count == 0) { return completionHandler(nil); }

    NSMutableArray<SDLCreateInteractionChoiceSet *> *choiceRPCs = [NSMutableArray arrayWithCapacity:self.cellsToUpload.count];
    for (SDLChoiceCell *cell in self.cellsToUpload) {
        SDLCreateInteractionChoiceSet *csCell =  [self.class sdl_choiceFromCell:cell windowCapability:self.windowCapability displayName:self.displayName isVROptional:self.isVROptional];
        if (csCell != nil) {
            [choiceRPCs addObject:csCell];
        }
    }
    if (choiceRPCs.count == 0) {
        SDLLogE(@"All choice cells to send are nil, so the choice set will not be shown");
        return completionHandler([NSError sdl_choiceSetManager_failedToCreateMenuItems]);
    }
    
    __weak typeof(self) weakSelf = self;
    __block NSMutableDictionary<SDLRPCRequest *, NSError *> *errors = [NSMutableDictionary dictionary];
    [self.connectionManager sendRequests:[choiceRPCs copy] progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
        SDLCreateInteractionChoiceSet *sentRequest = (SDLCreateInteractionChoiceSet *)request;
        if (error != nil) {
            errors[request] = error;
        } else {
            [weakSelf.mutableLoadedCells addObject:[self sdl_cellFromChoiceId:(UInt16)sentRequest.interactionChoiceSetID.unsignedIntValue]];
        }
    } completionHandler:^(BOOL success) {
        NSError *preloadError = nil;
        if (!success) {
            SDLLogE(@"Error preloading choice cells: %@", errors);
            preloadError = [NSError sdl_choiceSetManager_choiceUploadFailed:errors];
        }

        SDLLogD(@"Finished preloading choice cells");

        return completionHandler(preloadError);
    }];
}

#pragma mark - Presenting Choice Set

#pragma mark Updating Keyboard Properties

- (void)sdl_updateKeyboardPropertiesWithCompletionHandler:(void(^)(NSError *_Nullable))completionHandler {
    self.currentState = SDLPreloadPresentChoicesOperationStateUpdatingKeyboardProperties;
    if (self.keyboardDelegate == nil) { return completionHandler(nil); }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_keyboardInputNotification:) name:SDLDidReceiveKeyboardInputNotification object:nil];

    // Check if we're using a keyboard (searchable) choice set and setup keyboard properties if we need to
    if (self.keyboardDelegate != nil && [self.keyboardDelegate respondsToSelector:@selector(customKeyboardConfiguration)]) {
        SDLKeyboardProperties *customProperties = self.keyboardDelegate.customKeyboardConfiguration;
        if (customProperties != nil) {
            self.customKeyboardProperties = customProperties;
        }
    }

    // Create the keyboard configuration based on the window capability's keyboard capabilities
    SDLKeyboardProperties *modifiedKeyboardConfig = [self.windowCapability createValidKeyboardConfigurationBasedOnKeyboardCapabilitiesFromConfiguration:self.customKeyboardProperties];
    if (modifiedKeyboardConfig == nil) { return completionHandler(nil); }

    SDLSetGlobalProperties *setProperties = [[SDLSetGlobalProperties alloc] init];
    setProperties.keyboardProperties = modifiedKeyboardConfig;

    [self.connectionManager sendConnectionRequest:setProperties withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Error setting keyboard properties to new value: %@, with error: %@", request, error);
        }

        return completionHandler(error);
    }];
}

- (void)sdl_resetKeyboardPropertiesWithCompletionHandler:(void(^)(NSError *_Nullable))completionHandler {
    self.currentState = SDLPreloadPresentChoicesOperationStateResettingKeyboardProperties;
    if (self.keyboardDelegate == nil || self.originalKeyboardProperties == nil) { return completionHandler(nil); }

    SDLSetGlobalProperties *setProperties = [[SDLSetGlobalProperties alloc] init];
    setProperties.keyboardProperties = self.originalKeyboardProperties;

    [self.connectionManager sendConnectionRequest:setProperties withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Error resetting keyboard properties to values: %@, with error: %@", request, error);
        }

        completionHandler(error);
    }];
}

#pragma mark Present

- (void)sdl_presentChoiceSetWithCompletionHandler:(void(^)(NSError *_Nullable error))completionHandler {
    self.currentState = SDLPreloadPresentChoicesOperationStatePresentingChoices;

    __weak typeof(self) weakself = self;
    [self.connectionManager sendConnectionRequest:[self sdl_performInteractionFromChoiceSet] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Presenting choice set request: %@, failed with response: %@, error: %@", request, response, error);
            return completionHandler(error);
        }

        SDLPerformInteractionResponse *performResponse = response;
        [weakself sdl_setSelectedCellWithId:performResponse.choiceID];
        weakself.selectedTriggerSource = performResponse.triggerSource;

        return completionHandler(error);
    }];
}

#pragma mark Cancel

/**
 * Cancels the choice set. If the choice set has not yet been sent to Core, it will not be sent. If the choice set is already presented on Core, the choice set will be immediately dismissed. Canceling an already presented choice set will only work if connected to Core versions 6.0+. On older versions of Core, the choice set will not be dismissed.
 */
- (void)sdl_cancelInteraction {
    if (self.isFinished) {
        SDLLogW(@"This operation has already finished so it can not be canceled.");
        return;
    } else if (self.isCancelled) {
        SDLLogW(@"This operation has already been canceled. It will be finished at some point during the operation.");
        return;
    } else if (self.isExecuting) {
        if (self.currentState != SDLPreloadPresentChoicesOperationStatePresentingChoices) {
            SDLLogD(@"Canceling the operation before a present.");
            return [self cancel];
        } else if ([SDLGlobals.sharedGlobals.rpcVersion isLessThanVersion:[[SDLVersion alloc] initWithMajor:6 minor:0 patch:0]]) {
            SDLLogW(@"Canceling a currently displaying choice set is not supported on this head unit. Trying to cancel the operation.");
            return [self cancel];
        }

        self.currentState = SDLPreloadPresentChoicesOperationStateCancellingPresentChoices;
        SDLLogD(@"Canceling the presented choice set interaction");

        __weak typeof(self) weakSelf = self;
        SDLCancelInteraction *cancelInteraction = [[SDLCancelInteraction alloc] initWithPerformInteractionCancelID:self.cancelId];
        [self.connectionManager sendConnectionRequest:cancelInteraction withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (error != nil) {
                weakSelf.internalError = error;
                SDLLogE(@"Error canceling the presented choice set: %@, with error: %@", request, error);
                return;
            }
            SDLLogD(@"The presented choice set was canceled successfully");
        }];
    } else {
        SDLLogD(@"Canceling a choice set that has not yet been sent to Core");
        [self cancel];
    }
}

#pragma mark Present Helpers

- (void)sdl_setSelectedCellWithId:(NSNumber<SDLInt> *)cellId {
    for (NSUInteger i = 0; i < self.choiceSet.choices.count; i++) {
        SDLChoiceCell *thisCell = self.choiceSet.choices[i];
        if (thisCell.choiceId == cellId.unsignedIntValue) {
            self.selectedCell = thisCell;
            self.selectedCellRow = i;
            break;
        }
    }
}

- (SDLPerformInteraction *)sdl_performInteractionFromChoiceSet {
    NSParameterAssert(self.choiceSet != nil);

    SDLLayoutMode layoutMode = nil;
    switch (self.choiceSet.layout) {
        case SDLChoiceSetLayoutList:
            layoutMode = self.keyboardDelegate ? SDLLayoutModeListWithSearch : SDLLayoutModeListOnly;
            break;
        case SDLChoiceSetLayoutTiles:
            layoutMode = self.keyboardDelegate ? SDLLayoutModeIconWithSearch : SDLLayoutModeIconOnly;
            break;
    }

    NSMutableArray<NSNumber<SDLInt> *> *choiceIds = [NSMutableArray arrayWithCapacity:self.choiceSet.choices.count];
    for (SDLChoiceCell *cell in self.choiceSet.choices) {
        [choiceIds addObject:@(cell.choiceId)];
    }

    SDLPerformInteraction *performInteraction = [[SDLPerformInteraction alloc] init];
    performInteraction.interactionMode = self.presentationMode;
    performInteraction.initialText = self.choiceSet.title;
    performInteraction.initialPrompt = self.choiceSet.initialPrompt;
    performInteraction.helpPrompt = self.choiceSet.helpPrompt;
    performInteraction.timeoutPrompt = self.choiceSet.timeoutPrompt;
    performInteraction.vrHelp = self.choiceSet.helpList;
    performInteraction.timeout = @((NSUInteger)(self.choiceSet.timeout * 1000));
    performInteraction.interactionLayout = layoutMode;
    performInteraction.interactionChoiceSetIDList = [choiceIds copy];
    performInteraction.cancelID = @(self.cancelId);

    return performInteraction;
}

#pragma mark Finding Cells

- (nullable SDLChoiceCell *)sdl_cellFromChoiceId:(UInt16)choiceId {
    for (SDLChoiceCell *cell in self.cellsToUpload) {
        if (cell.choiceId == choiceId) { return cell; }
    }

    return nil;
}

#pragma mark - Assembling Choice RPCs

+ (nullable SDLCreateInteractionChoiceSet *)sdl_choiceFromCell:(SDLChoiceCell *)cell windowCapability:(SDLWindowCapability *)windowCapability displayName:(NSString *)displayName isVROptional:(BOOL)isVROptional {
    NSArray<NSString *> *vrCommands = nil;
    if (cell.voiceCommands == nil) {
        vrCommands = isVROptional ? nil : @[[NSString stringWithFormat:@"%hu", cell.choiceId]];
    } else {
        vrCommands = cell.voiceCommands;
    }

    NSString *menuName = nil;
    if ([self sdl_shouldSendChoiceTextBasedOnWindowCapability:windowCapability displayName:displayName]) {
        menuName = cell.uniqueText;
    }

    if (menuName == nil) {
        SDLLogE(@"Could not convert SDLChoiceCell to SDLCreateInteractionChoiceSet because there was no menu name. This could be because the head unit does not support text field 'menuName', which means it does not support Choice Sets. It will not be shown. Cell: %@", cell);
        return nil;
    }
    
    NSString *secondaryText = [self sdl_shouldSendChoiceSecondaryTextBasedOnWindowCapability:windowCapability] ? cell.secondaryText : nil;
    NSString *tertiaryText = [self sdl_shouldSendChoiceTertiaryTextBasedOnWindowCapability:windowCapability] ? cell.tertiaryText : nil;

    SDLImage *image = [self sdl_shouldSendChoicePrimaryImageBasedOnWindowCapability:windowCapability] ? cell.artwork.imageRPC : nil;
    SDLImage *secondaryImage = [self sdl_shouldSendChoiceSecondaryImageBasedOnWindowCapability:windowCapability] ? cell.secondaryArtwork.imageRPC : nil;

    SDLChoice *choice = [[SDLChoice alloc] initWithId:cell.choiceId menuName:menuName vrCommands:vrCommands image:image secondaryText:secondaryText secondaryImage:secondaryImage tertiaryText:tertiaryText];

    return [[SDLCreateInteractionChoiceSet alloc] initWithId:(UInt32)choice.choiceID.unsignedIntValue choiceSet:@[choice]];
}

/// Determine if we should send primary text. If textFields is nil, we don't know the capabilities and we will send everything.
+ (BOOL)sdl_shouldSendChoiceTextBasedOnWindowCapability:(SDLWindowCapability *)windowCapability displayName:(NSString *)displayName {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ([displayName isEqualToString:SDLDisplayTypeGen38Inch]) {
        return YES;
    }
#pragma clang diagnostic pop

    return [windowCapability hasTextFieldOfName:SDLTextFieldNameMenuName];
}

/// Determine if we should send secondary text. If textFields is nil, we don't know the capabilities and we will send everything.
+ (BOOL)sdl_shouldSendChoiceSecondaryTextBasedOnWindowCapability:(SDLWindowCapability *)windowCapability {
    return [windowCapability hasTextFieldOfName:SDLTextFieldNameSecondaryText];
}

/// Determine if we should send tertiary text. If textFields is nil, we don't know the capabilities and we will send everything.
+ (BOOL)sdl_shouldSendChoiceTertiaryTextBasedOnWindowCapability:(SDLWindowCapability *)windowCapability {
    return [windowCapability hasTextFieldOfName:SDLTextFieldNameTertiaryText];
}

/// Determine if we should send the primary image. If imageFields is nil, we don't know the capabilities and we will send everything.
+ (BOOL)sdl_shouldSendChoicePrimaryImageBasedOnWindowCapability:(SDLWindowCapability *)windowCapability {
    return [windowCapability hasImageFieldOfName:SDLImageFieldNameChoiceImage];
}

/// Determine if we should send the secondary image. If imageFields is nil, we don't know the capabilities and we will send everything.
+ (BOOL)sdl_shouldSendChoiceSecondaryImageBasedOnWindowCapability:(SDLWindowCapability *)windowCapability {
    return [windowCapability hasImageFieldOfName:SDLImageFieldNameChoiceSecondaryImage];
}

#pragma mark - SDL Notifications

- (void)sdl_keyboardInputNotification:(SDLRPCNotificationNotification *)notification {
    if (self.isCancelled) { return [self finishOperation]; }

    if (self.keyboardDelegate == nil) { return; }
    SDLOnKeyboardInput *onKeyboard = notification.notification;

    if ([self.keyboardDelegate respondsToSelector:@selector(keyboardDidSendEvent:text:)]) {
        [self.keyboardDelegate keyboardDidSendEvent:onKeyboard.event text:onKeyboard.data];
    }

    __weak typeof(self) weakself = self;
    if ([onKeyboard.event isEqualToEnum:SDLKeyboardEventVoice] || [onKeyboard.event isEqualToEnum:SDLKeyboardEventSubmitted]) {
        // Submit voice or text
        [self.keyboardDelegate userDidSubmitInput:onKeyboard.data withEvent:onKeyboard.event];
    } else if ([onKeyboard.event isEqualToEnum:SDLKeyboardEventKeypress]) {
        // Notify of keypress
        if ([self.keyboardDelegate respondsToSelector:@selector(updateAutocompleteWithInput:autoCompleteResultsHandler:)]) {
            [self.keyboardDelegate updateAutocompleteWithInput:onKeyboard.data autoCompleteResultsHandler:^(NSArray<NSString *> * _Nullable updatedAutoCompleteList) {
                __strong typeof(self) strongself = weakself;
                NSArray<NSString *> *newList = nil;
                if (updatedAutoCompleteList.count > 100) {
                    newList = [updatedAutoCompleteList subarrayWithRange:NSMakeRange(0, 100)];
                } else {
                    newList = updatedAutoCompleteList;
                }

                strongself.customKeyboardProperties.autoCompleteList = (newList.count > 0) ? newList : @[];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                strongself.customKeyboardProperties.autoCompleteText = (newList.count > 0) ? newList.firstObject : nil;
#pragma clang diagnostic pop
                [strongself sdl_updateKeyboardPropertiesWithCompletionHandler:^(NSError * _Nullable error) {}];
            }];
        }

        if ([self.keyboardDelegate respondsToSelector:@selector(updateCharacterSetWithInput:completionHandler:)]) {
            [self.keyboardDelegate updateCharacterSetWithInput:onKeyboard.data completionHandler:^(NSArray<NSString *> *updatedCharacterSet) {
                __strong typeof(self) strongself = weakself;
                strongself.customKeyboardProperties.limitedCharacterList = updatedCharacterSet;
                [strongself sdl_updateKeyboardPropertiesWithCompletionHandler:^(NSError * _Nullable error) {}];
            }];
        }
    } else if ([onKeyboard.event isEqualToEnum:SDLKeyboardEventAborted] || [onKeyboard.event isEqualToEnum:SDLKeyboardEventCancelled]) {
        // Notify of abort / cancellation
        [self.keyboardDelegate keyboardDidAbortWithReason:onKeyboard.event];
    } else if ([onKeyboard.event isEqualToEnum:SDLKeyboardEventInputKeyMaskEnabled] || [onKeyboard.event isEqualToEnum:SDLKeyboardEventInputKeyMaskDisabled]) {
        // Notify of key mask change
        if ([self.keyboardDelegate respondsToSelector:@selector(keyboardDidUpdateInputMask:)]) {
            BOOL isEnabled = [onKeyboard.event isEqualToEnum:SDLKeyboardEventInputKeyMaskEnabled];
            [self.keyboardDelegate keyboardDidUpdateInputMask:isEnabled];
        }
    }
}

#pragma mark - Property Overrides

- (void)finishOperation {
    [self finishOperation:nil];
}

- (void)finishOperation:(nullable NSError *)error {
    self.currentState = SDLPreloadPresentChoicesOperationStateFinishing;

    self.internalError = error;
    self.preloadCompletionHandler(self.loadedCells, self.internalError);

    if (self.choiceSet.delegate == nil) {
        SDLLogD(@"Preload finished, no choice set delegate was set, so no present will occur.");
    } else if (error != nil) {
        SDLLogW(@"Choice set did error: %@", self.internalError);
        [self.choiceSet.delegate choiceSet:self.choiceSet didReceiveError:self.internalError];
    } else if (self.selectedCell != nil) {
        SDLLogD(@"Choice set did present successfully: %@, selected choice: %@, trigger source: %@, row index: %ld", self.choiceSet, self.selectedCell, self.selectedTriggerSource, self.selectedCellRow);
        [self.choiceSet.delegate choiceSet:self.choiceSet didSelectChoice:self.selectedCell withSource:self.selectedTriggerSource atRowIndex:self.selectedCellRow];
    } else {
        SDLLogE(@"Present finished, but an unhandled state occurred and callback failed");
    }

    [super finishOperation];
}

- (nullable NSString *)name {
    return [NSString stringWithFormat:@"%@ - %@", self.class, self.operationId];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (nullable NSError *)error {
    return self.internalError;
}

@end

NS_ASSUME_NONNULL_END
