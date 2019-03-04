//
//  SDLWeatherData.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLWeatherData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLDateTime.h"
#import "SDLNames.h"
#import "SDLTemperature.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLWeatherData

- (instancetype)initWithCurrentTemperature:(nullable SDLTemperature *)currentTemperature temperatureHigh:(nullable SDLTemperature *)temperatureHigh temperatureLow:(nullable SDLTemperature *)temperatureLow apparentTemperature:(nullable SDLTemperature *)apparentTemperature apparentTemperatureHigh:(nullable SDLTemperature *)apparentTemperatureHigh apparentTemperatureLow:(nullable SDLTemperature *)apparentTemperatureLow weatherSummary:(nullable NSString *)weatherSummary time:(nullable SDLDateTime *)time humidity:(nullable NSNumber<SDLFloat> *)humidity cloudCover:(nullable NSNumber<SDLFloat> *)cloudCover moonPhase:(nullable NSNumber<SDLFloat> *)moonPhase windBearing:(nullable NSNumber<SDLInt> *)windBearing windGust:(nullable NSNumber<SDLFloat> *)windGust windSpeed:(nullable NSNumber<SDLFloat> *)windSpeed nearestStormBearing:(nullable NSNumber<SDLInt> *)nearestStormBearing nearestStormDistance:(nullable NSNumber<SDLInt> *)nearestStormDistance precipAccumulation:(nullable NSNumber<SDLFloat> *)precipAccumulation precipIntensity:(nullable NSNumber<SDLFloat> *)precipIntensity precipProbability:(nullable NSNumber<SDLFloat> *)precipProbability precipType:(nullable NSString *)precipType visibility:(nullable NSNumber<SDLFloat> *)visibility weatherIconImageName:(nullable NSString *)weatherIconImageName {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.currentTemperature = currentTemperature;
    self.temperatureHigh = temperatureHigh;
    self.temperatureLow = temperatureLow;
    self.apparentTemperature = apparentTemperature;
    self.apparentTemperatureHigh = apparentTemperatureHigh;
    self.apparentTemperatureLow = apparentTemperatureLow;
    self.weatherSummary = weatherSummary;
    self.time = time;
    self.humidity = humidity;
    self.cloudCover = cloudCover;
    self.moonPhase = moonPhase;
    self.windBearing = windBearing;
    self.windGust = windGust;
    self.windSpeed = windSpeed;
    self.nearestStormBearing = nearestStormBearing;
    self.nearestStormDistance = nearestStormDistance;
    self.precipAccumulation = precipAccumulation;
    self.precipIntensity = precipIntensity;
    self.precipProbability = precipProbability;
    self.precipType = precipType;
    self.visibility = visibility;
    self.weatherIconImageName = weatherIconImageName;

    return self;
}

- (void)setCurrentTemperature:(nullable SDLTemperature *)currentTemperature {
    [store sdl_setObject:currentTemperature forName:SDLNameCurrentTemperature];
}

- (nullable SDLTemperature *)currentTemperature {
    return [store sdl_objectForName:SDLNameCurrentTemperature ofClass:SDLTemperature.class];
}

- (void)setTemperatureHigh:(nullable SDLTemperature *)temperatureHigh {
    [store sdl_setObject:temperatureHigh forName:SDLNameTemperatureHigh];
}

- (nullable SDLTemperature *)temperatureHigh {
    return [store sdl_objectForName:SDLNameTemperatureHigh ofClass:SDLTemperature.class];
}

- (void)setTemperatureLow:(nullable SDLTemperature *)temperatureLow {
    [store sdl_setObject:temperatureLow forName:SDLNameTemperatureLow];
}

- (nullable SDLTemperature *)temperatureLow {
    return [store sdl_objectForName:SDLNameTemperatureLow ofClass:SDLTemperature.class];
}

- (void)setApparentTemperature:(nullable SDLTemperature *)apparentTemperature {
    [store sdl_setObject:apparentTemperature forName:SDLNameApparentTemperature];
}

- (nullable SDLTemperature *)apparentTemperature {
    return [store sdl_objectForName:SDLNameApparentTemperature ofClass:SDLTemperature.class];
}

- (void)setApparentTemperatureHigh:(nullable SDLTemperature *)apparentTemperatureHigh {
    [store sdl_setObject:apparentTemperatureHigh forName:SDLNameApparentTemperatureHigh];
}

- (nullable SDLTemperature *)apparentTemperatureHigh {
    return [store sdl_objectForName:SDLNameApparentTemperatureHigh ofClass:SDLTemperature.class];
}

- (void)setApparentTemperatureLow:(nullable SDLTemperature *)apparentTemperatureLow {
    [store sdl_setObject:apparentTemperatureLow forName:SDLNameApparentTemperatureLow];
}

- (nullable SDLTemperature *)apparentTemperatureLow {
    return [store sdl_objectForName:SDLNameApparentTemperatureLow ofClass:SDLTemperature.class];
}

