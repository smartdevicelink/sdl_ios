//
//  SDLRectangle.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/23/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "NSMutableDictionary+Store.h"
#import "SDLRectangle.h"
#import "SDLNames.h"

@implementation SDLRectangle

- (instancetype)initWithX:(float)x y:(float)y width:(float)width height:(float)height {
    self = [self init];
    if (!self) { return nil; }

    self.x = @(x);
    self.y = @(y);
    self.width = @(width);
    self.height = @(height);

    return self;
}

- (instancetype)initWithCGRect:(CGRect)rect {
    return [self initWithX:(float)rect.origin.x y:(float)rect.origin.y width:(float)rect.size.width height:(float)rect.size.height];
}

- (void)setX:(NSNumber<SDLFloat> *)x {
    [store sdl_setObject:x forName:SDLNameX];
}

- (NSNumber<SDLFloat> *)x {
    return [store sdl_objectForName:SDLNameX];
}

- (void)setY:(NSNumber<SDLFloat> *)y {
    [store sdl_setObject:y forName:SDLNameY];
}

- (NSNumber<SDLFloat> *)y {
    return [store sdl_objectForName:SDLNameY];
}

- (void)setWidth:(NSNumber<SDLFloat> *)width {
    [store sdl_setObject:width forName:SDLNameWidth];
}

- (NSNumber<SDLFloat> *)width {
    return [store sdl_objectForName:SDLNameWidth];
}

- (void)setHeight:(NSNumber<SDLFloat> *)height {
    [store sdl_setObject:height forName:SDLNameHeight];
}

- (NSNumber<SDLFloat> *)height {
    return [store sdl_objectForName:SDLNameHeight];
}

@end
