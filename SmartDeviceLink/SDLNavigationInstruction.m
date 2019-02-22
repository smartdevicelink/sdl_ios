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

@end

NS_ASSUME_NONNULL_END
