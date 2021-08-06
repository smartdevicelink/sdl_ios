//
//  SDLMenuReplaceUtilities.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/22/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLMenuReplaceUtilities.h"

#import "SDLAddCommand.h"
#import "SDLAddSubMenu.h"
#import "SDLArtwork.h"
#import "SDLDeleteCommand.h"
#import "SDLDeleteSubMenu.h"
#import "SDLFileManager.h"
#import "SDLImage.h"
#import "SDLImageFieldName.h"
#import "SDLMenuCell.h"
#import "SDLMenuParams.h"
#import "SDLMenuManagerPrivateConstants.h"
#import "SDLRPCRequest.h"
#import "SDLWindowCapability.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"

@interface SDLMenuCell()

@property (assign, nonatomic) UInt32 parentCellId;
@property (assign, nonatomic) UInt32 cellId;
@property (copy, nonatomic, readwrite, nullable) NSArray<SDLMenuCell *> *subCells;

@end

@implementation SDLMenuReplaceUtilities

#pragma mark Artworks

+ (NSArray<SDLArtwork *> *)findAllArtworksToBeUploadedFromCells:(NSArray<SDLMenuCell *> *)cells fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability {
    if (![windowCapability hasImageFieldOfName:SDLImageFieldNameCommandIcon]) { return @[]; }

    NSMutableSet<SDLArtwork *> *mutableArtworks = [NSMutableSet set];
    for (SDLMenuCell *cell in cells) {
        if ((cell.icon != nil) && [fileManager fileNeedsUpload:cell.icon]) {
            [mutableArtworks addObject:cell.icon];
        }

        if (cell.subCells.count > 0) {
            [mutableArtworks addObjectsFromArray:[self findAllArtworksToBeUploadedFromCells:cell.subCells fileManager:fileManager windowCapability:windowCapability]];
        }
    }

    return [mutableArtworks allObjects];
}

/// If there is an icon and the icon has been uploaded, or if the icon is a static icon, it should include the image
+ (BOOL)sdl_shouldCellIncludeImageFromCell:(SDLMenuCell *)cell fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability {
    BOOL supportsImage = (cell.subCells != nil) ? [windowCapability hasImageFieldOfName:SDLImageFieldNameSubMenuIcon] : [windowCapability hasImageFieldOfName:SDLImageFieldNameCommandIcon];
    return (cell.icon != nil) && supportsImage && ([fileManager hasUploadedFile:cell.icon] || cell.icon.isStaticIcon);
}

/// If there is an icon and the icon has been uploaded, or if the icon is a static icon, it should include the image
+ (BOOL)sdl_shouldCellIncludeSecondaryImageFromCell:(SDLMenuCell *)cell fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability {
    BOOL supportsImage = (cell.subCells != nil) ? [windowCapability hasImageFieldOfName:SDLImageFieldNameMenuSubMenuSecondaryImage] : [windowCapability hasImageFieldOfName:SDLImageFieldNameMenuCommandSecondaryImage];
    return (cell.secondaryArtwork != nil) && supportsImage && ([fileManager hasUploadedFile:cell.secondaryArtwork] || cell.secondaryArtwork.isStaticIcon);
}

#pragma mark - RPC Commands

+ (UInt32)commandIdForRPCRequest:(SDLRPCRequest *)request {
    UInt32 commandId = 0;
    if ([request isMemberOfClass:[SDLAddCommand class]]) {
        commandId = ((SDLAddCommand *)request).cmdID.unsignedIntValue;
    } else if ([request isMemberOfClass:[SDLAddSubMenu class]]) {
        commandId = ((SDLAddSubMenu *)request).menuID.unsignedIntValue;
    } else if ([request isMemberOfClass:[SDLDeleteCommand class]]) {
        commandId = ((SDLDeleteCommand *)request).cmdID.unsignedIntValue;
    } else if ([request isMemberOfClass:[SDLDeleteSubMenu class]]) {
        commandId = ((SDLDeleteSubMenu *)request).menuID.unsignedIntValue;
    }

    return commandId;
}

