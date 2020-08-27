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

@interface SDLDynamicMenuUpdateAlgorithm : NSObject

/**
 Compares the old and the new menus to find the best combination of add and delete commands

 @param oldMenuCells The old menu array
 @param updatedMenuCells The new menu array
 */
+ (nullable SDLDynamicMenuUpdateRunScore *)compareOldMenuCells:(NSArray<SDLMenuCell *> *)oldMenuCells updatedMenuCells:(NSArray<SDLMenuCell *> *)updatedMenuCells;

@end

NS_ASSUME_NONNULL_END
