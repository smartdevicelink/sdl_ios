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

@interface SDLMenuReplaceUtilities : NSObject

+ (NSArray<SDLRPCRequest *> *)deleteCommandsForCells:(NSArray<SDLMenuCell *> *)cells;

/**
 This method will receive the cells to be added and the updated menu array. It will then build an array of add commands using the correct index to position the new items in the correct location.

 @param cells that will be added to the menu, this array must contain only cells that are not already in the menu.
 @param shouldHaveArtwork artwork bool
 @param menu the new menu array, this array should contain all the values the develeoper has set to be included in the new menu. This is used for placing the newly added cells in the correct locaiton.
 e.g. If the new menu array is [A, B, C, D] but only [C, D] are new we need to pass [A, B , C , D] so C and D can be added to index 2 and 3 respectively.
 @return list of SDLRPCRequest addCommands
 */
+ (NSArray<SDLRPCRequest *> *)mainMenuCommandsForCells:(NSArray<SDLMenuCell *> *)cells withArtwork:(BOOL)shouldHaveArtwork usingIndexesFrom:(NSArray<SDLMenuCell *> *)menu availableMenuLayouts:(NSArray<SDLMenuLayout> *)availableMenuLayouts defaultSubmenuLayout:(SDLMenuLayout)defaultSubmenuLayout;
+ (NSArray<SDLRPCRequest *> *)subMenuCommandsForCells:(NSArray<SDLMenuCell *> *)cells withArtwork:(BOOL)shouldHaveArtwork availableMenuLayouts:(NSArray<SDLMenuLayout> *)availableMenuLayouts defaultSubmenuLayout:(SDLMenuLayout)defaultSubmenuLayout;

+ (NSArray<SDLArtwork *> *)findAllArtworksToBeUploadedFromCells:(NSArray<SDLMenuCell *> *)cells fileManager:(SDLFileManager *)fileManager windowCapability:(SDLWindowCapability *)windowCapability;
+ (BOOL)shouldRPCsIncludeImages:(NSArray<SDLMenuCell *> *)cells fileManager:(SDLFileManager *)fileManager;

@end

NS_ASSUME_NONNULL_END