+ (UInt16)positionForRPCRequest:(SDLRPCRequest *)request {
    UInt16 position = 0;
    if ([request isMemberOfClass:[SDLAddCommand class]]) {
        position = ((SDLAddCommand *)request).menuParams.position.unsignedShortValue;
    } else if ([request isMemberOfClass:[SDLAddSubMenu class]]) {
        position = ((SDLAddSubMenu *)request).position.unsignedShortValue;
    }

    return position;
}

+ (NSArray<SDLRPCRequest *> *)deleteCommandsForCells:(NSArray<SDLMenuCell *> *)cells {
    NSMutableArray<SDLRPCRequest *> *mutableDeletes = [NSMutableArray array];
    for (SDLMenuCell *cell in cells) {
        if (cell.subCells != nil) {
            SDLDeleteSubMenu *delete = [[SDLDeleteSubMenu alloc] initWithId:cell.cellId];
            [mutableDeletes addObject:delete];
        } else {
            SDLDeleteCommand *delete = [[SDLDeleteCommand alloc] initWithId:cell.cellId];
            [mutableDeletes addObject:delete];
        }
    }

    return [mutableDeletes copy];
}

+ (NSArray<SDLRPCRequest *> *)mainMenuCommandsForCells:(NSArray<SDLMenuCell *> *)cells fileManager:(SDLFileManager *)fileManager usingIndexesFrom:(NSArray<SDLMenuCell *> *)menu windowCapability:(SDLWindowCapability *)windowCapability defaultSubmenuLayout:(SDLMenuLayout)defaultSubmenuLayout {
    NSMutableArray<SDLRPCRequest *> *mutableCommands = [NSMutableArray array];
    for (NSUInteger menuInteger = 0; menuInteger < menu.count; menuInteger++) {
        for (NSUInteger updateCellsIndex = 0; updateCellsIndex < cells.count; updateCellsIndex++) {
            if ([menu[menuInteger] isEqual:cells[updateCellsIndex]]) {
                if (cells[updateCellsIndex].subCells != nil) {
                    [mutableCommands addObject:[self sdl_subMenuCommandForMenuCell:cells[updateCellsIndex] fileManager:fileManager position:(UInt16)menuInteger windowCapability:windowCapability defaultSubmenuLayout:defaultSubmenuLayout]];
                } else {
                    [mutableCommands addObject:[self sdl_commandForMenuCell:cells[updateCellsIndex] fileManager:fileManager windowCapability:windowCapability position:(UInt16)menuInteger]];
                }
                break;
            }
        }
    }

    return [mutableCommands copy];
}

+ (NSArray<SDLRPCRequest *> *)subMenuCommandsForCells:(NSArray<SDLMenuCell *> *)cells fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability defaultSubmenuLayout:(SDLMenuLayout)defaultSubmenuLayout {
    NSMutableArray<SDLRPCRequest *> *mutableCommands = [NSMutableArray array];
    for (SDLMenuCell *cell in cells) {
        if (cell.subCells != nil) {
            [mutableCommands addObjectsFromArray:[self sdl_allCommandsForCells:cell.subCells fileManager:fileManager windowCapability:windowCapability defaultSubmenuLayout:defaultSubmenuLayout]];
        }
    }

    return [mutableCommands copy];
}

#pragma mark Private Helpers

