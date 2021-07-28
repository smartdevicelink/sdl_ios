//
//  SDLMenuReplaceOperation+MenuUniqueness.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 7/28/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLMenuReplaceOperation+MenuUniqueness.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLMenuReplaceOperation (MenuUniqueness)

+ (void)sdl_addUniqueNamesToCells:(NSArray<SDLMenuCell *> *)menuCells basedOnWindowCapability:(SDLWindowCapability *)windowCapability {
    SDLVersion *supportsMenuUniqueness = [[SDLVersion alloc] initWithMajor:7 minor:1 patch:0];
    if ([[SDLGlobals sharedGlobals].rpcVersion isGreaterThanOrEqualToVersion:supportsMenuUniqueness]) {
        [self sdl_removeUnusedProperties:menuCells basedOnWindowCapability:windowCapability];
    }

    [self sdl_addUniqueNamesToCells:menuCells supportsMenuUniqueness:supportsMenuUniqueness];
}

+ (void)sdl_removeUnusedProperties:(NSArray<SDLMenuCell *> *)menuCells basedOnWindowCapability:(SDLWindowCapability *)windowCapability {
    NSArray<SDLMenuCell *> *removePropertiesCopy = [[NSArray alloc] initWithArray:menuCells copyItems:YES];
    for (SDLMenuCell *cell in removePropertiesCopy) {
        // Strip away fields that cannot be used to determine uniqueness visually including fields not supported by the HMI
        cell.voiceCommands = nil;

        // Don't check SDLImageFieldNameSubMenuIcon because it was added in 7.0 when the feature was added in 5.0. Just assume that if CommandIcon is not available, the submenu icon is not either.
        if (![windowCapability hasImageFieldOfName:SDLImageFieldNameCommandIcon]) {
            cell.icon = nil;
        }

        if (cell.subCells != nil) {
            if (![windowCapability hasTextFieldOfName:SDLTextFieldNameMenuSubMenuSecondaryText]) {
                cell.secondaryText = nil;
            }
            if (![windowCapability hasTextFieldOfName:SDLTextFieldNameMenuSubMenuTertiaryText]) {
                cell.tertiaryText = nil;
            }
            if (![windowCapability hasImageFieldOfName:SDLImageFieldNameMenuSubMenuSecondaryImage]) {
                cell.secondaryArtwork = nil;
            }
            [self sdl_removeUnusedProperties:cell.subCells basedOnWindowCapability:windowCapability];
        } else {
            if (![windowCapability hasTextFieldOfName:SDLTextFieldNameMenuCommandSecondaryText]) {
                cell.secondaryText = nil;
            }
            if (![windowCapability hasTextFieldOfName:SDLTextFieldNameMenuCommandTertiaryText]) {
                cell.tertiaryText = nil;
            }
            if (![windowCapability hasImageFieldOfName:SDLImageFieldNameMenuCommandSecondaryImage]) {
                cell.secondaryArtwork = nil;
            }
        }
    }
}

+ (void)sdl_addUniqueNamesToCells:(NSArray<SDLMenuCell *> *)menuCells supportsMenuUniqueness:(BOOL)supportsMenuUniqueness {
    // Tracks how many of each cell primary text there are so that we can append numbers to make each unique as necessary
    NSMutableDictionary<SDLMenuCell *, NSNumber *> *dictCounter = [[NSMutableDictionary alloc] init];
    for (NSUInteger i = 0; i < menuCells.count; i++) {
        SDLMenuCell *cell = menuCells[i];
        NSNumber *counter = dictCounter[cell];
        if (counter != nil) {
            counter = @(counter.intValue + 1);
            dictCounter[cell] = counter;
        } else {
            dictCounter[cell] = @1;
        }

        counter = dictCounter[cell];
        if (counter.intValue > 1) {
            menuCells[i].uniqueTitle = [NSString stringWithFormat: @"%@ (%d)", menuCells[i].title, counter.intValue];
        }

        if (cell.subCells.count > 0) {
            [self sdl_addUniqueNamesToCells:menuCells supportsMenuUniqueness:supportsMenuUniqueness];
        }
    }
}

@end

NS_ASSUME_NONNULL_END
