//
//  SDLMenuManagerConstants.h
//  SmartDeviceLink
//
//  Created by Justin Gluck on 5/30/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>


/// Dynamic Menu Manager Mode
///
/// When on this feature will smart arrange a new menu comparing it to the old menu if one exists.
typedef NS_ENUM(NSUInteger, SDLDynamicMenuUpdatesMode) {
    /// Forces on compatibility mode. This will force the menu manager to delete and re-add each menu item for every menu update. This mode is generally not advised due to performance issues.
    SDLDynamicMenuUpdatesModeForceOn = 0,

    /// This mode forces the menu manager to always dynamically update menu items for each menu update. This will provide the best performance but may cause ordering issues on some SYNC Gen 3 head units.
    SDLDynamicMenuUpdatesModeForceOff,

    /// This mode checks whether the phone is connected to a SYNC Gen 3 head unit, which has known menu ordering issues. If it is, it will always delete and re-add every menu item, if not, it will dynamically update the menus.
    SDLDynamicMenuUpdatesModeOnWithCompatibility
};


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
