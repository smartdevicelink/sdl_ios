//
//  SDLPreloadChoicesOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLPreloadChoicesOperation.h"

#import "SDLChoice.h"
#import "SDLChoiceCell.h"
#import "SDLConnectionManagerType.h"
#import "SDLCreateInteractionChoiceSet.h"
#import "SDLCreateInteractionChoiceSetResponse.h"
#import "SDLDisplayType.h"
#import "SDLError.h"
#import "SDLFileManager.h"
#import "SDLGlobals.h"
#import "SDLImage.h"
#import "SDLLogMacros.h"
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

@interface SDLPreloadChoicesOperation()

@property (strong, nonatomic) NSUUID *operationId;
@property (strong, nonatomic) NSMutableOrderedSet<SDLChoiceCell *> *cellsToUpload;
@property (strong, nonatomic) SDLWindowCapability *windowCapability;
@property (strong, nonatomic) NSString *displayName;
@property (assign, nonatomic, getter=isVROptional) BOOL vrOptional;
@property (copy, nonatomic) SDLPreloadChoicesCompletionHandler completionHandler;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;
@property (copy, nonatomic, nullable) NSError *internalError;

@property (strong, nonatomic) NSMutableSet<SDLChoiceCell *> *mutableLoadedCells;

@end

@implementation SDLPreloadChoicesOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager displayName:(NSString *)displayName windowCapability:(SDLWindowCapability *)defaultMainWindowCapability isVROptional:(BOOL)isVROptional cellsToPreload:(NSOrderedSet<SDLChoiceCell *> *)cellsToPreload loadedCells:(NSSet<SDLChoiceCell *> *)loadedCells completionHandler:(SDLPreloadChoicesCompletionHandler)completionHandler {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _fileManager = fileManager;
    _displayName = displayName;
    _windowCapability = defaultMainWindowCapability;
    _vrOptional = isVROptional;
    _cellsToUpload = [cellsToPreload mutableCopy];
    _mutableLoadedCells = [loadedCells mutableCopy];
    _completionHandler = completionHandler;
    _operationId = [NSUUID UUID];

    _currentState = SDLPreloadChoicesOperationStateWaitingToStart;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    [self sdl_updateCellsBasedOnLoadedChoices];
    [self sdl_preloadCellArtworksWithCompletionHandler:^(NSError * _Nullable error) {
        self.internalError = error;
        [self sdl_preloadCells];
    }];
}

- (BOOL)removeChoicesFromUpload:(NSSet<SDLChoiceCell *> *)choices {
    if (self.isExecuting) { return NO; }

    [self.cellsToUpload minusSet:choices];
    return YES;
}

#pragma mark - Getters / Setters

- (void)setLoadedCells:(NSSet<SDLChoiceCell *> *)loadedCells {
    _mutableLoadedCells = [loadedCells mutableCopy];
}

- (NSSet<SDLChoiceCell *> *)loadedCells {
    return [_mutableLoadedCells copy];
}

#pragma mark - Sending Choice Data

