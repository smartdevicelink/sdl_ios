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

- (instancetype)initWithTitle:(NSString *)title icon:(nullable SDLArtwork *)icon voiceCommands:(nullable NSArray<NSString *> *)voiceCommands handler:(SDLMenuCellSelectionHandler)handler;
- (instancetype)initWithTitle:(NSString *)title subCells:(NSArray<SDLMenuCell *> *)subCells;

@end

NS_ASSUME_NONNULL_END
