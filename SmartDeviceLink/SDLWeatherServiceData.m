//
//  SDLWeatherServiceData.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLWeatherServiceData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLWeatherServiceData

- (instancetype)initWithLocation:(SDLLocationDetails *)location currentForecast:(nullable SDLWeatherData *)currentForecast minuteForecast:(nullable NSArray<SDLWeatherData *> *)minuteForecast hourlyForecast:(NSArray<SDLWeatherData *> *)hourlyForecast multidayForecast:(nullable NSArray<SDLWeatherData *> *)multidayForecast alerts:(NSArray<SDLWeatherAlert *> *)alerts {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.location = location;
    self.currentForecast = currentForecast;
    self.minuteForecast = minuteForecast;
    self.hourlyForecast = hourlyForecast;
    self.multidayForecast = multidayForecast;
    self.alerts = alerts;

    return self;
}

- (void)setLocation:(SDLLocationDetails *)location {
    [store sdl_setObject:location forName:SDLNameLocation];
}

- (SDLLocationDetails *)location {
    return [store sdl_objectForName:SDLNameLocation ofClass:SDLLocationDetails.class];
}

- (void)setCurrentForecast:(nullable SDLWeatherData *)currentForecast {
    [store sdl_setObject:currentForecast forName:SDLNameCurrentForecast];
}

- (nullable SDLWeatherData *)currentForecast {
    return [store sdl_objectForName:SDLNameCurrentForecast ofClass:SDLWeatherData.class];
}

- (void)setMinuteForecast:(nullable NSArray<SDLWeatherData *> *)minuteForecast {
    [store sdl_setObject:minuteForecast forName:SDLNameMinuteForecast];
}

- (nullable NSArray<SDLWeatherData *> *)minuteForecast {
    return [store sdl_objectsForName:SDLNameMinuteForecast ofClass:SDLWeatherData.class];
}

- (void)setHourlyForecast:(nullable NSArray<SDLWeatherData *> *)hourlyForecast {
    [store sdl_setObject:hourlyForecast forName:SDLNameHourlyForecast];
}

- (nullable NSArray<SDLWeatherData *> *)hourlyForecast {
    return [store sdl_objectsForName:SDLNameHourlyForecast ofClass:SDLWeatherData.class];
}

- (void)setMultidayForecast:(nullable NSArray<SDLWeatherData *> *)multidayForecast {
    [store sdl_setObject:multidayForecast forName:SDLNameMultidayForecast];
}

- (nullable NSArray<SDLWeatherData *> *)multidayForecast {
    return [store sdl_objectsForName:SDLNameMultidayForecast ofClass:SDLWeatherData.class];
}

- (void)setAlerts:(nullable NSArray<SDLWeatherAlert *> *)alerts {
    [store sdl_setObject:alerts forName:SDLNameAlerts];
}

- (nullable NSArray<SDLWeatherAlert *> *)alerts {
    return [store sdl_objectsForName:SDLNameAlerts ofClass:SDLWeatherAlert.class];
}

@end

NS_ASSUME_NONNULL_END
