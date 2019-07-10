//
//  SDLFuelRange.m
//  SmartDeviceLink
//
//  Created by Nicole on 6/20/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLFuelRange.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLFuelRange

- (void)setType:(nullable SDLFuelType)type {
    [self.store sdl_setObject:type forName:SDLRPCParameterNameType];
}

- (nullable SDLFuelType)type {
    return [self.store sdl_enumForName:SDLRPCParameterNameType error:nil];
}

- (void)setRange:(nullable NSNumber<SDLFloat> *)range {
    [self.store sdl_setObject:range forName:SDLRPCParameterNameRange];
}

- (nullable NSNumber<SDLFloat> *)range {
    return [self.store sdl_objectForName:SDLRPCParameterNameRange ofClass:NSNumber.class error:nil];
}


@end

NS_ASSUME_NONNULL_END
