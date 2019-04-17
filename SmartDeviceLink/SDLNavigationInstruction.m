//
//  SDLNavigationInstruction.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/22/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLNavigationInstruction.h"

#import "NSMutableDictionary+Store.h"
#import "SDLDateTime.h"
#import "SDLImage.h"
#import "SDLLocationDetails.h"
#import "SDLRPCParameterNames.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLNavigationInstruction

- (instancetype)initWithLocationDetails:(SDLLocationDetails *)locationDetails action:(SDLNavigationAction)action {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.locationDetails = locationDetails;
    self.action = action;

    return self;
}

- (instancetype)initWithLocationDetails:(SDLLocationDetails *)locationDetails action:(SDLNavigationAction)action eta:(nullable SDLDateTime *)eta bearing:(UInt16)bearing junctionType:(nullable SDLNavigationJunction)junctionType drivingSide:(nullable SDLDirection)drivingSide details:(nullable NSString *)details image:(nullable SDLImage *)image {
    self = [self initWithLocationDetails:locationDetails action:action];
    if (!self) {
        return nil;
    }

    self.eta = eta;
    self.bearing = @(bearing);
    self.junctionType = junctionType;
    self.drivingSide = drivingSide;
    self.details = details;
    self.image = image;

    return self;
}

- (void)setLocationDetails:(SDLLocationDetails *)locationDetails {
    [store sdl_setObject:locationDetails forName:SDLRPCParameterNameLocationDetails];
}

- (SDLLocationDetails *)locationDetails {
    return [store sdl_objectForName:SDLRPCParameterNameLocationDetails ofClass:SDLLocationDetails.class error:nil];
}

- (void)setAction:(SDLNavigationAction)action {
    [store sdl_setObject:action forName:SDLRPCParameterNameAction];
}

- (SDLNavigationAction)action {
    return [store sdl_enumForName:SDLRPCParameterNameAction error:nil];
}

- (void)setEta:(nullable SDLDateTime *)eta {
    [store sdl_setObject:eta forName:SDLRPCParameterNameETA];
}

- (nullable SDLDateTime *)eta {
    return [store sdl_objectForName:SDLRPCParameterNameETA ofClass:SDLDateTime.class error:nil];
}

- (void)setBearing:(nullable NSNumber<SDLInt> *)bearing {
    [store sdl_setObject:bearing forName:SDLRPCParameterNameBearing];
}

- (nullable NSNumber<SDLInt> *)bearing {
    return [store sdl_objectForName:SDLRPCParameterNameBearing ofClass:NSNumber.class error:nil];
}

- (void)setJunctionType:(nullable SDLNavigationJunction)junctionType {
    [store sdl_setObject:junctionType forName:SDLRPCParameterNameJunctionType];
}

- (nullable SDLNavigationJunction)junctionType {
    return [store sdl_enumForName:SDLRPCParameterNameJunctionType error:nil];
}

- (void)setDrivingSide:(nullable SDLDirection)drivingSide {
    [store sdl_setObject:drivingSide forName:SDLRPCParameterNameDrivingSide];
}

- (nullable SDLDirection)drivingSide {
    return [store sdl_enumForName:SDLRPCParameterNameDrivingSide error:nil];
}

- (void)setDetails:(nullable NSString *)details {
    [store sdl_setObject:details forName:SDLRPCParameterNameDetails];
}

- (nullable NSString *)details {
    return [store sdl_objectForName:SDLRPCParameterNameDetails ofClass:NSString.class error:nil];
}

- (void)setImage:(nullable SDLImage *)image {
    [store sdl_setObject:image forName:SDLRPCParameterNameImage];
}

- (nullable SDLImage *)image {
    return [store sdl_objectForName:SDLRPCParameterNameImage ofClass:SDLImage.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
