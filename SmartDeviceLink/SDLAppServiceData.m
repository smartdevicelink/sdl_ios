//
//  SDLAppServiceData.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/1/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLAppServiceData.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

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

- (instancetype)initWithAppServiceType:(SDLAppServiceType)serviceType serviceId:(NSString *)serviceId {
    return [self initWithServiceType:serviceType serviceId:serviceId];
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
    [store sdl_setObject:serviceType forName:SDLRPCParameterNameServiceType];
}

- (NSString *)serviceType {
    return [store sdl_objectForName:SDLRPCParameterNameServiceType ofClass:NSString.class error:nil];
}

- (void)setServiceId:(NSString *)serviceId {
    [store sdl_setObject:serviceId forName:SDLRPCParameterNameServiceID];
}

- (NSString *)serviceId {
    return [store sdl_objectForName:SDLRPCParameterNameServiceID ofClass:NSString.class error:nil];
}

- (void)setWeatherServiceData:(nullable SDLWeatherServiceData *)weatherServiceData {
    [store sdl_setObject:weatherServiceData forName:SDLRPCParameterNameWeatherServiceData];
}

- (nullable SDLWeatherServiceData *)weatherServiceData {
    return [store sdl_objectForName:SDLRPCParameterNameWeatherServiceData ofClass:SDLWeatherServiceData.class error:nil];
}

- (void)setMediaServiceData:(nullable SDLMediaServiceData *)mediaServiceData {
    [store sdl_setObject:mediaServiceData forName:SDLRPCParameterNameMediaServiceData];
}

- (nullable SDLMediaServiceData *)mediaServiceData {
    return [store sdl_objectForName:SDLRPCParameterNameMediaServiceData ofClass:SDLMediaServiceData.class error:nil];
}

- (void)setNavigationServiceData:(nullable SDLNavigationServiceData *)navigationServiceData {
    [store sdl_setObject:navigationServiceData forName:SDLRPCParameterNameNavigationServiceData];
}

- (nullable SDLNavigationServiceData *)navigationServiceData {
    return [store sdl_objectForName:SDLRPCParameterNameNavigationServiceData ofClass:SDLNavigationServiceData.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
