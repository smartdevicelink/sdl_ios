//
//  SDLMenuConfiguration.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 7/12/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLMenuConfiguration.h"

#import "SDLMacros.h"

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

- (NSUInteger)hash {
    return NSUIntRotateCell(self.mainMenuLayout.hash, NSUIntBitCell / 2)
    ^ NSUIntRotateCell(self.defaultSubmenuLayout.hash, NSUIntBitCell / 3);
}

- (BOOL)isEqual:(id)object {
    if (self == object) { return YES; }
    if (![object isMemberOfClass:[self class]]) { return NO; }

    return [self isEqualToConfiguration:(SDLMenuConfiguration *)object];
}

- (BOOL)isEqualToConfiguration:(SDLMenuConfiguration *)configuration {
    if (configuration == nil) { return NO; }

    return (self.hash == configuration.hash);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Menu configuration, main menu layout: %@, submenu default layout: %@", _mainMenuLayout, _defaultSubmenuLayout];
}

@end
