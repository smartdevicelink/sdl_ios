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
#import "SDLImage.h"
#import "SDLRPCParameterNames.h"
#import "SDLTemperature.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLWeatherData

- (instancetype)initWithCurrentTemperature:(nullable SDLTemperature *)currentTemperature temperatureHigh:(nullable SDLTemperature *)temperatureHigh temperatureLow:(nullable SDLTemperature *)temperatureLow apparentTemperature:(nullable SDLTemperature *)apparentTemperature apparentTemperatureHigh:(nullable SDLTemperature *)apparentTemperatureHigh apparentTemperatureLow:(nullable SDLTemperature *)apparentTemperatureLow weatherSummary:(nullable NSString *)weatherSummary time:(nullable SDLDateTime *)time humidity:(nullable NSNumber<SDLFloat> *)humidity cloudCover:(nullable NSNumber<SDLFloat> *)cloudCover moonPhase:(nullable NSNumber<SDLFloat> *)moonPhase windBearing:(nullable NSNumber<SDLInt> *)windBearing windGust:(nullable NSNumber<SDLFloat> *)windGust windSpeed:(nullable NSNumber<SDLFloat> *)windSpeed nearestStormBearing:(nullable NSNumber<SDLInt> *)nearestStormBearing nearestStormDistance:(nullable NSNumber<SDLInt> *)nearestStormDistance precipAccumulation:(nullable NSNumber<SDLFloat> *)precipAccumulation precipIntensity:(nullable NSNumber<SDLFloat> *)precipIntensity precipProbability:(nullable NSNumber<SDLFloat> *)precipProbability precipType:(nullable NSString *)precipType visibility:(nullable NSNumber<SDLFloat> *)visibility weatherIcon:(nullable SDLImage *)weatherIcon {
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
    self.weatherIcon = weatherIcon;

    return self;
}

- (void)setCurrentTemperature:(nullable SDLTemperature *)currentTemperature {
    [store sdl_setObject:currentTemperature forName:SDLRPCParameterNameCurrentTemperature];
}

- (nullable SDLTemperature *)currentTemperature {
    return [store sdl_objectForName:SDLRPCParameterNameCurrentTemperature ofClass:SDLTemperature.class error:nil];
}

- (void)setTemperatureHigh:(nullable SDLTemperature *)temperatureHigh {
    [store sdl_setObject:temperatureHigh forName:SDLRPCParameterNameTemperatureHigh];
}

- (nullable SDLTemperature *)temperatureHigh {
    return [store sdl_objectForName:SDLRPCParameterNameTemperatureHigh ofClass:SDLTemperature.class error:nil];
}

- (void)setTemperatureLow:(nullable SDLTemperature *)temperatureLow {
    [store sdl_setObject:temperatureLow forName:SDLRPCParameterNameTemperatureLow];
}

- (nullable SDLTemperature *)temperatureLow {
    return [store sdl_objectForName:SDLRPCParameterNameTemperatureLow ofClass:SDLTemperature.class error:nil];
}

- (void)setApparentTemperature:(nullable SDLTemperature *)apparentTemperature {
    [store sdl_setObject:apparentTemperature forName:SDLRPCParameterNameApparentTemperature];
}

- (nullable SDLTemperature *)apparentTemperature {
    return [store sdl_objectForName:SDLRPCParameterNameApparentTemperature ofClass:SDLTemperature.class error:nil];
}

- (void)setApparentTemperatureHigh:(nullable SDLTemperature *)apparentTemperatureHigh {
    [store sdl_setObject:apparentTemperatureHigh forName:SDLRPCParameterNameApparentTemperatureHigh];
}

- (nullable SDLTemperature *)apparentTemperatureHigh {
    return [store sdl_objectForName:SDLRPCParameterNameApparentTemperatureHigh ofClass:SDLTemperature.class error:nil];
}

- (void)setApparentTemperatureLow:(nullable SDLTemperature *)apparentTemperatureLow {
    [store sdl_setObject:apparentTemperatureLow forName:SDLRPCParameterNameApparentTemperatureLow];
}

- (nullable SDLTemperature *)apparentTemperatureLow {
    return [store sdl_objectForName:SDLRPCParameterNameApparentTemperatureLow ofClass:SDLTemperature.class error:nil];
}

- (void)setWeatherSummary:(nullable NSString *)weatherSummary {
    [store sdl_setObject:weatherSummary forName:SDLRPCParameterNameWeatherSummary];
}

- (nullable NSString *)weatherSummary {
    return [store sdl_objectForName:SDLRPCParameterNameWeatherSummary ofClass:NSString.class error:nil];
}

- (void)setTime:(nullable SDLDateTime *)time {
    [store sdl_setObject:time forName:SDLRPCParameterNameTime];
}

- (nullable SDLDateTime *)time {
    return [store sdl_objectForName:SDLRPCParameterNameTime ofClass:SDLDateTime.class error:nil];
}

- (void)setHumidity:(nullable NSNumber<SDLFloat> *)humidity {
    [store sdl_setObject:humidity forName:SDLRPCParameterNameHumidity];
}