+ (NSArray<SDLRPCRequest *> *)sdl_allCommandsForCells:(NSArray<SDLMenuCell *> *)cells fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability defaultSubmenuLayout:(SDLMenuLayout)defaultSubmenuLayout {
    NSMutableArray<SDLRPCRequest *> *mutableCommands = [NSMutableArray array];

    for (NSUInteger cellIndex = 0; cellIndex < cells.count; cellIndex++) {
        if (cells[cellIndex].subCells != nil) {
            [mutableCommands addObject:[self sdl_subMenuCommandForMenuCell:cells[cellIndex] fileManager:fileManager position:(UInt16)cellIndex windowCapability:windowCapability defaultSubmenuLayout:defaultSubmenuLayout]];
            [mutableCommands addObjectsFromArray:[self sdl_allCommandsForCells:cells[cellIndex].subCells fileManager:fileManager windowCapability:windowCapability defaultSubmenuLayout:defaultSubmenuLayout]];
        } else {
            [mutableCommands addObject:[self sdl_commandForMenuCell:cells[cellIndex] fileManager:fileManager windowCapability:windowCapability position:(UInt16)cellIndex]];
        }
    }

    return [mutableCommands copy];
}

+ (SDLAddCommand *)sdl_commandForMenuCell:(SDLMenuCell *)cell fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability position:(UInt16)position {
    SDLAddCommand *command = [[SDLAddCommand alloc] init];

    SDLMenuParams *params = [[SDLMenuParams alloc] init];
    params.menuName = cell.uniqueTitle;
    params.secondaryText = ([windowCapability hasTextFieldOfName:SDLTextFieldNameMenuCommandSecondaryText] && cell.secondaryText.length > 0) ? cell.secondaryText : nil;
    params.tertiaryText = ([windowCapability hasTextFieldOfName:SDLTextFieldNameMenuCommandTertiaryText]  && cell.tertiaryText.length > 0) ? cell.tertiaryText : nil;
    params.parentID = (cell.parentCellId != ParentIdNotFound) ? @(cell.parentCellId) : nil;
    params.position = @(position);

    command.menuParams = params;
    command.vrCommands = (cell.voiceCommands.count == 0) ? nil : cell.voiceCommands;
    command.cmdIcon = [self sdl_shouldCellIncludeImageFromCell:cell fileManager:fileManager windowCapability:windowCapability] ? cell.icon.imageRPC : nil;
    command.secondaryImage = [self sdl_shouldCellIncludeSecondaryImageFromCell:cell fileManager:fileManager windowCapability:windowCapability] ? cell.secondaryArtwork.imageRPC : nil;
    command.cmdID = @(cell.cellId);

    return command;
}

+ (SDLAddSubMenu *)sdl_subMenuCommandForMenuCell:(SDLMenuCell *)cell fileManager:(SDLFileManager *)fileManager position:(UInt16)position windowCapability:(SDLWindowCapability *)windowCapability defaultSubmenuLayout:(SDLMenuLayout)defaultSubmenuLayout {
    NSString *secondaryText = ([windowCapability hasTextFieldOfName:SDLTextFieldNameMenuCommandSecondaryText] && cell.secondaryText.length > 0) ? cell.secondaryText : nil;
    NSString *tertiaryText = ([windowCapability hasTextFieldOfName:SDLTextFieldNameMenuCommandTertiaryText]  && cell.tertiaryText.length > 0) ? cell.tertiaryText : nil;
    SDLImage *icon = [self sdl_shouldCellIncludeImageFromCell:cell fileManager:fileManager windowCapability:windowCapability] ? cell.icon.imageRPC : nil;
    SDLImage *secondaryIcon = [self sdl_shouldCellIncludeSecondaryImageFromCell:cell fileManager:fileManager windowCapability:windowCapability] ? cell.secondaryArtwork.imageRPC : nil;

    SDLMenuLayout submenuLayout = nil;
    if (cell.submenuLayout && [windowCapability.menuLayoutsAvailable containsObject:cell.submenuLayout]) {
        submenuLayout = cell.submenuLayout;
    } else {
        submenuLayout = defaultSubmenuLayout;
    }

    return [[SDLAddSubMenu alloc] initWithMenuID:cell.cellId menuName:cell.uniqueTitle position:@(position) menuIcon:icon menuLayout:submenuLayout parentID:nil secondaryText:secondaryText tertiaryText:tertiaryText secondaryImage:secondaryIcon];
}

