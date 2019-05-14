//
//  SDLMenuUpdateAlgorithm.h
//  SmartDeviceLink
//
//  Created by Justin Gluck on 5/14/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLMenuRunScore;
@class SDLMenuCell;

NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuUpdateAlgorithm : NSObject

+ (nullable SDLMenuRunScore *)compareOldMenuCells:(NSArray<SDLMenuCell *> *)oldMenuCells updatedMenuCells:(NSArray<SDLMenuCell *> *)updatedMenuCells;
+ (NSMutableArray<NSNumber *> *)buildDeleteStatus:(NSArray<SDLMenuCell *> *)oldMenu;
+ (NSMutableArray<NSNumber *> *)buildAddStatus:(NSArray<SDLMenuCell *> *)newMenu;

@end

NS_ASSUME_NONNULL_END
