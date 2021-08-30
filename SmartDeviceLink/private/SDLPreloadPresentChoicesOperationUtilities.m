//
//  SDLPreloadPresentChoiceSetOperationUtilities.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/27/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLPreloadPresentChoicesOperationUtilities.h"

#import "SDLChoiceCell.h"
#import "SDLChoiceSet.h"
#import "SDLGlobals.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"
#import "SDLVersion.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;
@property (copy, nonatomic, readwrite, nullable) NSString *secondaryText;
@property (copy, nonatomic, readwrite, nullable) NSString *tertiaryText;
@property (copy, nonatomic, readwrite, nullable) NSArray<NSString *> *voiceCommands;
@property (strong, nonatomic, readwrite, nullable) SDLArtwork *artwork;
@property (strong, nonatomic, readwrite, nullable) SDLArtwork *secondaryArtwork;

@property (assign, nonatomic) NSUInteger uniqueTextId;

@end

@implementation SDLPreloadPresentChoicesOperationUtilities
static UInt16 _choiceId = 0;
static BOOL _reachedMaxId = NO;

#pragma mark Getters / Setters

+ (UInt16)choiceId {
    return _choiceId;
}

+ (void)setChoiceId:(UInt16)choiceId {
    _choiceId = choiceId;
}

+ (BOOL)reachedMaxId {
    return _reachedMaxId;
}

+ (void)setReachedMaxId:(BOOL)reachedMaxId {
    _reachedMaxId = reachedMaxId;
}

#pragma mark - Cell Ids

+ (void)assignIdsToCells:(NSOrderedSet<SDLChoiceCell *> *)cells loadedCells:(NSSet<SDLChoiceCell *> *)loadedCells {
    for (SDLChoiceCell *cell in cells) { cell.choiceId = [self sdl_nextChoiceIdBasedOnLoadedCells:loadedCells]; }
}

/// Find the next available choice id. Takes into account the loaded cells to ensure there are not duplicates
/// @param loadedCells The already loaded cells
/// @return The choice id between 0 - 65535, or NSNotFound if no cell ids were available
+ (UInt16)sdl_nextChoiceIdBasedOnLoadedCells:(NSSet<SDLChoiceCell *> *)loadedCells {
    // Check if we are entirely full, or if we've advanced beyond the max value, loop back
    if (_choiceId == UINT16_MAX) {
        _choiceId = 0;
        _reachedMaxId = YES;
    }

    if (_reachedMaxId) {
        // We've looped all the way around, so we need to check loaded cells
        // Sort the set of cells by the choice id so that we can more easily check which slots are available
        NSArray<SDLChoiceCell *> *loadedCellsSortedById = [loadedCells sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"choiceId" ascending:YES]]];
        for (NSUInteger i = 0; i < loadedCellsSortedById.count - 1; i++) {
            if ((loadedCellsSortedById[i + 1].choiceId - loadedCellsSortedById[i].choiceId) != 1) {
                // The id of two contiguous cells is not one, so there is at least one slot between them (i.e. (3 - 1 = 2) != 1, so 1 + 1 is available)
                _choiceId = loadedCellsSortedById[i].choiceId + 1;
                return _choiceId;
            }
        }

        // This shouldn't be possible, but if it happens, return the max Id
        _choiceId = UINT16_MAX;
        return _choiceId;
    } else {
        // We haven't looped all the way around yet, so we'll just take the current number, then advance the item
        return _choiceId++;
    }
}

#pragma mark - Choice Uniqueness

+ (void)makeCellsToUploadUnique:(NSMutableOrderedSet<SDLChoiceCell *> *)cellsToUpload choiceSet:(nullable SDLChoiceSet *)choiceSet basedOnLoadedCells:(NSMutableSet<SDLChoiceCell *> *)loadedCells windowCapability:(SDLWindowCapability *)windowCapability {
    if (cellsToUpload.count == 0) { return; }

    // If we're on < RPC 7.1, all primary texts need to be unique, so we don't need to check removed properties and duplicate cells
    // On > RPC 7.1, at this point all cells are unique when considering all properties, but we also need to check if any cells will _appear_ as duplicates when displayed on the screen. To check that, we'll remove properties from the set cells based on the system capabilities (we probably don't need to consider them changing between now and when they're actually sent to the HU) and check for uniqueness again. Then we'll add unique identifiers to primary text if there are duplicates. Then we transfer the primary text identifiers back to the main cells and add those to an operation to be sent.
    NSArray<SDLChoiceCell *> *strippedCellsToUpload = [[NSArray alloc] initWithArray:cellsToUpload.array copyItems:YES];
    NSArray<SDLChoiceCell *> *strippedLoadedCells = [[NSArray alloc] initWithArray:loadedCells.allObjects copyItems:YES];
    BOOL supportsChoiceUniqueness = [[SDLGlobals sharedGlobals].rpcVersion isGreaterThanOrEqualToVersion:[SDLVersion versionWithMajor:7 minor:1 patch:0]];
    if (supportsChoiceUniqueness) {
        [self sdl_removeUnusedProperties:strippedCellsToUpload basedOnWindowCapability:windowCapability];
        [self sdl_removeUnusedProperties:strippedLoadedCells basedOnWindowCapability:windowCapability];
    }

    // Now remove duplicate cells that are already on the head unit, then add unique names to the ones to upload
    [self sdl_addUniqueNamesToCells:strippedCellsToUpload loadedCells:strippedLoadedCells supportsChoiceUniqueness:supportsChoiceUniqueness];
    [self sdl_transferUniqueNamesFromCells:strippedCellsToUpload toCells:cellsToUpload];
}

