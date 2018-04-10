//
//  SDLMenuCell.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/9/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLMenuCell.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLMenuCell

- (instancetype)initWithTitle:(NSString *)title icon:(nullable SDLArtwork *)icon voiceCommands:(nullable NSArray<NSString *> *)voiceCommands handler:(SDLMenuCellSelectionHandler)handler {
    self = [super init];
    if (!self) { return nil; }

    _title = title;
    _icon = icon;
    _voiceCommands = voiceCommands;
    _handler = handler;

    return self;
}

- (instancetype)initWithTitle:(NSString *)title voiceCommands:(nullable NSArray<NSString *> *)voiceCommands subCells:(NSArray<SDLMenuCell *> *)subCells {
    self = [super init];
    if (!self) { return nil; }

    _voiceCommands = voiceCommands;
    _subCells = subCells;

    return self;
}

@end

NS_ASSUME_NONNULL_END
