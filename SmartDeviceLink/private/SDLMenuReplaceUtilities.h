//
//  SDLMenuReplaceUtilities.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/22/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLMenuLayout.h"

@class SDLArtwork;
@class SDLFileManager;
@class SDLMenuCell;
@class SDLRPCRequest;
@class SDLWindowCapability;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDLCurrentMenuUpdatedBlock)(NSArray<SDLMenuCell *> *currentMenuCells);

@interface SDLMenuReplaceUtilities : NSObject

#pragma mark - Artworks

/// Finds all artworks that need to be uploaded from the given list of menu cells
/// @param cells The cells to check for artwork
/// @param fileManager The file manager to check if artworks need upload
/// @param windowCapability The window capability to check available image fields
+ (NSArray<SDLArtwork *> *)findAllArtworksToBeUploadedFromCells:(NSArray<SDLMenuCell *> *)cells fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability;

#pragma mark - RPC Commands

+ (UInt32)commandIdForRPCRequest:(SDLRPCRequest *)request;
+ (UInt16)positionForRPCRequest:(SDLRPCRequest *)request;

/// Generate SDLDeleteCommand and SDLDeleteSubMenu RPCs for the given cells
/// @param cells The cells for which to generate delete RPCs
+ (NSArray<SDLRPCRequest *> *)deleteCommandsForCells:(NSArray<SDLMenuCell *> *)cells;

/// Generate SDLAddCommand and SDLAddSubMenu RPCs for given main menu cells
/// @param cells The cells to generate AddCommand / AddSubMenu RPCs for
/// @param fileManager The file manager to use to check availability of artworks
/// @param menu The menu from which we will manage indexes
/// @param windowCapability The window capability with which to check available text fields / image fields
/// @param defaultSubmenuLayout The default submenu layout to use for displaying submenus
+ (NSArray<SDLRPCRequest *> *)mainMenuCommandsForCells:(NSArray<SDLMenuCell *> *)cells fileManager:(SDLFileManager *)fileManager usingIndexesFrom:(NSArray<SDLMenuCell *> *)menu windowCapability:(SDLWindowCapability *)windowCapability defaultSubmenuLayout:(SDLMenuLayout)defaultSubmenuLayout;

/// Generate SDLAddCommand and SDLAddSubMenu RPCs for the given submenu cells
/// @param cells The cells to generate AddCommand / AddSubMenu RPCs for
/// @param fileManager The file manager to use to check availability of artworks
/// @param windowCapability The window capability with which to check available text fields / image fields
/// @param defaultSubmenuLayout The default submenu layout to use for displaying submenus
+ (NSArray<SDLRPCRequest *> *)subMenuCommandsForCells:(NSArray<SDLMenuCell *> *)cells fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability defaultSubmenuLayout:(SDLMenuLayout)defaultSubmenuLayout;

#pragma mark - Updating Menu Cells

/// Find the menu cell given a command id and remove it from the list, then return the new list
/// @param menuCellList The list to mutate and remove the item from
/// @param commandId The id of the cell to find and remove
+ (BOOL)removeMenuCellFromList:(NSMutableArray<SDLMenuCell *> *)menuCellList withCmdId:(UInt32)commandId;

+ (BOOL)addMenuRequestWithCommandId:(UInt32)commandId position:(UInt16)position fromNewMenuList:(NSArray<SDLMenuCell *> *)newMenuList toMainMenuList:(NSMutableArray <SDLMenuCell *> *)mainMenuList;

@end

NS_ASSUME_NONNULL_END