+ (void)updateChoiceSet:(SDLChoiceSet *)choiceSet withLoadedCells:(NSSet<SDLChoiceCell *> *)loadedCells cellsToUpload:(NSSet<SDLChoiceCell *> *)cellsToUpload {
    NSMutableArray<SDLChoiceCell *> *choiceSetCells = [NSMutableArray array];
    for (SDLChoiceCell *cell in choiceSet.choices) {
        [choiceSetCells addObject:([loadedCells member:cell] ?: [cellsToUpload member:cell])];
    }

    choiceSet.choices = [choiceSetCells copy];
}

+ (void)sdl_removeUnusedProperties:(NSArray<SDLChoiceCell *> *)choiceCells basedOnWindowCapability:(SDLWindowCapability *)windowCapability {
    for (SDLChoiceCell *cell in choiceCells) {
        // Strip away fields that cannot be used to determine uniqueness visually including fields not supported by the HMI
        cell.voiceCommands = nil;

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
+ (void)sdl_addUniqueNamesToCells:(NSArray<SDLChoiceCell *> *)cellsToUpload loadedCells:(NSArray<SDLChoiceCell *> *)loadedCells supportsChoiceUniqueness:(BOOL)supportsChoiceUniqueness {
    // Tracks how many of each cell primary text there are so that we can append numbers to make each unique as necessary
    NSMutableDictionary<id<NSCopying>, NSMutableArray<NSNumber *> *> *dictCounter = [[NSMutableDictionary alloc] init];

    // Include cells from loaded cells to ensure that new cells get the correct title
    for (SDLChoiceCell *loadedCell in loadedCells) {
        id<NSCopying> cellKey = supportsChoiceUniqueness ? loadedCell : loadedCell.text;
        NSNumber *cellUniqueId = @(loadedCell.uniqueTextId);
        if (dictCounter[cellKey] == nil) {
            dictCounter[cellKey] = [NSMutableArray arrayWithObject:cellUniqueId];
        } else {
            [dictCounter[cellKey] addObject:cellUniqueId];
        }
    }

    // Sort the arrays so that the numbers are in order
    for (id<NSCopying> cellKey in dictCounter.keyEnumerator) {
        [dictCounter[cellKey] sortUsingComparator:^NSComparisonResult(NSNumber *_Nonnull obj1, NSNumber *_Nonnull obj2) {
            if (obj1.unsignedIntegerValue > obj2.unsignedIntegerValue) { return NSOrderedDescending; }
            if (obj1.unsignedIntegerValue < obj2.unsignedIntegerValue) { return NSOrderedAscending; }

            return NSOrderedSame;
        }];
    }

    // Run through cellsToUpload and add unique text as needed
    for (SDLChoiceCell *cell in cellsToUpload) {
        id<NSCopying> cellKey = supportsChoiceUniqueness ? cell : cell.text;
        if (dictCounter[cellKey] == nil) {
            dictCounter[cellKey] = [NSMutableArray arrayWithObject:@(cell.uniqueTextId)];
        } else {
            // There are already some duplicates, loop through to find the lowest unused duplicate number
            NSUInteger lowestMissingUniqueId = dictCounter[cellKey].lastObject.unsignedIntegerValue + 1;
            for (NSUInteger i = 1; i < dictCounter[cellKey].count + 1; i++) {
                if (i != dictCounter[cellKey][i - 1].unsignedIntegerValue) {
                    lowestMissingUniqueId = i;
                    break;
                }
            }

            cell.uniqueTextId = lowestMissingUniqueId;
            [dictCounter[cellKey] insertObject:@(cell.uniqueTextId) atIndex:(cell.uniqueTextId - 1)];
        }
    }
}

+ (void)sdl_transferUniqueNamesFromCells:(NSArray<SDLChoiceCell *> *)fromCells toCells:(NSOrderedSet<SDLChoiceCell *> *)toCells {
    for (NSUInteger i = 0; i < fromCells.count; i++) {
        toCells[i].uniqueTextId = fromCells[i].uniqueTextId;
    }
}

@end

NS_ASSUME_NONNULL_END
