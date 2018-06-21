//
//  SDLMenuCell.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/9/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLTriggerSource.h"

@class SDLArtwork;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDLMenuCellSelectionHandler)(SDLTriggerSource triggerSource);

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
 @param subCells The subcells that will appear when the cell is selected
 @return The menu cell
 */
- (instancetype)initWithTitle:(NSString *)title subCells:(NSArray<SDLMenuCell *> *)subCells __deprecated_msg(("Use initWithTitle:icon:subcells: instead"));

/**
 Create a menu cell that has subcells and when selected will go into a deeper part of the menu

 @param title The cell's primary text
 @param icon The cell's image
 @param subCells The subcells that will appear when the cell is selected
 @return The menu cell
 */
- (instancetype)initWithTitle:(NSString *)title icon:(nullable SDLArtwork *)icon subCells:(NSArray<SDLMenuCell *> *)subCells;

@end

NS_ASSUME_NONNULL_END
