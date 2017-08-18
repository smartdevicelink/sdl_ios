//
//  SDLSpatialStruct.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/3/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "NSMutableDictionary+Store.h"
#import "SDLSpatialStruct.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSpatialStruct

- (instancetype)initWithId:(UInt32)id x:(NSNumber<SDLInt> *)x y:(NSNumber<SDLInt> *)y width:(NSNumber<SDLInt> *)width height:(NSNumber<SDLInt> *)height {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.id = @(id);
    self.x = x;
    self.y = y;
    self.width = width;
    self.height = height;

    return self;
}

- (instancetype)initWithId:(NSNumber *)id CGRect:(CGRect)rect {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.id = id;
    self.x = @((uint64_t)rect.origin.x);
    self.y = @((uint64_t)rect.origin.y);
    self.width = @((uint64_t)rect.size.width);
    self.height = @((uint64_t)rect.size.height);

    return self;
}

- (void)setId:(NSNumber<SDLInt> *)id {
    [store sdl_setObject:id forName:SDLNameId];
}

- (NSNumber<SDLInt> *)id {
    return [store sdl_objectForName:SDLNameId];
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

NS_ASSUME_NONNULL_END
