//
//  SDLMenuConfiguration.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 7/12/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLMenuConfiguration.h"

@implementation SDLMenuConfiguration

- (instancetype)init {
    return [self initWithMainMenuLayout:SDLMenuLayoutList defaultSubmenuLayout:SDLMenuLayoutList];
}

- (instancetype)initWithMainMenuLayout:(SDLMenuLayout)mainMenuLayout defaultSubmenuLayout:(SDLMenuLayout)defaultSubmenuLayout {
    self = [super init];
    if (!self) { return nil; }

    _mainMenuLayout = mainMenuLayout;
    _defaultSubmenuLayout = defaultSubmenuLayout;

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Menu configuration, main menu layout: %@, submenu default layout: %@", _mainMenuLayout, _defaultSubmenuLayout];
}

@end
