//
//  SDLTemplateColorScheme.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/21/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLTemplateColorScheme.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
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
    [self.store sdl_setObject:primaryColor forName:SDLRPCParameterNamePrimaryColor];
}

- (nullable SDLRGBColor *)primaryColor {
    return [self.store sdl_objectForName:SDLRPCParameterNamePrimaryColor ofClass:SDLRGBColor.class error:nil];
}

- (void)setSecondaryColor:(nullable SDLRGBColor *)secondaryColor {
    [self.store sdl_setObject:secondaryColor forName:SDLRPCParameterNameSecondaryColor];
}

- (nullable SDLRGBColor *)secondaryColor {
    return [self.store sdl_objectForName:SDLRPCParameterNameSecondaryColor ofClass:SDLRGBColor.class error:nil];
}

- (void)setBackgroundColor:(nullable SDLRGBColor *)backgroundColor {
    [self.store sdl_setObject:backgroundColor forName:SDLRPCParameterNameBackgroundColor];
}

- (nullable SDLRGBColor *)backgroundColor {
    return [self.store sdl_objectForName:SDLRPCParameterNameBackgroundColor ofClass:SDLRGBColor.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
