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
#import "SDLNames.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLNavigationInstruction

- (instancetype)initWithLocationDetails:(SDLLocationDetails *)locationDetails action:(SDLNavigationAction)action eta:(nullable SDLDateTime *)eta bearing:(UInt16)bearing junctionType:(nullable SDLNavigationJunction)junctionType drivingSide:(nullable SDLDirection)drivingSide details:(nullable NSString *)details image:(nullable SDLImage *)image {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.locationDetails = locationDetails;
    self.action = action;
    self.eta = eta;
    self.bearing = @(bearing);
    self.junctionType = junctionType;
    self.drivingSide = drivingSide;
    self.details = details;
    self.image = image;

    return self;
}

- (void)setLocationDetails:(SDLLocationDetails *)locationDetails {
    [store sdl_setObject:locationDetails forName:SDLNameLocationDetails];
}

- (SDLLocationDetails *)locationDetails {
    return [store sdl_objectForName:SDLNameLocationDetails ofClass:SDLLocationDetails.class];
}

- (void)setAction:(SDLNavigationAction)action {
    [store sdl_setObject:action forName:SDLNameAction];
}

- (SDLNavigationAction)action {
    return [store sdl_objectForName:SDLNameAction];
}

- (void)setEta:(nullable SDLDateTime *)eta {
    [store sdl_setObject:eta forName:SDLNameETA];
}

- (nullable SDLDateTime *)eta {
    return [store sdl_objectForName:SDLNameETA ofClass:SDLDateTime.class];
}

- (void)setBearing:(nullable NSNumber<SDLInt> *)bearing {
    [store sdl_setObject:bearing forName:SDLNameBearing];
}

- (nullable NSNumber<SDLInt> *)bearing {
    return [store sdl_objectForName:SDLNameBearing];
}

- (void)setJunctionType:(nullable SDLNavigationJunction)junctionType {
    [store sdl_setObject:junctionType forName:SDLNameJunctionType];
}

- (nullable SDLNavigationJunction)junctionType {
    return [store sdl_objectForName:SDLNameJunctionType];
}

- (void)setDrivingSide:(nullable SDLDirection)drivingSide {
    [store sdl_setObject:drivingSide forName:SDLNameDrivingSide];
}

- (nullable SDLDirection)drivingSide {
    return [store sdl_objectForName:SDLNameDrivingSide];
}

- (void)setDetails:(nullable NSString *)details {
    [store sdl_setObject:details forName:SDLNameDetails];
}

- (nullable NSString *)details {
    return [store sdl_objectForName:SDLNameDetails];
}

- (void)setImage:(nullable SDLImage *)image {
    [store sdl_setObject:image forName:SDLNameImage];
}

- (nullable SDLImage *)image {
    return [store sdl_objectForName:SDLNameImage ofClass:SDLImage.class];
}

@end

NS_ASSUME_NONNULL_END
