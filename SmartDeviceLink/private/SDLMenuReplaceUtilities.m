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
#import "SDLRPCRequest.h"
#import "SDLWindowCapability.h"
#import "SDLWindowCapability+ScreenManagerExtensions.h"

@interface SDLMenuCell()

@property (assign, nonatomic) UInt32 parentCellId;
@property (assign, nonatomic) UInt32 cellId;

@end

@implementation SDLMenuReplaceUtilities

#pragma mark Delete Commands

+ (NSArray<SDLRPCRequest *> *)deleteCommandsForCells:(NSArray<SDLMenuCell *> *)cells {
    NSMutableArray<SDLRPCRequest *> *mutableDeletes = [NSMutableArray array];
    for (SDLMenuCell *cell in cells) {
        if (cell.subCells == nil) {
            SDLDeleteCommand *delete = [[SDLDeleteCommand alloc] initWithId:cell.cellId];
            [mutableDeletes addObject:delete];
        } else {
            SDLDeleteSubMenu *delete = [[SDLDeleteSubMenu alloc] initWithId:cell.cellId];
            [mutableDeletes addObject:delete];
        }
    }

    return [mutableDeletes copy];
}

#pragma mark Artworks

+ (NSArray<SDLArtwork *> *)findAllArtworksToBeUploadedFromCells:(NSArray<SDLMenuCell *> *)cells fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability {
    if (![windowCapability hasImageFieldOfName:SDLImageFieldNameCommandIcon]) { return @[]; }

    NSMutableSet<SDLArtwork *> *mutableArtworks = [NSMutableSet set];
    for (SDLMenuCell *cell in cells) {
        if ([fileManager fileNeedsUpload:cell.icon]) {
            [mutableArtworks addObject:cell.icon];
        }

        if (cell.subCells.count > 0) {
            [mutableArtworks addObjectsFromArray:[self findAllArtworksToBeUploadedFromCells:cell.subCells fileManager:fileManager windowCapability:windowCapability]];
        }
    }

    return [mutableArtworks allObjects];
}

+ (BOOL)sdl_shouldCellIncludeImage:(SDLMenuCell *)cell fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability {
    // If there is an icon and the icon has been uploaded, or if the icon is a static icon, it should include the image
    BOOL supportsImage = (cell.subCells.count > 0) ? [windowCapability hasImageFieldOfName:SDLImageFieldNameSubMenuIcon] : [windowCapability hasImageFieldOfName:SDLImageFieldNameMenuIcon];
    return cell.icon != nil && supportsImage && ([fileManager hasUploadedFile:cell.icon] || cell.icon.isStaticIcon);
}

#pragma mark - RPC Commands

+ (NSArray<SDLRPCRequest *> *)mainMenuCommandsForCells:(NSArray<SDLMenuCell *> *)cells fileManager:(SDLFileManager *)fileManager usingIndexesFrom:(NSArray<SDLMenuCell *> *)menu windowCapability:(SDLWindowCapability *)windowCapability defaultSubmenuLayout:(SDLMenuLayout)defaultSubmenuLayout {
    NSMutableArray<SDLRPCRequest *> *mutableCommands = [NSMutableArray array];

    for (NSUInteger menuInteger = 0; menuInteger < menu.count; menuInteger++) {
        for (NSUInteger updateCellsIndex = 0; updateCellsIndex < cells.count; updateCellsIndex++) {
            if ([menu[menuInteger] isEqual:cells[updateCellsIndex]]) {
                if (cells[updateCellsIndex].subCells.count > 0) {
                    [mutableCommands addObject:[self sdl_subMenuCommandForMenuCell:cells[updateCellsIndex] fileManager:fileManager position:(UInt16)menuInteger windowCapability:windowCapability defaultSubmenuLayout:defaultSubmenuLayout]];
                } else {
                    [mutableCommands addObject:[self sdl_commandForMenuCell:cells[updateCellsIndex] fileManager:fileManager windowCapability:windowCapability position:(UInt16)menuInteger]];
                }
            }
        }
    }

    return [mutableCommands copy];
}

+ (NSArray<SDLRPCRequest *> *)subMenuCommandsForCells:(NSArray<SDLMenuCell *> *)cells fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability defaultSubmenuLayout:(SDLMenuLayout)defaultSubmenuLayout {
    NSMutableArray<SDLRPCRequest *> *mutableCommands = [NSMutableArray array];
    for (SDLMenuCell *cell in cells) {
        if (cell.subCells.count > 0) {
            [mutableCommands addObjectsFromArray:[self sdl_allCommandsForCells:cell.subCells fileManager:fileManager windowCapability:windowCapability defaultSubmenuLayout:defaultSubmenuLayout]];
        }
    }

    return [mutableCommands copy];
}

+ (NSArray<SDLRPCRequest *> *)sdl_allCommandsForCells:(NSArray<SDLMenuCell *> *)cells fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability defaultSubmenuLayout:(SDLMenuLayout)defaultSubmenuLayout {
    NSMutableArray<SDLRPCRequest *> *mutableCommands = [NSMutableArray array];

    for (NSUInteger cellIndex = 0; cellIndex < cells.count; cellIndex++) {
        if (cells[cellIndex].subCells.count > 0) {
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
    params.menuName = cell.title;
    params.parentID = cell.parentCellId != UINT32_MAX ? @(cell.parentCellId) : nil;
    params.position = @(position);

    command.menuParams = params;
    command.vrCommands = (cell.voiceCommands.count == 0) ? nil : cell.voiceCommands;
    command.cmdIcon = [self sdl_shouldCellIncludeImage:cell fileManager:fileManager windowCapability:windowCapability] ? cell.icon.imageRPC : nil;
    command.cmdID = @(cell.cellId);

    return command;
}

+ (SDLAddSubMenu *)sdl_subMenuCommandForMenuCell:(SDLMenuCell *)cell fileManager:(SDLFileManager *)fileManager position:(UInt16)position windowCapability:(SDLWindowCapability *)windowCapability defaultSubmenuLayout:(SDLMenuLayout)defaultSubmenuLayout {
    SDLImage *icon = [self sdl_shouldCellIncludeImage:cell fileManager:fileManager windowCapability:windowCapability] ? cell.icon.imageRPC : nil;

    SDLMenuLayout submenuLayout = nil;
    if (cell.submenuLayout && [windowCapability.menuLayoutsAvailable containsObject:cell.submenuLayout]) {
        submenuLayout = cell.submenuLayout;
    } else {
        submenuLayout = defaultSubmenuLayout;
    }

    return [[SDLAddSubMenu alloc] initWithMenuID:cell.cellId menuName:cell.title position:@(position) menuIcon:icon menuLayout:submenuLayout parentID:nil];
}

#pragma mark - Updating Menu Cells

+ (nullable NSMutableArray<SDLMenuCell *> *)removeMenuCellFromList:(NSMutableArray<SDLMenuCell *> *)menuCellList withCmdId:(UInt32)commandId {
    for (SDLMenuCell *menuCell in menuCellList) {
        if (menuCell.cellId == commandId) {
            [menuCellList removeObject:menuCell];
            return menuCellList;
        } else if (menuCell.subCells.count > 0) {
            NSMutableArray<SDLMenuCell *> *newList = [self sdl_removeMenuCellFromList:[menuCell.subCells mutableCopy] withCmdId:commandId];
            if (newList != nil) {
                menuCell.subCells = [newList copy];
            }
        }
    }

    return nil;
}

@end
