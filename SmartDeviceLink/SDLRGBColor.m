//
//  SDLRGBColor.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/18/18.
//  Copyright © 2018 Livio. All rights reserved.
//

#import "SDLRGBColor.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRGBColor

- (instancetype)initWithRed:(UInt8)red green:(UInt8)green blue:(UInt8)blue {
    self = [self init];
    if (!self) { return nil; }

    self.red = @(red);
    self.green = @(green);
    self.blue = @(blue);

    return self;
}

- (instancetype)initWithColor:(UIColor *)color {
    CGFloat redf, greenf, bluef, alphaf;
    [color getRed:&redf green:&greenf blue:&bluef alpha:&alphaf];

    UInt8 red, green, blue;
    red = (UInt8)round(redf * 255.0);
    green = (UInt8)round(greenf * 255.0);
    blue = (UInt8)round(bluef * 255.0);

    return [self initWithRed:red green:green blue:blue];
}

#pragma mark - Setters

- (void)setRed:(NSNumber<SDLInt> *)red {
    [store sdl_setObject:red forName:SDLNameRed];
}

- (NSNumber<SDLInt> *)red {
    return [store sdl_objectForName:SDLNameRed];
}

- (void)setGreen:(NSNumber<SDLInt> *)green {
    [store sdl_setObject:green forName:SDLNameGreen];
}

- (NSNumber<SDLInt> *)green {
    return [store sdl_objectForName:SDLNameGreen];
}

- (void)setBlue:(NSNumber<SDLInt> *)blue {
    [store sdl_setObject:blue forName:SDLNameBlue];
}

- (NSNumber<SDLInt> *)blue {
    return [store sdl_objectForName:SDLNameBlue];
}

@end

NS_ASSUME_NONNULL_END
