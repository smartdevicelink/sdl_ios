//
//  SDLAppServiceData.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/1/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLAppServiceData.h"
#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

#import "SDLAppServiceType.h"
#import "SDLMediaServiceData.h"
#import "SDLNavigationServiceData.h"
#import "SDLWeatherServiceData.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAppServiceData

- (instancetype)initWithServiceType:(NSString *)serviceType serviceId:(NSString *)serviceId {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.serviceType = serviceType;
    self.serviceId = serviceId;

    return self;
}

- (instancetype)initWithMediaServiceData:(SDLMediaServiceData *)mediaServiceData serviceId:(NSString *)serviceId {
    self = [self initWithServiceType:SDLAppServiceTypeMedia serviceId:serviceId];
    if (!self) {
        return nil;
    }

    self.mediaServiceData = mediaServiceData;

    return self;
}

- (instancetype)initWithWeatherServiceData:(SDLWeatherServiceData *)weatherServiceData serviceId:(NSString *)serviceId {
    self = [self initWithServiceType:SDLAppServiceTypeWeather serviceId:serviceId];
    if (!self) {
        return nil;
    }

    self.weatherServiceData = weatherServiceData;

    return self;
}

- (instancetype)initWithNavigationServiceData:(SDLNavigationServiceData *)navigationServiceData serviceId:(NSString *)serviceId {
    self = [self initWithServiceType:SDLAppServiceTypeNavigation serviceId:serviceId];
    if (!self) {
        return nil;
    }

    self.navigationServiceData = navigationServiceData;

    return self;
}

- (instancetype)initWithServiceType:(NSString *)serviceType serviceId:(NSString *)serviceId mediaServiceData:(nullable SDLMediaServiceData *)mediaServiceData weatherServiceData:(nullable SDLWeatherServiceData *)weatherServiceData navigationServiceData:(nullable SDLNavigationServiceData *)navigationServiceData {
    self = [self initWithServiceType:serviceType serviceId:serviceId];
    if (!self) {
        return nil;
    }

    self.mediaServiceData = mediaServiceData;
    self.weatherServiceData = weatherServiceData;
    self.navigationServiceData = navigationServiceData;

    return self;
}

- (void)setServiceType:(NSString *)serviceType {
    [store sdl_setObject:serviceType forName:SDLNameServiceType];
}

- (NSString *)serviceType {
    return [store sdl_objectForName:SDLNameServiceType];
}

- (void)setServiceId:(NSString *)serviceId {
    [store sdl_setObject:serviceId forName:SDLNameServiceID];
}

- (NSString *)serviceId {
    return [store sdl_objectForName:SDLNameServiceID];
}

- (void)setWeatherServiceData:(nullable SDLWeatherServiceData *)weatherServiceData {
    [store sdl_setObject:weatherServiceData forName:SDLNameWeatherServiceData];
}

- (nullable SDLWeatherServiceData *)weatherServiceData {
    return [store sdl_objectForName:SDLNameWeatherServiceData ofClass:SDLWeatherServiceData.class];
}

- (void)setMediaServiceData:(nullable SDLMediaServiceData *)mediaServiceData {
    [store sdl_setObject:mediaServiceData forName:SDLNameMediaServiceData];
}

- (nullable SDLMediaServiceData *)mediaServiceData {
    return [store sdl_objectForName:SDLNameMediaServiceData ofClass:SDLMediaServiceData.class];
}

- (void)setNavigationServiceData:(nullable SDLNavigationServiceData *)navigationServiceData {
    [store sdl_setObject:navigationServiceData forName:SDLNameNavigationServiceData];
}

- (nullable SDLNavigationServiceData *)navigationServiceData {
    return [store sdl_objectForName:SDLNameNavigationServiceData ofClass:SDLNavigationServiceData.class];
}

@end

NS_ASSUME_NONNULL_END
