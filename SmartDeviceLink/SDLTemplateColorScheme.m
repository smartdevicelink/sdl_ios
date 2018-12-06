//
//  SDLTemplateColorScheme.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/21/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLTemplateColorScheme.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLRGBColor.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTemplateColorScheme

- (instancetype)initWithPrimaryRGBColor:(SDLRGBColor *)primaryColor secondaryRGBColor:(SDLRGBColor *)secondaryColor backgroundRGBColor:(SDLRGBColor *)backgroundColor {
    self = [self init];
    if (!self) { return nil; }

    self.primaryColor = primaryColor;
    self.secondaryColor = secondaryColor;
    self.backgroundColor = backgroundColor;

    return self;
}

- (instancetype)initWithPrimaryColor:(UIColor *)primaryColor secondaryColor:(UIColor *)secondaryColor backgroundColor:(UIColor *)backgroundColor {
    self = [self init];
    if (!self) { return nil; }

    self.primaryColor = [[SDLRGBColor alloc] initWithColor:primaryColor];
    self.secondaryColor = [[SDLRGBColor alloc] initWithColor:secondaryColor];
    self.backgroundColor = [[SDLRGBColor alloc] initWithColor:backgroundColor];

    return self;
}

- (void)setPrimaryColor:(nullable SDLRGBColor *)primaryColor {
    [store sdl_setObject:primaryColor forName:SDLNamePrimaryColor];
}

- (nullable SDLRGBColor *)primaryColor {
    return [store sdl_objectForName:SDLNamePrimaryColor ofClass:[SDLRGBColor class]];
}

- (void)setSecondaryColor:(nullable SDLRGBColor *)secondaryColor {
    [store sdl_setObject:secondaryColor forName:SDLNameSecondaryColor];
}

- (nullable SDLRGBColor *)secondaryColor {
    return [store sdl_objectForName:SDLNameSecondaryColor ofClass:[SDLRGBColor class]];
}

- (void)setBackgroundColor:(nullable SDLRGBColor *)backgroundColor {
    [store sdl_setObject:backgroundColor forName:SDLNameBackgroundColor];
}

- (nullable SDLRGBColor *)backgroundColor {
    return [store sdl_objectForName:SDLNameBackgroundColor ofClass:[SDLRGBColor class]];
}

@end

NS_ASSUME_NONNULL_END
