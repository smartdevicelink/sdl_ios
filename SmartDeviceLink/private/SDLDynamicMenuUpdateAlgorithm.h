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
@class SDLWindowCapability;

NS_ASSUME_NONNULL_BEGIN

/// Menu cell state
///
/// Cell state that tells the menu manager what it should do with a given SDLMenuCell
typedef NS_ENUM(NSUInteger, SDLMenuCellUpdateState) {
    /// Marks the cell to be deleted
    SDLMenuCellUpdateStateDelete = 0,

    /// Marks the cell to be added
    SDLMenuCellUpdateStateAdd,

    /// Marks the cell to be kept
    SDLMenuCellUpdateStateKeep
};

@interface SDLDynamicMenuUpdateAlgorithm : NSObject

/**
 Compares the old and the new menus to find the best combination of add and delete commands

 @param oldMenuCells The old menu array
 @param updatedMenuCells The new menu array
 */
+ (SDLDynamicMenuUpdateRunScore *)dynamicRunScoreOldMenuCells:(NSArray<SDLMenuCell *> *)oldMenuCells updatedMenuCells:(NSArray<SDLMenuCell *> *)updatedMenuCells;

+ (SDLDynamicMenuUpdateRunScore *)compatibilityRunScoreWithOldMenuCells:(NSArray<SDLMenuCell *> *)oldMenuCells updatedMenuCells:(NSArray<SDLMenuCell *> *)updatedMenuCells;

@end

NS_ASSUME_NONNULL_END
