//
//  SDLMenuUpdateAlgorithm.m
//  SmartDeviceLink
//
//  Created by Justin Gluck on 5/14/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLDynamicMenuUpdateAlgorithm.h"
#import "SDLDynamicMenuUpdateRunScore.h"
#import "SDLMenuCell.h"
#import "SDLLogMacros.h"
#import "SDLWindowCapability.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuCell ()

- (BOOL)isEqualToCellWithUniqueTitle:(SDLMenuCell *)cell;

@end

@implementation SDLDynamicMenuUpdateAlgorithm

#pragma mark Compatibility Menu Run Score

+ (SDLDynamicMenuUpdateRunScore *)compatibilityRunScoreWithOldMenuCells:(NSArray<SDLMenuCell *> *)oldMenuCells updatedMenuCells:(NSArray<SDLMenuCell *> *)updatedMenuCells {
    return [[SDLDynamicMenuUpdateRunScore alloc] initWithOldStatus:[self sdl_buildAllDeleteStatusesForMenu:oldMenuCells] updatedStatus:[self sdl_buildAllAddStatusesForMenu:updatedMenuCells] score:updatedMenuCells.count];
}

#pragma mark - Dynamic Menu Run Score

+ (SDLDynamicMenuUpdateRunScore *)dynamicRunScoreOldMenuCells:(NSArray<SDLMenuCell *> *)oldMenuCells updatedMenuCells:(NSArray<SDLMenuCell *> *)updatedMenuCells {
    if (oldMenuCells.count > 0 && updatedMenuCells.count == 0) {
        // Deleting all cells
        return [[SDLDynamicMenuUpdateRunScore alloc] initWithOldStatus:[SDLDynamicMenuUpdateAlgorithm sdl_buildAllDeleteStatusesForMenu:oldMenuCells] updatedStatus:@[] score:0];
    }else if (oldMenuCells.count == 0 && updatedMenuCells.count > 0) {
        // No cells to delete
        return [[SDLDynamicMenuUpdateRunScore alloc] initWithOldStatus:@[] updatedStatus:[SDLDynamicMenuUpdateAlgorithm sdl_buildAllAddStatusesForMenu:updatedMenuCells] score:updatedMenuCells.count];
    } else if (oldMenuCells.count == 0 && updatedMenuCells.count == 0) {
        // Empty menu to empty menu
        return [[SDLDynamicMenuUpdateRunScore alloc] initWithOldStatus:@[] updatedStatus:@[] score:0];
    }

   return [SDLDynamicMenuUpdateAlgorithm sdl_startCompareAtRun:0 oldMenuCells:oldMenuCells updatedMenuCells:updatedMenuCells];
}

+ (SDLDynamicMenuUpdateRunScore *)sdl_startCompareAtRun:(NSUInteger)startRun oldMenuCells:(NSArray<SDLMenuCell *> *)oldMenuCells updatedMenuCells:(NSArray<SDLMenuCell *> *)updatedMenuCells {
    SDLDynamicMenuUpdateRunScore *bestScore = [[SDLDynamicMenuUpdateRunScore alloc] initWithOldStatus:@[] updatedStatus:@[] score:0];

    for (NSUInteger run = startRun; run < oldMenuCells.count; run++) {
        // Set the menu status as a 1-1 array, start off will oldMenus = all Deletes, newMenu = all Adds
        NSMutableArray<NSNumber *> *oldMenuStatus = [SDLDynamicMenuUpdateAlgorithm sdl_buildAllDeleteStatusesForMenu:oldMenuCells];
        NSMutableArray<NSNumber *> *newMenuStatus = [SDLDynamicMenuUpdateAlgorithm sdl_buildAllAddStatusesForMenu:updatedMenuCells];

        NSUInteger startIndex = 0;
        for (NSUInteger oldCellIndex = run; oldCellIndex < oldMenuCells.count; oldCellIndex++) { //For each old item
            // Create inner loop to compare old cells to new cells to find a match, if a match if found we mark the index at match for both the old and the new status to keep since we do not want to send RPCs for those cases
            for (NSUInteger newCellIndex = startIndex; newCellIndex < updatedMenuCells.count; newCellIndex++) {
                if ([oldMenuCells[oldCellIndex] isEqualToCellWithUniqueTitle:updatedMenuCells[newCellIndex]]) {
                    oldMenuStatus[oldCellIndex] = @(SDLMenuCellUpdateStateKeep);
                    newMenuStatus[newCellIndex] = @(SDLMenuCellUpdateStateKeep);
                    startIndex = newCellIndex + 1;
                    break;
                }
            }
        }

        // Add RPC are the biggest operation so we need to find the run with the least amount of Adds. We will reset the run we use each time a runscore is less than the current score.
        NSUInteger numberOfAdds = 0;
        for (NSUInteger status = 0; status < newMenuStatus.count; status++) {
            // 0 = Delete   1 = Add    2 = Keep
            if (newMenuStatus[status].integerValue == SDLMenuCellUpdateStateAdd) {
                numberOfAdds++;
            }
        }

        // As soon as we a run that requires 0 Adds we will use it since we cant do better then 0
        if (numberOfAdds == 0) {
            return [[SDLDynamicMenuUpdateRunScore alloc] initWithOldStatus:oldMenuStatus updatedStatus:newMenuStatus score:numberOfAdds];
        }
        // if we havent create the bestScore object or if the current score beats the old score then we will create a new bestScore
        if (bestScore == nil || numberOfAdds < bestScore.score) {
            bestScore = [[SDLDynamicMenuUpdateRunScore alloc] initWithOldStatus:oldMenuStatus updatedStatus:newMenuStatus score:numberOfAdds];
        }
    }

    return bestScore;
}

/**
 Builds a 1-1 array of Deletes for every element in the array

 @param oldMenu The old menu array
 */
+ (NSMutableArray<NSNumber *> *)sdl_buildAllDeleteStatusesForMenu:(NSArray<SDLMenuCell *> *)oldMenu {
    NSMutableArray<NSNumber *> *oldMenuStatus = [[NSMutableArray alloc] initWithCapacity:oldMenu.count];
    for (NSUInteger index = 0; index < oldMenu.count; index++) {
        [oldMenuStatus addObject:@(SDLMenuCellUpdateStateDelete)];
    }
    return oldMenuStatus;
}

/**
 Builds a 1-1 array of Adds for every element in the array

 @param newMenu The new menu array
 */
+ (NSMutableArray<NSNumber *> *)sdl_buildAllAddStatusesForMenu:(NSArray<SDLMenuCell *> *)newMenu {
    NSMutableArray<NSNumber *> *newMenuStatus = [[NSMutableArray alloc] initWithCapacity:newMenu.count];
    for (NSUInteger index = 0; index < newMenu.count; index++) {
        [newMenuStatus addObject:@(SDLMenuCellUpdateStateAdd)];
    }
    return newMenuStatus;
}

@end

NS_ASSUME_NONNULL_END
