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

/// Finds and returns the command id for a given RPC request, assuming that request is an SDLDeleteSubMenu, SDLDeleteCommand, SDLAddSubMenu, or SDLAddCommand
/// @param request The request
+ (UInt32)commandIdForRPCRequest:(SDLRPCRequest *)request;

/// Finds and returns the position for a given RPC request, assuming that request is an SDLAddSubMenu, or SDLAddCommand
/// @param request The request
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

/// Find the menu cell given a command id and remove it from the list (or a cell in the list's subcell list, etc.)
/// @param menuCellList The list to mutate and remove the item from
/// @param commandId The id of the cell to find and remove
/// @return YES if the cell was found and removed successfully, NO if it was not
+ (BOOL)removeMenuCellFromList:(NSMutableArray<SDLMenuCell *> *)menuCellList withCmdId:(UInt32)commandId;

/// Finds a menu cell from newMenuList with the given commandId and inserts it into the main menu list (or a subcell list) at the given position
/// @param commandId The command id for the cell to be found
/// @param position The position to insert the cell into the appropriate list for it to be in
/// @param newMenuList The complete requested new menu list. We will find the cell to insert from this list.
/// @param mainMenuList The mutable main menu list. The place to insert the cell will be in this list or one of its cell's subcell list (or one of it's cell's subcell's subcell's list, etc.)
/// @return YES if the cell was added successfully, NO if the cell was not
+ (BOOL)addMenuRequestWithCommandId:(UInt32)commandId position:(UInt16)position fromNewMenuList:(NSArray<SDLMenuCell *> *)newMenuList toMainMenuList:(NSMutableArray <SDLMenuCell *> *)mainMenuList;

@end

NS_ASSUME_NONNULL_END
