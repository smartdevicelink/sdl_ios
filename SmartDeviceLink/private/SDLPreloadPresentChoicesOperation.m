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

    // Enforce unique cells and remove cells that are already loaded
    [self.class sdl_makeCellsToUploadUnique:self.cellsToUpload basedOnLoadedCells:self.mutableLoadedCells windowCapability:self.windowCapability];

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
    for (NSUInteger i = 0; i < self.cellsToUpload.count; i++) {
        if (self.cellsToUpload[i].choiceId == cellId.unsignedIntValue) {
            self.selectedCell = self.cellsToUpload[i];
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
+ (void)sdl_makeCellsToUploadUnique:(NSMutableOrderedSet<SDLChoiceCell *> *)cellsToUpload basedOnLoadedCells:(NSMutableSet<SDLChoiceCell *> *)loadedCells windowCapability:(SDLWindowCapability *)windowCapability {
    // If we're on < RPC 7.1, all primary texts need to be unique, so we don't need to check removed properties and duplicate cells
    // On > RPC 7.1, at this point all cells are unique when considering all properties, but we also need to check if any cells will _appear_ as duplicates when displayed on the screen. To check that, we'll remove properties from the set cells based on the system capabilities (we probably don't need to consider them changing between now and when they're actually sent to the HU) and check for uniqueness again. Then we'll add unique identifiers to primary text if there are duplicates. Then we transfer the primary text identifiers back to the main cells and add those to an operation to be sent.
    BOOL supportsChoiceUniqueness = [[SDLGlobals sharedGlobals].rpcVersion isGreaterThanOrEqualToVersion:[SDLVersion versionWithMajor:7 minor:1 patch:0]];
    if (supportsChoiceUniqueness) {
        [self sdl_removeUnusedProperties:cellsToUpload basedOnWindowCapability:windowCapability];
    }

    // We may have removed unused properties, now remove duplicate cells that are already on the head unit, then add unique names to the ones to upload
    [cellsToUpload minusSet:loadedCells];
    [self sdl_addUniqueNamesToCells:cellsToUpload loadedCells:loadedCells supportsChoiceUniqueness:supportsChoiceUniqueness];
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
/// @param cellsToUpload The choices to be uploaded.
/// @param loadedCells The cells already on the head unit
+ (void)sdl_addUniqueNamesToCells:(NSOrderedSet<SDLChoiceCell *> *)cellsToUpload loadedCells:(NSSet<SDLChoiceCell *> *)loadedCells supportsChoiceUniqueness:(BOOL)supportsChoiceUniqueness {
    // Tracks how many of each cell primary text there are so that we can append numbers to make each unique as necessary
    NSMutableDictionary<id<NSCopying>, NSNumber *> *dictCounter = [[NSMutableDictionary alloc] init];

    // Include cells from loaded cells to ensure that new cells get the correct title
    for (SDLChoiceCell *loadedCell in loadedCells) {
        id<NSCopying> cellKey = supportsChoiceUniqueness ? loadedCell : loadedCell.text;
        NSNumber *counter = dictCounter[cellKey];
        if (counter != nil) {
            counter = @(counter.intValue + 1);
            dictCounter[cellKey] = counter;
        } else {
            dictCounter[cellKey] = @1;
        }
    }

    // Run through cellsToUpload and add unique text as needed
    for (SDLChoiceCell *cell in cellsToUpload) {
        id<NSCopying> cellKey = supportsChoiceUniqueness ? cell : cell.text;
        NSNumber *counter = dictCounter[cellKey];
        if (counter != nil) {
            counter = @(counter.intValue + 1);
            dictCounter[cellKey] = counter;
        } else {
            dictCounter[cellKey] = @1;
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

    if(!menuName) {
        SDLLogE(@"Could not convert SDLChoiceCell to SDLCreateInteractionChoiceSet. It will not be shown. Cell: %@", cell);
        return nil;
    }
    
    NSString *secondaryText = [self sdl_shouldSendChoiceSecondaryTextBasedOnWindowCapability:windowCapability] ? cell.secondaryText : nil;
    NSString *tertiaryText = [self sdl_shouldSendChoiceTertiaryTextBasedOnWindowCapability:windowCapability] ? cell.tertiaryText : nil;

    SDLImage *image = [self sdl_shouldSendChoicePrimaryImageBasedOnWindowCapability:windowCapability] ? cell.artwork.imageRPC : nil;
    SDLImage *secondaryImage = [self sdl_shouldSendChoiceSecondaryImageBasedOnWindowCapability:windowCapability] ? cell.secondaryArtwork.imageRPC : nil;

    SDLChoice *choice = [[SDLChoice alloc] initWithId:cell.choiceId menuName:(NSString *_Nonnull)menuName vrCommands:(NSArray<NSString *> * _Nonnull)vrCommands image:image secondaryText:secondaryText secondaryImage:secondaryImage tertiaryText:tertiaryText];

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

- (void)finishOperation:(nullable NSError *)error {
    self.currentState = SDLPreloadPresentChoicesOperationStateFinishing;

    self.internalError = error;
    self.preloadCompletionHandler(self.loadedCells, self.internalError);

    if (self.choiceSet.delegate == nil) {
        SDLLogW(@"Present finished, but no choice set delegate was available for callback");
    } else if (error != nil) {
        [self.choiceSet.delegate choiceSet:self.choiceSet didReceiveError:self.internalError];
    } else if (self.selectedCell != nil) {
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
