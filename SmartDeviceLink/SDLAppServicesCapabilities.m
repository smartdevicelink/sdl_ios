//
//  SDLAppServicesCapabilities.m
//  SmartDeviceLink
//
//  Created by Nicole on 1/30/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLAppServicesCapabilities.h"
#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAppServicesCapabilities

- (void)setServicesSupported:(NSArray<SDLAppServiceType> *)servicesSupported {
    [store sdl_setObject:servicesSupported forName:SDLNameServicesSupported];
}

- (NSArray<SDLAppServiceType> *)servicesSupported {
    return [store sdl_objectForName:SDLNameServicesSupported];
}

- (void)setAppServices:(nullable NSArray<SDLAppServiceCapability *> *)appServices {
    [store sdl_setObject:appServices forName:SDLNameAppServices];
}

- (nullable NSArray<SDLAppServiceCapability *> *)appServices {
    return [store sdl_objectsForName:SDLNameAppServices ofClass:SDLAppServiceCapability.class];
}

@end

NS_ASSUME_NONNULL_END
