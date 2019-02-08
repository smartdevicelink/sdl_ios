//
//  SDLWeatherServiceManifest.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/8/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLWeatherServiceManifest.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLWeatherServiceManifest

- (void)setCurrentForecastSupported:(nullable NSNumber<SDLBool> *)currentForecastSupported {
    [store sdl_setObject:currentForecastSupported forName:SDLNameCurrentForecastSupported];
}

- (nullable NSNumber<SDLBool> *)currentForecastSupported {
    return [store sdl_objectForName:SDLNameCurrentForecastSupported];
}

- (void)setMaxMultidayForecastAmount:(nullable NSNumber<SDLInt> *)maxMultidayForecastAmount {
    [store sdl_setObject:maxMultidayForecastAmount forName:SDLNameMaxMultidayForecastAmount];
}

- (nullable NSNumber<SDLInt> *)maxMultidayForecastAmount {
    return [store sdl_objectForName:SDLNameMaxMultidayForecastAmount];
}

- (void)setMaxHourlyForecastAmount:(nullable NSNumber<SDLInt> *)maxHourlyForecastAmount {
    [store sdl_setObject:maxHourlyForecastAmount forName:SDLNameMaxHourlyForecastAmount];
}

- (nullable NSNumber<SDLInt> *)maxHourlyForecastAmount {
    return [store sdl_objectForName:SDLNameMaxHourlyForecastAmount];
}

- (void)setMaxMinutelyForecastAmount:(nullable NSNumber<SDLInt> *)maxMinutelyForecastAmount {
    [store sdl_setObject:maxMinutelyForecastAmount forName:SDLNameMaxMinutelyForecastAmount];
}

- (nullable NSNumber<SDLInt> *)maxMinutelyForecastAmount {
    return [store sdl_objectForName:SDLNameMaxMinutelyForecastAmount];
}

- (void)setWeatherForLocationSupported:(nullable NSNumber<SDLBool> *)weatherForLocationSupported {
    [store sdl_setObject:weatherForLocationSupported forName:SDLNameWeatherForLocationSupported];
}

- (nullable NSNumber<SDLBool> *)weatherForLocationSupported {
    return [store sdl_objectForName:SDLNameWeatherForLocationSupported];
}

@end

NS_ASSUME_NONNULL_END