- (nullable NSNumber<SDLFloat> *)humidity {
    return [store sdl_objectForName:SDLRPCParameterNameHumidity ofClass:NSNumber.class error:nil];
}

- (void)setCloudCover:(nullable NSNumber<SDLFloat> *)cloudCover {
    [store sdl_setObject:cloudCover forName:SDLRPCParameterNameCloudCover];
}

- (nullable NSNumber<SDLFloat> *)cloudCover {
    return [store sdl_objectForName:SDLRPCParameterNameCloudCover ofClass:NSNumber.class error:nil];
}

- (void)setMoonPhase:(nullable NSNumber<SDLFloat> *)moonPhase {
    [store sdl_setObject:moonPhase forName:SDLRPCParameterNameMoonPhase];
}

- (nullable NSNumber<SDLFloat> *)moonPhase {
    return [store sdl_objectForName:SDLRPCParameterNameMoonPhase ofClass:NSNumber.class error:nil];
}

- (void)setWindBearing:(nullable NSNumber<SDLInt> *)windBearing {
    [store sdl_setObject:windBearing forName:SDLRPCParameterNameWindBearing];
}

- (nullable NSNumber<SDLInt> *)windBearing {
    return [store sdl_objectForName:SDLRPCParameterNameWindBearing ofClass:NSNumber.class error:nil];
}

- (void)setWindGust:(nullable NSNumber<SDLFloat> *)windGust {
    [store sdl_setObject:windGust forName:SDLRPCParameterNameWindGust];
}

- (nullable NSNumber<SDLFloat> *)windGust {
    return [store sdl_objectForName:SDLRPCParameterNameWindGust ofClass:NSNumber.class error:nil];
}

- (void)setWindSpeed:(nullable NSNumber<SDLFloat> *)windSpeed {
    [store sdl_setObject:windSpeed forName:SDLRPCParameterNameWindSpeed];
}

- (nullable NSNumber<SDLFloat> *)windSpeed {
    return [store sdl_objectForName:SDLRPCParameterNameWindSpeed ofClass:NSNumber.class error:nil];
}

- (void)setNearestStormBearing:(nullable NSNumber<SDLInt> *)nearestStormBearing {
    [store sdl_setObject:nearestStormBearing forName:SDLRPCParameterNameNearestStormBearing];
}

- (nullable NSNumber<SDLInt> *)nearestStormBearing {
    return [store sdl_objectForName:SDLRPCParameterNameNearestStormBearing ofClass:NSNumber.class error:nil];
}

- (void)setNearestStormDistance:(nullable NSNumber<SDLInt> *)nearestStormDistance {
    [store sdl_setObject:nearestStormDistance forName:SDLRPCParameterNameNearestStormDistance];
}

- (nullable NSNumber<SDLInt> *)nearestStormDistance {
    return [store sdl_objectForName:SDLRPCParameterNameNearestStormDistance ofClass:NSNumber.class error:nil];
}

- (void)setPrecipAccumulation:(nullable NSNumber<SDLFloat> *)precipAccumulation {
    [store sdl_setObject:precipAccumulation forName:SDLRPCParameterNamePrecipAccumulation];
}

- (nullable NSNumber<SDLFloat> *)precipAccumulation {
    return [store sdl_objectForName:SDLRPCParameterNamePrecipAccumulation ofClass:NSNumber.class error:nil];
}

- (void)setPrecipIntensity:(nullable NSNumber<SDLFloat> *)precipIntensity {
    [store sdl_setObject:precipIntensity forName:SDLRPCParameterNamePrecipIntensity];
}

- (nullable NSNumber<SDLFloat> *)precipIntensity {
    return [store sdl_objectForName:SDLRPCParameterNamePrecipIntensity ofClass:NSNumber.class error:nil];
}

- (void)setPrecipProbability:(nullable NSNumber<SDLFloat> *)precipProbability {
    [store sdl_setObject:precipProbability forName:SDLRPCParameterNamePrecipProbability];
}

- (nullable NSNumber<SDLFloat> *)precipProbability {
    return [store sdl_objectForName:SDLRPCParameterNamePrecipProbability ofClass:NSNumber.class error:nil];
}

- (void)setPrecipType:(nullable NSString *)precipType {
    [store sdl_setObject:precipType forName:SDLRPCParameterNamePrecipType];
}

- (nullable NSString *)precipType {
    return [store sdl_objectForName:SDLRPCParameterNamePrecipType ofClass:NSString.class error:nil];
}

- (void)setVisibility:(nullable NSNumber<SDLFloat> *)visibility {
    [store sdl_setObject:visibility forName:SDLRPCParameterNameVisibility];
}

- (nullable NSNumber<SDLFloat> *)visibility {
    return [store sdl_objectForName:SDLRPCParameterNameVisibility ofClass:NSNumber.class error:nil];
}

- (void)setWeatherIcon:(nullable SDLImage *)weatherIcon {
    [store sdl_setObject:weatherIcon forName:SDLRPCParameterNameWeatherIcon];
}

- (nullable SDLImage *)weatherIcon {
    return [store sdl_objectForName:SDLRPCParameterNameWeatherIcon ofClass:SDLImage.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
