//
//  SDLMenuUpdateAlgorithm.m
//  SmartDeviceLink
//
//  Created by Justin Gluck on 5/14/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLMenuUpdateAlgorithm.h"
#import "SDLMenuRunScore.h"
#import "SDLMenuCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MenuCellState) {
    MenuCellStateDelete,
    MenuCellStateAdd,
    MenuCellStateKeep
};

@implementation SDLMenuUpdateAlgorithm

#pragma mark - Update Menu Cells
+ (nullable SDLMenuRunScore *)compareOldMenuCells:(NSArray<SDLMenuCell *> *)oldMenuCells updatedMenuCells:(NSArray<SDLMenuCell *> *)updatedMenuCells{
    //Compare old and new menus //Mae sure we only have 100 or less cells
    if(oldMenuCells.count && !updatedMenuCells.count) {
        return [[SDLMenuRunScore alloc] initWithOldStatus:@[] updatedStatus:[SDLMenuUpdateAlgorithm buildDeleteStatus:oldMenuCells] score:0];
    }
    if(!oldMenuCells.count && updatedMenuCells.count) {
        return [[SDLMenuRunScore alloc] initWithOldStatus:@[] updatedStatus:[SDLMenuUpdateAlgorithm buildAddStatus:updatedMenuCells] score:updatedMenuCells.count];
    }

    if(!oldMenuCells.count && !updatedMenuCells.count) {
        return nil;
    }

    SDLMenuRunScore *bestScoreMenu = nil;
    for (NSUInteger run = 0; run < oldMenuCells.count; run++) { //For each run
        // Set the menu status as a 1-1 array, start off will oldMenus = all Deletes, newMenu = all Adds
        NSMutableArray<NSNumber *> *oldMenuStatus = [SDLMenuUpdateAlgorithm buildDeleteStatus:oldMenuCells];
        NSMutableArray<NSNumber *> *newMenuStatus = [SDLMenuUpdateAlgorithm buildAddStatus:updatedMenuCells];

        NSUInteger startIndex = 0;
        for(NSUInteger oldCellIndex = run; oldCellIndex < oldMenuCells.count; oldCellIndex++) { //For each old item
            //Create inner loop to compare old cells to new cells to find a match, if a match if found we mark the index at match for both the old and the new status to keep since we do not want to send RPCs for those cases
            for(NSUInteger newCellIndex = startIndex; newCellIndex < updatedMenuCells.count; newCellIndex++) {
                if([oldMenuCells[oldCellIndex] isEqual:updatedMenuCells[newCellIndex]]) {
                    oldMenuStatus[oldCellIndex] = @(MenuCellStateKeep);
                    newMenuStatus[newCellIndex] = @(MenuCellStateKeep);
                    startIndex = newCellIndex + 1;
                    break;
                }
            }
        }
        NSUInteger numberOfAdds = 0;
        for(NSUInteger status = 0; status < newMenuStatus.count; status++){
            // 0 = Delete,
            //1 = Add,
            //2 = Keep
            if(newMenuStatus[status].integerValue == 1) {
                numberOfAdds++;
            }
        }

        NSLog(@"Run: %lu, RunScore: %lu", (unsigned long)run, (unsigned long)numberOfAdds);
        if(bestScoreMenu == nil || numberOfAdds < bestScoreMenu.score) {
            if(bestScoreMenu != nil){
                NSLog(@"Previosu Score: %lu", (unsigned long)bestScoreMenu.score);
            }
            bestScoreMenu = [[SDLMenuRunScore alloc]  initWithOldStatus:oldMenuStatus updatedStatus:newMenuStatus score:numberOfAdds];
        }
    }

    NSLog(@"BestScore: %lu", (unsigned long)bestScoreMenu.score);
    NSLog(@"OldMenuStatus: %@",bestScoreMenu.oldStatus);
    NSLog(@"NewMenuStatus: %@",bestScoreMenu.updatedStatus);
    
    return bestScoreMenu;
}

+ (NSMutableArray<NSNumber *> *)buildDeleteStatus:(NSArray<SDLMenuCell *> *)oldMenu {
    NSMutableArray<NSNumber *> *oldMenuStatus = [[NSMutableArray alloc] init];
    for(SDLMenuCell *cells in oldMenu) {
        [oldMenuStatus addObject:@(MenuCellStateDelete)];
    }
    return [oldMenuStatus mutableCopy];
}

+ (NSMutableArray<NSNumber *> *)buildAddStatus:(NSArray<SDLMenuCell *> *)newMenu {
    NSMutableArray<NSNumber *> *newMenuStatus = [[NSMutableArray alloc] init];
    for(SDLMenuCell *cells in newMenu) {
        [newMenuStatus addObject:@(MenuCellStateAdd)];
    }
    return [newMenuStatus mutableCopy];
}

@end

NS_ASSUME_NONNULL_END
