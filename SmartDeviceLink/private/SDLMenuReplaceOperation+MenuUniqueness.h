//
//  SDLMenuReplaceOperation+MenuUniqueness.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 7/28/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLMenuReplaceOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuReplaceOperation (MenuUniqueness)

+ (void)sdl_addUniqueNamesToCells:(NSArray<SDLMenuCell *> *)menuCells basedOnWindowCapability:(SDLWindowCapability *)windowCapability;

@end

NS_ASSUME_NONNULL_END
