//
//  SDLSeatLocationCapability.m
//  SmartDeviceLink
//
//  Created by standa1 on 7/11/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLSeatLocationCapability.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

@implementation SDLSeatLocationCapability

- (void)setCol:(NSNumber<SDLInt> *)cols {
    [self.store sdl_setObject:cols forName:SDLRPCParameterNameColumns];
}

- (NSNumber<SDLInt> *)cols {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameColumns ofClass:NSNumber.class error:&error];
}

- (void)setRow:(NSNumber<SDLInt> *)rows {
    [self.store sdl_setObject:rows forName:SDLRPCParameterNameRows];
}

- (NSNumber<SDLInt> *)rows {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameRows ofClass:NSNumber.class error:&error];
}

- (void)setLevel:(NSNumber<SDLInt> *)levels {
    [self.store sdl_setObject:levels forName:SDLRPCParameterNameLevels];
}

- (NSNumber<SDLInt> *)levels {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameLevels ofClass:NSNumber.class error:&error];
}

- (void)setSeats:(SDLSeatLocation *)seats {
    [self.store sdl_setObject:seats forName:SDLRPCParameterNameSeats];
}

- (SDLSeatLocation *)seats {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameSeats ofClass:SDLSeatLocation.class error:&error];
}

@end
