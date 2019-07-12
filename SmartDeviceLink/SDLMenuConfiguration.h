//
//  SDLMenuConfiguration.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 7/12/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLMenuLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuConfiguration : NSObject

/**
 * Changes the default main menu layout. Defaults to `SDLMenuLayoutList`.
 */
@property (strong, nonatomic, readonly) SDLMenuLayout mainMenuLayout;

/**
 * Changes the default submenu layout. To change this for an individual submenu, set the `menuLayout` property on the `SDLMenuCell` initializer for creating a cell with sub-cells. Defaults to `SDLMenuLayoutList`.
 */
@property (strong, nonatomic, readonly) SDLMenuLayout defaultSubmenuLayout;

- (instancetype)initWithMainMenuLayout:(SDLMenuLayout)mainMenuLayout defaultSubmenuLayout:(SDLMenuLayout)defaultSubmenuLayout;

@end

NS_ASSUME_NONNULL_END
