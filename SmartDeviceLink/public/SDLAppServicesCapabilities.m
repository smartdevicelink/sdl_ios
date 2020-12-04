//
//  SDLAppServicesCapabilities.m
//  SmartDeviceLink
//
//  Created by Nicole on 1/30/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLAppServicesCapabilities.h"

#import "SDLAppServiceCapability.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAppServicesCapabilities

- (instancetype)initWithAppServices:(nullable NSArray<SDLAppServiceCapability *> *)appServices {
    self = [self init];
    if (!self) {
        return self;
    }

    self.appServices = appServices;

    return self;
}

- (void)setAppServices:(nullable NSArray<SDLAppServiceCapability *> *)appServices {
    [self.store sdl_setObject:appServices forName:SDLRPCParameterNameAppServices];
}

- (nullable NSArray<SDLAppServiceCapability *> *)appServices {
    return [self.store sdl_objectsForName:SDLRPCParameterNameAppServices ofClass:SDLAppServiceCapability.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
