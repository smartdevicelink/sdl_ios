//
//  SDLMenuReplaceUtilitiesSpecHelpers.h
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 1/29/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLMenuCell;

NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuReplaceUtilitiesSpecHelpers : NSObject

@property (class, nonatomic, readonly) NSMutableArray<SDLMenuCell *> *topLevelOnlyMenu;
@property (class, nonatomic, readonly) NSMutableArray<SDLMenuCell *> *deepMenu;

@end

NS_ASSUME_NONNULL_END
