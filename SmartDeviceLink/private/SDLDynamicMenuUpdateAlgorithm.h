//
//  SDLMenuUpdateAlgorithm.h
//  SmartDeviceLink
//
//  Created by Justin Gluck on 5/14/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLDynamicMenuUpdateRunScore;
@class SDLMenuCell;

NS_ASSUME_NONNULL_BEGIN

/// Menu cell state
///
/// Cell state that tells the menu manager what it should do with a given SDLMenuCell
typedef NS_ENUM(NSUInteger, MenuCellState) {
    /// Marks the cell to be deleted
    MenuCellStateDelete = 0,

    /// Marks the cell to be added
    MenuCellStateAdd,

    /// Marks the cell to be kept
    MenuCellStateKeep
};

@interface SDLDynamicMenuUpdateAlgorithm : NSObject

/**
 Compares the old and the new menus to find the best combination of add and delete commands

 @param oldMenuCells The old menu array
 @param updatedMenuCells The new menu array
 */
+ (nullable SDLDynamicMenuUpdateRunScore *)compareOldMenuCells:(NSArray<SDLMenuCell *> *)oldMenuCells updatedMenuCells:(NSArray<SDLMenuCell *> *)updatedMenuCells;

@end

NS_ASSUME_NONNULL_END
