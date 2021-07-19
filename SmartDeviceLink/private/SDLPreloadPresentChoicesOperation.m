//
//  SDLPreloadChoicesOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLPreloadPresentChoicesOperation.h"

#import "SDLChoice.h"
#import "SDLChoiceCell.h"
#import "SDLChoiceSet.h"
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
#import "SDLPerformInteraction.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSetGlobalProperties.h"
#import "SDLVersion.h"
#import "SDLWindowCapability.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;
@property (strong, nonatomic, readwrite) NSString *uniqueText;
@property (copy, nonatomic, readwrite, nullable) NSString *secondaryText;
@property (copy, nonatomic, readwrite, nullable) NSString *tertiaryText;
@property (copy, nonatomic, readwrite, nullable) NSArray<NSString *> *voiceCommands;
@property (strong, nonatomic, readwrite, nullable) SDLArtwork *artwork;
@property (strong, nonatomic, readwrite, nullable) SDLArtwork *secondaryArtwork;

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
@property (copy, nonatomic) SDLPreloadChoicesCompletionHandler preloadCompletionHandler;

// Present Dependencies
@property (strong, nonatomic) SDLChoiceSet *choiceSet;
@property (strong, nonatomic, nullable) SDLInteractionMode presentationMode;
@property (strong, nonatomic, nullable) SDLKeyboardProperties *originalKeyboardProperties;
@property (strong, nonatomic, nullable) SDLKeyboardProperties *keyboardProperties;
@property (weak, nonatomic, nullable) id<SDLKeyboardDelegate> keyboardDelegate;
@property (assign, nonatomic) UInt16 cancelId;

// Internal operation properties
@property (strong, nonatomic) NSUUID *operationId;
@property (copy, nonatomic, nullable) NSError *internalError;

// Mutable state
@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *mutableLoadedCells;

// Present completion handler properties
@property (strong, nonatomic, nullable) SDLChoiceCell *selectedCell;
@property (strong, nonatomic, nullable) SDLTriggerSource selectedTriggerSource;
@property (assign, nonatomic) NSUInteger selectedCellRow;
@property (copy, nonatomic) SDLPresentChoiceSetCompletionHandler presentCompletionHandler;

@end

@implementation SDLPreloadPresentChoicesOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager displayName:(NSString *)displayName windowCapability:(SDLWindowCapability *)windowCapability isVROptional:(BOOL)isVROptional cellsToPreload:(NSArray<SDLChoiceCell *> *)cellsToPreload loadedCells:(NSSet<SDLChoiceCell *> *)loadedCells preloadCompletionHandler:(SDLPreloadChoicesCompletionHandler)preloadCompletionHandler {
    self = [super init];
    if (!self) { return nil; }

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

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager choiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode  keyboardProperties:(nullable SDLKeyboardProperties *)originalKeyboardProperties keyboardDelegate:(nullable id<SDLKeyboardDelegate>)keyboardDelegate cancelID:(UInt16)cancelID displayName:(NSString *)displayName windowCapability:(SDLWindowCapability *)windowCapability isVROptional:(BOOL)isVROptional loadedCells:(NSSet<SDLChoiceCell *> *)loadedCells preloadCompletionHandler:(SDLPreloadChoicesCompletionHandler)preloadCompletionHandler presentCompletionHandler:(SDLPresentChoiceSetCompletionHandler)presentCompletionHandler {
    self = [super init];
    if (!self) { return nil; }

    _operationId = [NSUUID UUID];

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _choiceSet = choiceSet;

    __weak typeof(self) weakSelf = self;
    _choiceSet.canceledHandler = ^{
        [weakSelf sdl_cancelInteraction];
    };

    _originalKeyboardProperties = originalKeyboardProperties;
    _keyboardProperties = originalKeyboardProperties;
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

    [self sdl_makeCellsToUploadUnique];
    [self sdl_preloadCellArtworksWithCompletionHandler:^(NSError * _Nullable error) {
        // If some artworks failed to upload, we are still going to try to load the cells
        self.internalError = error;
        if (self.isCancelled) { return [self finishOperation]; }

        [self sdl_preloadCellsWithCompletionHandler:^(NSError * _Nullable error) {
            // If this operation has been cancelled or if there was an error with loading the cells, we don't want to present, so we'll end the operation
            if (self.isCancelled || error != nil) { return [self finishOperation]; }

            // If necessary, present the choice set
            if (self.choiceSet == nil) { return [self finishOperation]; }
            [self sdl_updateKeyboardPropertiesWithCompletionHandler:^(NSError * _Nullable error) {
                <#code#>
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

// TODO: If an artwork fails to upload, are we or should be continue through to cell preload / presentation? Remove that art from "choices to upload" or just immediately cancel?
- (void)sdl_preloadCellArtworksWithCompletionHandler:(void(^)(NSError *_Nullable error))completionHandler {
    NSMutableArray<SDLArtwork *> *artworksToUpload = [NSMutableArray arrayWithCapacity:self.choiceSet.choices.count];
    for (SDLChoiceCell *cell in self.choiceSet.choices) {
        if ([self sdl_shouldSendChoicePrimaryImage] && [self.fileManager fileNeedsUpload:cell.artwork]) {
            [artworksToUpload addObject:cell.artwork];
        }
        if ([self sdl_shouldSendChoiceSecondaryImage] && [self.fileManager fileNeedsUpload:cell.secondaryArtwork]) {
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

- (void)sdl_preloadCellsWithCompletionHandler:(void(^)(NSError *_Nullable))completionHandler {
    NSMutableArray<SDLCreateInteractionChoiceSet *> *choiceRPCs = [NSMutableArray arrayWithCapacity:self.cellsToUpload.count];
    for (SDLChoiceCell *cell in self.cellsToUpload) {
        SDLCreateInteractionChoiceSet *csCell =  [self sdl_choiceFromCell:cell];
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

- (void)sdl_updateKeyboardPropertiesWithCompletionHandler:(void(^)(NSError *_Nullable))completionHandler {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_keyboardInputNotification:) name:SDLDidReceiveKeyboardInputNotification object:nil];

    // Check if we're using a keyboard (searchable) choice set and setup keyboard properties if we need to
    if (self.keyboardDelegate != nil && [self.keyboardDelegate respondsToSelector:@selector(customKeyboardConfiguration)]) {
        SDLKeyboardProperties *customProperties = self.keyboardDelegate.customKeyboardConfiguration;
        if (customProperties != nil) {
            self.keyboardProperties = customProperties;
        }
    }

    // Create the keyboard configuration based on the window capability's keyboard capabilities
    SDLKeyboardProperties *modifiedKeyboardConfig = [self.windowCapability createValidKeyboardConfigurationBasedOnKeyboardCapabilitiesFromConfiguration:self.keyboardProperties];
    if (modifiedKeyboardConfig == nil) {
        return completionHandler(nil);
    }
    SDLSetGlobalProperties *setProperties = [[SDLSetGlobalProperties alloc] init];
    setProperties.keyboardProperties = modifiedKeyboardConfig;

    __weak typeof(self) weakself = self;
    [self.connectionManager sendConnectionRequest:setProperties withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Error setting keyboard properties to new value: %@, with error: %@", request, error);
        }

        weakself.updatedKeyboardProperties = YES;

        return completionHandler(error);
    }];
}

- (void)sdl_presentChoiceSetWithCompletionHandler:(void(^)(NSError *_Nullable error))completionHandler {

}

- (void)sdl_setSelectedCellWithId:(NSNumber<SDLInt> *)cellId {
    __weak typeof(self) weakself = self;
    for (int i = 0; i < self.cellsToUpload.count; i++) {
        if (self.cellsToUpload[i].choiceId == cellId.unsignedIntValue) {
            self.selectedCell = cell;
            self.selectedCellRow = i;
            break;
        }
    }
}

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
        if ([SDLGlobals.sharedGlobals.rpcVersion isLessThanVersion:[[SDLVersion alloc] initWithMajor:6 minor:0 patch:0]]) {
            SDLLogE(@"Canceling a choice set is not supported on this head unit");
            return;
        }

        SDLLogD(@"Canceling the presented choice set interaction");

        SDLCancelInteraction *cancelInteraction = [[SDLCancelInteraction alloc] initWithPerformInteractionCancelID:self.cancelId];

        __weak typeof(self) weakSelf = self;
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

- (SDLPerformInteraction *)sdl_performInteractionFromChoiceSet {
    SDLLayoutMode layoutMode = nil;
    switch (self.choiceSet.layout) {
        case SDLChoiceSetLayoutList:
            layoutMode = self.keyboardDelegate ? SDLLayoutModeListWithSearch : SDLLayoutModeListOnly;
        case SDLChoiceSetLayoutTiles:
            layoutMode = self.keyboardDelegate ? SDLLayoutModeIconWithSearch : SDLLayoutModeIconOnly;
    }

    NSMutableArray<NSNumber<SDLInt> *> *choiceIds = [NSMutableArray arrayWithCapacity:self.cellsToUpload.count];
    for (SDLChoiceCell *cell in self.cellsToUpload) {
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

#pragma mark - Choice Uniqueness

/// Checks the choices to be uploaded and returns the items that have not yet been uploaded to the module, including adding unique names and stripping unused properties. These cells are then stored in the `self.cellsToUpload`.
- (void)sdl_makeCellsToUploadUnique {
    // If we're on < RPC 7.1, all primary texts need to be unique, so we don't need to check removed properties and duplicate cells
    // On > RPC 7.1, at this point all cells are unique when considering all properties, but we also need to check if any cells will _appear_ as duplicates when displayed on the screen. To check that, we'll remove properties from the set cells based on the system capabilities (we probably don't need to consider them changing between now and when they're actually sent to the HU) and check for uniqueness again. Then we'll add unique identifiers to primary text if there are duplicates. Then we transfer the primary text identifiers back to the main cells and add those to an operation to be sent.
    SDLVersion *choiceUniquenessSupportedVersion = [[SDLVersion alloc] initWithMajor:7 minor:1 patch:0];
    if ([[SDLGlobals sharedGlobals].rpcVersion isGreaterThanOrEqualToVersion:choiceUniquenessSupportedVersion]) {
        [self.class sdl_removeUnusedProperties:self.cellsToUpload basedOnWindowCapability:self.windowCapability];
    }

    // We may have removed unused properties, now we need to add unique names, then remove ones to upload from the loaded cells
    [self.class sdl_addUniqueNamesToCells:self.cellsToUpload];
    [self.cellsToUpload minusSet:self.loadedCells];
}

+ (void)sdl_removeUnusedProperties:(NSMutableOrderedSet<SDLChoiceCell *> *)choiceCells basedOnWindowCapability:(SDLWindowCapability *)windowCapability {
    for (SDLChoiceCell *cell in choiceCells) {
        // Strip away fields that cannot be used to determine uniqueness visually including fields not supported by the HMI
        cell.voiceCommands = nil;

        // Don't check SDLImageFieldNameSubMenuIcon because it was added in 7.0 when the feature was added in 5.0. Just assume that if CommandIcon is not available, the submenu icon is not either.
        if (![windowCapability hasImageFieldOfName:SDLImageFieldNameChoiceImage]) {
            cell.artwork = nil;
        }
        if (![windowCapability hasTextFieldOfName:SDLTextFieldNameSecondaryText]) {
            cell.secondaryText = nil;
        }
        if (![windowCapability hasTextFieldOfName:SDLTextFieldNameTertiaryText]) {
            cell.tertiaryText = nil;
        }
        if (![windowCapability hasImageFieldOfName:SDLImageFieldNameChoiceSecondaryImage]) {
            cell.secondaryArtwork = nil;
        }
    }
}

/// Checks if 2 or more cells have the same text/title. In case this condition is true, this function will handle the presented issue by adding "(count)".
/// E.g. Choices param contains 2 cells with text/title "Address" will be handled by updating the uniqueText/uniqueTitle of the second cell to "Address (2)".
/// @param choices The choices to be uploaded.
+ (void)sdl_addUniqueNamesToCells:(NSMutableOrderedSet<SDLChoiceCell *> *)choices {
    // Tracks how many of each cell primary text there are so that we can append numbers to make each unique as necessary
    NSMutableDictionary<NSString *, NSNumber *> *dictCounter = [[NSMutableDictionary alloc] init];
    for (SDLChoiceCell *cell in choices) {
        NSString *cellName = cell.text;
        NSNumber *counter = dictCounter[cellName];
        if (counter != nil) {
            counter = @(counter.intValue + 1);
            dictCounter[cellName] = counter;
        } else {
            dictCounter[cellName] = @1;
        }
        if (counter.intValue > 1) {
            cell.uniqueText = [NSString stringWithFormat: @"%@ (%d)", cell.text, counter.intValue];
        }
    }
}

#pragma mark Finding Cells

- (nullable SDLChoiceCell *)sdl_cellFromChoiceId:(UInt16)choiceId {
    for (SDLChoiceCell *cell in self.cellsToUpload) {
        if (cell.choiceId == choiceId) { return cell; }
    }

    return nil;
}

#pragma mark - Assembling Choice RPCs

- (nullable SDLCreateInteractionChoiceSet *)sdl_choiceFromCell:(SDLChoiceCell *)cell {
    NSArray<NSString *> *vrCommands = nil;
    if (cell.voiceCommands == nil) {
        vrCommands = self.isVROptional ? nil : @[[NSString stringWithFormat:@"%hu", cell.choiceId]];
    } else {
        vrCommands = cell.voiceCommands;
    }

    NSString *menuName = nil;
    if ([self sdl_shouldSendChoiceText]) {
        menuName = cell.uniqueText;
    }

    if(!menuName) {
        SDLLogE(@"Could not convert SDLChoiceCell to SDLCreateInteractionChoiceSet. It will not be shown. Cell: %@", cell);
        return nil;
    }
    
    NSString *secondaryText = [self sdl_shouldSendChoiceSecondaryText] ? cell.secondaryText : nil;
    NSString *tertiaryText = [self sdl_shouldSendChoiceTertiaryText] ? cell.tertiaryText : nil;

    SDLImage *image = [self sdl_shouldSendChoicePrimaryImage] ? cell.artwork.imageRPC : nil;
    SDLImage *secondaryImage = [self sdl_shouldSendChoiceSecondaryImage] ? cell.secondaryArtwork.imageRPC : nil;

    SDLChoice *choice = [[SDLChoice alloc] initWithId:cell.choiceId menuName:(NSString *_Nonnull)menuName vrCommands:(NSArray<NSString *> * _Nonnull)vrCommands image:image secondaryText:secondaryText secondaryImage:secondaryImage tertiaryText:tertiaryText];

    return [[SDLCreateInteractionChoiceSet alloc] initWithId:(UInt32)choice.choiceID.unsignedIntValue choiceSet:@[choice]];
}

/// Determine if we should send primary text. If textFields is nil, we don't know the capabilities and we will send everything.
- (BOOL)sdl_shouldSendChoiceText {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ([self.displayName isEqualToString:SDLDisplayTypeGen38Inch]) {
        return YES;
    }
#pragma clang diagnostic pop

    return [self.windowCapability hasTextFieldOfName:SDLTextFieldNameMenuName];
}

/// Determine if we should send secondary text. If textFields is nil, we don't know the capabilities and we will send everything.
- (BOOL)sdl_shouldSendChoiceSecondaryText {
    return [self.windowCapability hasTextFieldOfName:SDLTextFieldNameSecondaryText];
}

/// Determine if we should send tertiary text. If textFields is nil, we don't know the capabilities and we will send everything.
- (BOOL)sdl_shouldSendChoiceTertiaryText {
    return [self.windowCapability hasTextFieldOfName:SDLTextFieldNameTertiaryText];
}

/// Determine if we should send the primary image. If imageFields is nil, we don't know the capabilities and we will send everything.
- (BOOL)sdl_shouldSendChoicePrimaryImage {
    return [self.windowCapability hasImageFieldOfName:SDLImageFieldNameChoiceImage];
}

/// Determine if we should send the secondary image. If imageFields is nil, we don't know the capabilities and we will send everything.
- (BOOL)sdl_shouldSendChoiceSecondaryImage {
    return [self.windowCapability hasImageFieldOfName:SDLImageFieldNameChoiceSecondaryImage];
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
                NSArray<NSString *> *newList = nil;
                if (updatedAutoCompleteList.count > 100) {
                    newList = [updatedAutoCompleteList subarrayWithRange:NSMakeRange(0, 100)];
                } else {
                    newList = updatedAutoCompleteList;
                }

                weakself.keyboardProperties.autoCompleteList = (newList.count > 0) ? newList : @[];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                weakself.keyboardProperties.autoCompleteText = (newList.count > 0) ? newList.firstObject : nil;
#pragma clang diagnostic pop
                [weakself sdl_updateKeyboardPropertiesWithCompletionHandler:nil];
            }];
        }

        if ([self.keyboardDelegate respondsToSelector:@selector(updateCharacterSetWithInput:completionHandler:)]) {
            [self.keyboardDelegate updateCharacterSetWithInput:onKeyboard.data completionHandler:^(NSArray<NSString *> *updatedCharacterSet) {
                weakself.keyboardProperties.limitedCharacterList = updatedCharacterSet;
                [self sdl_updateKeyboardPropertiesWithCompletionHandler:nil];
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
    self.completionHandler(self.loadedCells, self.internalError);

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