#pragma mark - Updating Menu Cells

#pragma mark Remove Cell

+ (BOOL)removeMenuCellFromList:(NSMutableArray<SDLMenuCell *> *)menuCellList withCmdId:(UInt32)commandId {
    for (SDLMenuCell *menuCell in menuCellList) {
        if (menuCell.cellId == commandId) {
            // If the cell id matches the command id, remove it from the list and return
            [menuCellList removeObject:menuCell];
            return YES;
        } else if (menuCell.subCells.count > 0) {
            // If the menu cell has subcells, we need to recurse and check the subcells
            NSMutableArray<SDLMenuCell *> *newList = [menuCell.subCells mutableCopy];
            BOOL foundAndRemovedItem = [self removeMenuCellFromList:newList withCmdId:commandId];
            if (foundAndRemovedItem) {
                menuCell.subCells = [newList copy];
                return YES;
            }
        }
    }

    return NO;
}

#pragma mark Inserting Cell

+ (BOOL)addMenuRequestWithCommandId:(UInt32)commandId position:(UInt16)position fromNewMenuList:(NSArray<SDLMenuCell *> *)newMenuList toMainMenuList:(NSMutableArray <SDLMenuCell *> *)mainMenuList {
    SDLMenuCell *addedCell = nil;
    for (SDLMenuCell *cell in newMenuList) {
        if (cell.cellId == commandId) {
            addedCell = cell;
            break;
        } else if (cell.subCells.count > 0) {
            BOOL success = [self addMenuRequestWithCommandId:commandId position:position fromNewMenuList:cell.subCells toMainMenuList:mainMenuList];
            if (success) { return YES; }
        }
    }

    if (addedCell != nil) {
        return [self sdl_addMenuCell:addedCell toList:mainMenuList atPosition:position];
    }

    return NO;
}

+ (BOOL)sdl_addMenuCell:(SDLMenuCell *)cell toList:(NSMutableArray<SDLMenuCell *> *)menuCellList atPosition:(UInt16)position {
    if (cell.parentCellId != ParentIdNotFound) {
        // If the cell has a parent id, we need to find the cell with a matching cell id and insert it into its submenu
        for (SDLMenuCell *menuCell in menuCellList) {
            if (menuCell.cellId == cell.parentCellId) {
                // If we found the correct submenu, insert it into that submenu
                NSMutableArray<SDLMenuCell *> *newList = nil;
                if (menuCell.subCells != nil) {
                    newList = [menuCell.subCells mutableCopy];
                } else {
                    newList = [NSMutableArray array];
                }

                [self sdl_insertMenuCell:cell intoList:newList atPosition:position];
                menuCell.subCells = [newList copy];
                return YES;
            } else if (menuCell.subCells.count > 0) {
                // Check the subcells of this cell to see if any of those have cell ids that match the parent cell id
                NSMutableArray<SDLMenuCell *> *newList = [menuCell.subCells mutableCopy];
                BOOL foundAndAddedItem = [self sdl_addMenuCell:cell toList:newList atPosition:position];
                if (foundAndAddedItem) {
                    menuCell.subCells = [newList copy];
                    return YES;
                }
            }
        }

        return NO;
    } else {
        // The cell does not have a parent id, just insert it into the main menu
        [self sdl_insertMenuCell:cell intoList:menuCellList atPosition:position];
        return YES;
    }
}

+ (void)sdl_insertMenuCell:(SDLMenuCell *)cell intoList:(NSMutableArray<SDLMenuCell *> *)cellList atPosition:(UInt16)position {
    SDLMenuCell *cellToInsert = cell;
    if (cellToInsert.subCells != nil) {
        cellToInsert = [cell copy];
        cellToInsert.subCells = @[];
    }

    if (position > cellList.count) {
        [cellList addObject:cell];
    } else {
        [cellList insertObject:cell atIndex:position];
    }
}

@end
