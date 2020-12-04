//
//  SDLMenuCell.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/9/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLMenuLayout.h"
#import "SDLTriggerSource.h"

@class SDLArtwork;

NS_ASSUME_NONNULL_BEGIN

/**
The handler to run when a menu item is selected.

@param triggerSource The trigger source of the selection
*/
typedef void(^SDLMenuCellSelectionHandler)(SDLTriggerSource triggerSource);

/// A menu cell item for the main menu or sub-menu.
@interface SDLMenuCell : NSObject

/**
 The cell's text to be displayed
 */
@property (copy, nonatomic, readonly) NSString *title;

/**
 The cell's icon to be displayed
 */
@property (strong, nonatomic, readonly, nullable) SDLArtwork *icon;

/**
 The strings the user can say to activate this voice command
 */
@property (copy, nonatomic, readonly, nullable) NSArray<NSString *> *voiceCommands;

/**
 The handler that will be called when the command is activated
 */
@property (copy, nonatomic, readonly, nullable) SDLMenuCellSelectionHandler handler;

/**
 If this is non-nil, this cell will be a sub-menu button, displaying the subcells in a menu when pressed.
 */
@property (copy, nonatomic, readonly, nullable) NSArray<SDLMenuCell *> *subCells;

/**
 The layout in which the `subCells` will be displayed.
 */
@property (strong, nonatomic, readonly, nullable) SDLMenuLayout submenuLayout;

/**
 Create a menu cell that has no subcells.

 @param title The cell's primary text
 @param icon The cell's image
 @param voiceCommands Voice commands that will activate the menu cell
 @param handler The code that will be run when the menu cell is selected
 @return The menu cell
 */
- (instancetype)initWithTitle:(NSString *)title icon:(nullable SDLArtwork *)icon voiceCommands:(nullable NSArray<NSString *> *)voiceCommands handler:(SDLMenuCellSelectionHandler)handler;

/**
 Create a menu cell that has subcells and when selected will go into a deeper part of the menu

 @param title The cell's primary text
 @param icon The cell's image
 @param layout The layout that the subCells will be layed out in if that submenu is entered
 @param subCells The subcells that will appear when the cell is selected
 @return The menu cell
 */
- (instancetype)initWithTitle:(NSString *)title icon:(nullable SDLArtwork *)icon submenuLayout:(nullable SDLMenuLayout)layout subCells:(NSArray<SDLMenuCell *> *)subCells;


@end

NS_ASSUME_NONNULL_END