- (void)sdl_preloadCellArtworksWithCompletionHandler:(void(^)(NSError *_Nullable))completionHandler {
    _currentState = SDLPreloadChoicesOperationStateUploadingArtworks;

    NSMutableArray<SDLArtwork *> *artworksToUpload = [NSMutableArray arrayWithCapacity:self.cellsToUpload.count];
    for (SDLChoiceCell *cell in self.cellsToUpload) {
        if ([self sdl_shouldSendChoicePrimaryImage] && [self.fileManager fileNeedsUpload:cell.artwork]) {
            [artworksToUpload addObject:cell.artwork];
        }
        if ([self sdl_shouldSendChoiceSecondaryImage] && [self.fileManager fileNeedsUpload:cell.secondaryArtwork]) {
            [artworksToUpload addObject:cell.secondaryArtwork];
        }
    }

    if (artworksToUpload.count == 0) {
        SDLLogD(@"No choice artworks to be uploaded");
        completionHandler(nil);
        return;
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

- (void)sdl_preloadCells {
    _currentState = SDLPreloadChoicesOperationStatePreloadingChoices;

    NSMutableArray<SDLCreateInteractionChoiceSet *> *choiceRPCs = [NSMutableArray arrayWithCapacity:self.cellsToUpload.count];
    for (SDLChoiceCell *cell in self.cellsToUpload) {
        SDLCreateInteractionChoiceSet *csCell =  [self sdl_choiceFromCell:cell];
        if (csCell != nil) {
            [choiceRPCs addObject:csCell];
        }
    }
    if (choiceRPCs.count == 0) {
        SDLLogE(@"All choice cells to send are nil, so the choice set will not be shown");
        self.internalError = [NSError sdl_choiceSetManager_failedToCreateMenuItems];
        [self finishOperation];
        return;
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
        if (!success) {
            SDLLogE(@"Error preloading choice cells: %@", errors);
            weakSelf.internalError = [NSError sdl_choiceSetManager_choiceUploadFailed:errors];
        }

        SDLLogD(@"Finished preloading choice cells");

        [weakSelf finishOperation];
    }];
}

#pragma mark - Choice Uniqueness

/// Checks the choices to be uploaded and returns the items that have not yet been uploaded to the module, including adding unique names and stripping unused properties. These cells are then stored in the `self.cellsToUpload`.
- (void)sdl_updateCellsBasedOnLoadedChoices {
    SDLVersion *choiceUniquenessSupportedVersion = [[SDLVersion alloc] initWithMajor:7 minor:1 patch:0];
    if ([[SDLGlobals sharedGlobals].rpcVersion isLessThanVersion:choiceUniquenessSupportedVersion]) {
        // If we're on < RPC 7.1, all primary texts need to be unique, so we don't need to check removed properties and duplicate cells
        [self sdl_addUniqueNamesToCells:self.cellsToUpload];
    } else {
        // On > RPC 7.1, at this point all cells are unique when considering all properties, but we also need to check if any cells will _appear_ as duplicates when displayed on the screen. To check that, we'll remove properties from the set cells based on the system capabilities (we probably don't need to consider them changing between now and when they're actually sent to the HU) and check for uniqueness again. Then we'll add unique identifiers to primary text if there are duplicates. Then we transfer the primary text identifiers back to the main cells and add those to an operation to be sent.
        NSMutableOrderedSet<SDLChoiceCell *> *strippedCellsCopy = [self sdl_removeUnusedProperties:self.cellsToUpload];
        [self sdl_addUniqueNamesBasedOnStrippedCells:strippedCellsCopy toUnstrippedCells:self.cellsToUpload];
    }
    [self.cellsToUpload minusSet:self.loadedCells];
}

- (NSMutableOrderedSet<SDLChoiceCell *> *)sdl_removeUnusedProperties:(NSMutableOrderedSet<SDLChoiceCell *> *)choiceCells {
    NSMutableOrderedSet<SDLChoiceCell *> *strippedCellsCopy = [[NSMutableOrderedSet alloc] initWithOrderedSet:choiceCells copyItems:YES];
    for (SDLChoiceCell *cell in strippedCellsCopy) {
        // Strip away fields that cannot be used to determine uniqueness visually including fields not supported by the HMI
        cell.voiceCommands = nil;

        // Don't check SDLImageFieldNameSubMenuIcon because it was added in 7.0 when the feature was added in 5.0. Just assume that if CommandIcon is not available, the submenu icon is not either.
        if (![self.windowCapability hasImageFieldOfName:SDLImageFieldNameChoiceImage]) {
            cell.artwork = nil;
        }
        if (![self.windowCapability hasTextFieldOfName:SDLTextFieldNameSecondaryText]) {
            cell.secondaryText = nil;
        }
        if (![self.windowCapability hasTextFieldOfName:SDLTextFieldNameTertiaryText]) {
            cell.tertiaryText = nil;
        }
        if (![self.windowCapability hasImageFieldOfName:SDLImageFieldNameChoiceSecondaryImage]) {
            cell.secondaryArtwork = nil;
        }
    }

    return strippedCellsCopy;
}

- (void)sdl_addUniqueNamesBasedOnStrippedCells:(NSMutableOrderedSet<SDLChoiceCell *> *)strippedCells toUnstrippedCells:(NSMutableOrderedSet<SDLChoiceCell *> *)unstrippedCells {
    NSParameterAssert(strippedCells.count == unstrippedCells.count);
    // Tracks how many of each cell primary text there are so that we can append numbers to make each unique as necessary
    NSMutableDictionary<SDLChoiceCell *, NSNumber *> *dictCounter = [[NSMutableDictionary alloc] init];
    for (NSUInteger i = 0; i < strippedCells.count; i++) {
        SDLChoiceCell *cell = strippedCells[i];
        NSNumber *counter = dictCounter[cell];
        if (counter != nil) {
            counter = @(counter.intValue + 1);
            dictCounter[cell] = counter;
        } else {
            dictCounter[cell] = @1;
        }

        counter = dictCounter[cell];
        if (counter.intValue > 1) {
            unstrippedCells[i].uniqueText = [NSString stringWithFormat: @"%@ (%d)", unstrippedCells[i].text, counter.intValue];
        }
    }
}

/// Checks if 2 or more cells have the same text/title. In case this condition is true, this function will handle the presented issue by adding "(count)".
/// E.g. Choices param contains 2 cells with text/title "Address" will be handled by updating the uniqueText/uniqueTitle of the second cell to "Address (2)".
/// @param choices The choices to be uploaded.
- (void)sdl_addUniqueNamesToCells:(NSOrderedSet<SDLChoiceCell *> *)choices {
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

#pragma mark - Assembling Choice Data

- (nullable SDLChoiceCell *)sdl_cellFromChoiceId:(UInt16)choiceId {
    for (SDLChoiceCell *cell in self.cellsToUpload) {
        if (cell.choiceId == choiceId) { return cell; }
    }

    return nil;
}

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

#pragma mark - Property Overrides

- (void)finishOperation {
    self.currentState = SDLPreloadChoicesOperationStateFinished;
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
