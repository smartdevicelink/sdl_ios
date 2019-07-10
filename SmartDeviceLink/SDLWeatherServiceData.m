//
//  SDLWeatherServiceData.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLWeatherServiceData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLWeatherServiceData

- (instancetype)initWithLocation:(SDLLocationDetails *)location {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.location = location;

    return self;
}

- (instancetype)initWithLocation:(SDLLocationDetails *)location currentForecast:(nullable SDLWeatherData *)currentForecast minuteForecast:(nullable NSArray<SDLWeatherData *> *)minuteForecast hourlyForecast:(nullable NSArray<SDLWeatherData *> *)hourlyForecast multidayForecast:(nullable NSArray<SDLWeatherData *> *)multidayForecast alerts:(nullable NSArray<SDLWeatherAlert *> *)alerts {
    self = [self initWithLocation:location];
    if (!self) {
        return nil;
    }

    self.currentForecast = currentForecast;
    self.minuteForecast = minuteForecast;
    self.hourlyForecast = hourlyForecast;
    self.multidayForecast = multidayForecast;
    self.alerts = alerts;

    return self;
}

- (void)setLocation:(SDLLocationDetails *)location {
    [self.store sdl_setObject:location forName:SDLRPCParameterNameLocation];
}

- (SDLLocationDetails *)location {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameLocation ofClass:SDLLocationDetails.class error:&error];
}

- (void)setCurrentForecast:(nullable SDLWeatherData *)currentForecast {
    [self.store sdl_setObject:currentForecast forName:SDLRPCParameterNameCurrentForecast];
}

- (nullable SDLWeatherData *)currentForecast {
    return [self.store sdl_objectForName:SDLRPCParameterNameCurrentForecast ofClass:SDLWeatherData.class error:nil];
}

- (void)setMinuteForecast:(nullable NSArray<SDLWeatherData *> *)minuteForecast {
    [self.store sdl_setObject:minuteForecast forName:SDLRPCParameterNameMinuteForecast];
}

- (nullable NSArray<SDLWeatherData *> *)minuteForecast {
    return [self.store sdl_objectsForName:SDLRPCParameterNameMinuteForecast ofClass:SDLWeatherData.class error:nil];
}

- (void)setHourlyForecast:(nullable NSArray<SDLWeatherData *> *)hourlyForecast {
    [self.store sdl_setObject:hourlyForecast forName:SDLRPCParameterNameHourlyForecast];
}

- (nullable NSArray<SDLWeatherData *> *)hourlyForecast {
    return [self.store sdl_objectsForName:SDLRPCParameterNameHourlyForecast ofClass:SDLWeatherData.class error:nil];
}

- (void)setMultidayForecast:(nullable NSArray<SDLWeatherData *> *)multidayForecast {
    [self.store sdl_setObject:multidayForecast forName:SDLRPCParameterNameMultidayForecast];
}

- (nullable NSArray<SDLWeatherData *> *)multidayForecast {
    return [self.store sdl_objectsForName:SDLRPCParameterNameMultidayForecast ofClass:SDLWeatherData.class error:nil];
}

- (void)setAlerts:(nullable NSArray<SDLWeatherAlert *> *)alerts {
    [self.store sdl_setObject:alerts forName:SDLRPCParameterNameAlerts];
}

- (nullable NSArray<SDLWeatherAlert *> *)alerts {
    return [self.store sdl_objectsForName:SDLRPCParameterNameAlerts ofClass:SDLWeatherAlert.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
