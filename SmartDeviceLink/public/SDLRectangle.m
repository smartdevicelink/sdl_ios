//
//  SDLRectangle.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/23/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "NSMutableDictionary+Store.h"
#import "SDLRectangle.h"
#import "SDLRPCParameterNames.h"

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
    [self.store sdl_setObject:x forName:SDLRPCParameterNameX];
}

- (NSNumber<SDLFloat> *)x {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameX ofClass:NSNumber.class error:&error];
}

- (void)setY:(NSNumber<SDLFloat> *)y {
    [self.store sdl_setObject:y forName:SDLRPCParameterNameY];
}

- (NSNumber<SDLFloat> *)y {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameY ofClass:NSNumber.class error:&error];
}

- (void)setWidth:(NSNumber<SDLFloat> *)width {
    [self.store sdl_setObject:width forName:SDLRPCParameterNameWidth];
}

- (NSNumber<SDLFloat> *)width {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameWidth ofClass:NSNumber.class error:&error];
}

- (void)setHeight:(NSNumber<SDLFloat> *)height {
    [self.store sdl_setObject:height forName:SDLRPCParameterNameHeight];
}

- (NSNumber<SDLFloat> *)height {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameHeight ofClass:NSNumber.class error:&error];
}

- (BOOL)isEqual:(id)object {
    if (!object) {
        return NO;
    }
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    typeof(self) rect2 = object;
    return [self.x isEqualToNumber:rect2.x] && [self.y isEqualToNumber:rect2.y] && [self.width isEqualToNumber:rect2.width] && [self.height isEqualToNumber:rect2.height];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@{%@, %@, {%@ x %@}}", NSStringFromClass(self.class), self.x, self.y, self.width, self.height];
}

@end
