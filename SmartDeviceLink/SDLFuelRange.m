//
//  SDLFuelRange.m
//  SmartDeviceLink
//
//  Created by Nicole on 6/20/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLFuelRange.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLFuelRange

- (void)setType:(SDLFuelType)type {
    [store sdl_setObject:type forName:SDLNameType];
}

- (SDLFuelType)type {
    return [store sdl_objectForName:SDLNameType];
}

- (void)setRange:(NSNumber<SDLFloat> *)range {
    [store sdl_setObject:range forName:SDLNameRange];
}

- (NSNumber<SDLFloat> *)range {
    return [store sdl_objectForName:SDLNameRange];
}


@end

NS_ASSUME_NONNULL_END