- (void)setWeatherSummary:(nullable NSString *)weatherSummary {
    [store sdl_setObject:weatherSummary forName:SDLNameWeatherSummary];
}

- (nullable NSString *)weatherSummary {
    return [store sdl_objectForName:SDLNameWeatherSummary];
}

- (void)setTime:(nullable SDLDateTime *)time {
    [store sdl_setObject:time forName:SDLNameTime];
}

- (nullable SDLDateTime *)time {
    return [store sdl_objectForName:SDLNameTime ofClass:SDLDateTime.class];
}

- (void)setHumidity:(nullable NSNumber<SDLFloat> *)humidity {
    [store sdl_setObject:humidity forName:SDLNameHumidity];
}

- (nullable NSNumber<SDLFloat> *)humidity {
    return [store sdl_objectForName:SDLNameHumidity];
}

- (void)setCloudCover:(nullable NSNumber<SDLFloat> *)cloudCover {
    [store sdl_setObject:cloudCover forName:SDLNameCloudCover];
}

- (nullable NSNumber<SDLFloat> *)cloudCover {
    return [store sdl_objectForName:SDLNameCloudCover];
}

- (void)setMoonPhase:(nullable NSNumber<SDLFloat> *)moonPhase {
    [store sdl_setObject:moonPhase forName:SDLNameMoonPhase];
}

- (nullable NSNumber<SDLFloat> *)moonPhase {
    return [store sdl_objectForName:SDLNameMoonPhase];
}

- (void)setWindBearing:(nullable NSNumber<SDLInt> *)windBearing {
    [store sdl_setObject:windBearing forName:SDLNameWindBearing];
}

- (nullable NSNumber<SDLInt> *)windBearing {
    return [store sdl_objectForName:SDLNameWindBearing];
}

- (void)setWindGust:(nullable NSNumber<SDLFloat> *)windGust {
    [store sdl_setObject:windGust forName:SDLNameWindGust];
}

- (nullable NSNumber<SDLFloat> *)windGust {
    return [store sdl_objectForName:SDLNameWindGust];
}

- (void)setWindSpeed:(nullable NSNumber<SDLFloat> *)windSpeed {
    [store sdl_setObject:windSpeed forName:SDLNameWindSpeed];
}

- (nullable NSNumber<SDLFloat> *)windSpeed {
    return [store sdl_objectForName:SDLNameWindSpeed];
}

- (void)setNearestStormBearing:(nullable NSNumber<SDLInt> *)nearestStormBearing {
    [store sdl_setObject:nearestStormBearing forName:SDLNameNearestStormBearing];
}

- (nullable NSNumber<SDLInt> *)nearestStormBearing {
    return [store sdl_objectForName:SDLNameNearestStormBearing];
}

- (void)setNearestStormDistance:(nullable NSNumber<SDLInt> *)nearestStormDistance {
    [store sdl_setObject:nearestStormDistance forName:SDLNameNearestStormDistance];
}

- (nullable NSNumber<SDLInt> *)nearestStormDistance {
    return [store sdl_objectForName:SDLNameNearestStormDistance];
}

- (void)setPrecipAccumulation:(nullable NSNumber<SDLFloat> *)precipAccumulation {
    [store sdl_setObject:precipAccumulation forName:SDLNamePrecipAccumulation];
}

- (nullable NSNumber<SDLFloat> *)precipAccumulation {
    return [store sdl_objectForName:SDLNamePrecipAccumulation];
}

- (void)setPrecipIntensity:(nullable NSNumber<SDLFloat> *)precipIntensity {
    [store sdl_setObject:precipIntensity forName:SDLNamePrecipIntensity];
}

- (nullable NSNumber<SDLFloat> *)precipIntensity {
    return [store sdl_objectForName:SDLNamePrecipIntensity];
}

- (void)setPrecipProbability:(nullable NSNumber<SDLFloat> *)precipProbability {
    [store sdl_setObject:precipProbability forName:SDLNamePrecipProbability];
}

- (nullable NSNumber<SDLFloat> *)precipProbability {
    return [store sdl_objectForName:SDLNamePrecipProbability];
}

- (void)setPrecipType:(nullable NSString *)precipType {
    [store sdl_setObject:precipType forName:SDLNamePrecipType];
}

- (nullable NSString *)precipType {
    return [store sdl_objectForName:SDLNamePrecipType];
}

- (void)setVisibility:(nullable NSNumber<SDLFloat> *)visibility {
    [store sdl_setObject:visibility forName:SDLNameVisibility];
}

- (nullable NSNumber<SDLFloat> *)visibility {
    return [store sdl_objectForName:SDLNameVisibility];
}

- (void)setWeatherIconImageName:(nullable NSString *)weatherIconImageName {
    [store sdl_setObject:weatherIconImageName forName:SDLNameWeatherIconImageName];
}

- (nullable NSString *)weatherIconImageName {
    return [store sdl_objectForName:SDLNameWeatherIconImageName];
}

@end

NS_ASSUME_NONNULL_END
