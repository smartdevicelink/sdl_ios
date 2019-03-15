//
//  SDLWeatherDataSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDateTime.h"
#import "SDLImage.h"
#import "SDLRPCParameterNames.h"
#import "SDLTemperature.h"
#import "SDLWeatherData.h"

QuickSpecBegin(SDLWeatherDataSpec)

describe(@"Getter/Setter Tests", ^{
    __block SDLTemperature *testCurrentTemp = nil;
    __block SDLTemperature *testTempHigh = nil;
    __block SDLTemperature *testTempLow = nil;
    __block SDLTemperature *testApparentTemp = nil;
    __block SDLTemperature *testApparentTempHigh = nil;
    __block SDLTemperature *testApparentTempLow = nil;
    __block NSString *testWeatherSummary = nil;
    __block SDLDateTime *testTime = nil;
    __block float testHumidity = 0.175;
    __block float testCloudCover = 0.2;
    __block float testMoonPhase = 0.1;
    __block int testWindBearing = 1.65;
    __block float testWindGust = 34.2;
    __block float testWindSpeed = 12.01;
    __block int testNearestStormBearing = 1;
    __block int testNearestStormDistance = 45;
    __block float testPrecipAccumulation = 2.34;
    __block float testPrecipIntensity = 4.55;
    __block float testPrecipProbability = 0.45;
    __block NSString *testPrecipType = nil;
    __block float testVisibility = 0.1;
    __block SDLImage *testWeatherIcon = nil;

    beforeEach(^{
        testCurrentTemp = [[SDLTemperature alloc] initWithUnit:SDLTemperatureUnitFahrenheit value:2];
        testTempHigh = [[SDLTemperature alloc] initWithUnit:SDLTemperatureUnitFahrenheit value:3];
        testTempLow = [[SDLTemperature alloc] initWithUnit:SDLTemperatureUnitFahrenheit value:4];
        testApparentTemp = [[SDLTemperature alloc] initWithUnit:SDLTemperatureUnitFahrenheit value:5];
        testApparentTempHigh = [[SDLTemperature alloc] initWithUnit:SDLTemperatureUnitFahrenheit value:6];
        testApparentTempLow = [[SDLTemperature alloc] initWithUnit:SDLTemperatureUnitFahrenheit value:7];
        testWeatherSummary = @"testWeatherSummary";
        testTime = [[SDLDateTime alloc] initWithHour:4 minute:5];
        testPrecipType = @"testPrecipType";
        testWeatherIcon = [[SDLImage alloc] initWithName:@"testWeatherIcon" isTemplate:true];
    });

    it(@"Should set and get correctly", ^{
        SDLWeatherData *testStruct = [[SDLWeatherData alloc] init];
        testStruct.currentTemperature = testCurrentTemp;
        testStruct.temperatureHigh = testTempHigh;
        testStruct.temperatureLow = testTempLow;
        testStruct.apparentTemperature = testApparentTemp;
        testStruct.apparentTemperatureHigh = testApparentTempHigh;
        testStruct.apparentTemperatureLow = testApparentTempLow;
        testStruct.weatherSummary = testWeatherSummary;
        testStruct.time = testTime;
        testStruct.humidity = @(testHumidity);
        testStruct.cloudCover = @(testCloudCover);
        testStruct.moonPhase = @(testMoonPhase);
        testStruct.windBearing = @(testWindBearing);
        testStruct.windGust = @(testWindGust);
        testStruct.windSpeed = @(testWindSpeed);
        testStruct.nearestStormBearing = @(testNearestStormBearing);
        testStruct.nearestStormDistance = @(testNearestStormDistance);
        testStruct.precipAccumulation = @(testPrecipAccumulation);
        testStruct.precipIntensity = @(testPrecipIntensity);
        testStruct.precipProbability = @(testPrecipProbability);
        testStruct.precipType = testPrecipType;
        testStruct.visibility = @(testVisibility);
        testStruct.weatherIcon = testWeatherIcon;

        expect(testStruct.currentTemperature).to(equal(testCurrentTemp));
        expect(testStruct.temperatureHigh).to(equal(testTempHigh));
        expect(testStruct.temperatureLow).to(equal(testTempLow));
        expect(testStruct.apparentTemperature).to(equal(testApparentTemp));
        expect(testStruct.apparentTemperatureHigh).to(equal(testApparentTempHigh));
        expect(testStruct.apparentTemperatureLow).to(equal(testApparentTempLow));
        expect(testStruct.weatherSummary).to(equal(testWeatherSummary));
        expect(testStruct.time).to(equal(testTime));
        expect(testStruct.humidity).to(equal(testHumidity));
        expect(testStruct.cloudCover).to(equal(testCloudCover));
        expect(testStruct.moonPhase).to(equal(testMoonPhase));
        expect(testStruct.windBearing).to(equal(testWindBearing));
        expect(testStruct.windGust).to(equal(testWindGust));
        expect(testStruct.windSpeed).to(equal(testWindSpeed));
        expect(testStruct.nearestStormBearing).to(equal(testNearestStormBearing));
        expect(testStruct.nearestStormDistance).to(equal(testNearestStormDistance));
        expect(testStruct.precipAccumulation).to(equal(testPrecipAccumulation));
        expect(testStruct.precipIntensity).to(equal(testPrecipIntensity));
        expect(testStruct.precipProbability).to(equal(testPrecipProbability));
        expect(testStruct.precipType).to(equal(testPrecipType));
        expect(testStruct.visibility).to(equal(testVisibility));
        expect(testStruct.weatherIcon).to(equal(testWeatherIcon));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameCurrentTemperature:testCurrentTemp,
                               SDLRPCParameterNameTemperatureHigh:testTempHigh,
                               SDLRPCParameterNameTemperatureLow:testTempLow,
                               SDLRPCParameterNameApparentTemperature:testApparentTemp,
                               SDLRPCParameterNameApparentTemperatureHigh:testApparentTempHigh,
                               SDLRPCParameterNameApparentTemperatureLow:testApparentTempLow,
                               SDLRPCParameterNameWeatherSummary:testWeatherSummary,
                               SDLRPCParameterNameTime:testTime,
                               SDLRPCParameterNameHumidity:@(testHumidity),
                               SDLRPCParameterNameCloudCover:@(testCloudCover),
                               SDLRPCParameterNameMoonPhase:@(testMoonPhase),
                               SDLRPCParameterNameWindBearing:@(testWindBearing),
                               SDLRPCParameterNameWindGust:@(testWindGust),
                               SDLRPCParameterNameWindSpeed:@(testWindSpeed),
                               SDLRPCParameterNameNearestStormBearing:@(testNearestStormBearing),
                               SDLRPCParameterNameNearestStormDistance:@(testNearestStormDistance),
                               SDLRPCParameterNamePrecipAccumulation:@(testPrecipAccumulation),
                               SDLRPCParameterNamePrecipIntensity:@(testPrecipIntensity),
                               SDLRPCParameterNamePrecipProbability:@(testPrecipProbability),
                               SDLRPCParameterNamePrecipType:testPrecipType,
                               SDLRPCParameterNameVisibility:@(testVisibility),
                               SDLRPCParameterNameWeatherIcon:testWeatherIcon
                               };
        SDLWeatherData *testStruct = [[SDLWeatherData alloc] initWithDictionary:dict];

        expect(testStruct.currentTemperature).to(equal(testCurrentTemp));
        expect(testStruct.temperatureHigh).to(equal(testTempHigh));
        expect(testStruct.temperatureLow).to(equal(testTempLow));
        expect(testStruct.apparentTemperature).to(equal(testApparentTemp));
        expect(testStruct.apparentTemperatureHigh).to(equal(testApparentTempHigh));
        expect(testStruct.apparentTemperatureLow).to(equal(testApparentTempLow));
        expect(testStruct.weatherSummary).to(equal(testWeatherSummary));
        expect(testStruct.time).to(equal(testTime));
        expect(testStruct.humidity).to(equal(testHumidity));
        expect(testStruct.cloudCover).to(equal(testCloudCover));
        expect(testStruct.moonPhase).to(equal(testMoonPhase));
        expect(testStruct.windBearing).to(equal(testWindBearing));
        expect(testStruct.windGust).to(equal(testWindGust));
        expect(testStruct.windSpeed).to(equal(testWindSpeed));
        expect(testStruct.nearestStormBearing).to(equal(testNearestStormBearing));
        expect(testStruct.nearestStormDistance).to(equal(testNearestStormDistance));
        expect(testStruct.precipAccumulation).to(equal(testPrecipAccumulation));
        expect(testStruct.precipIntensity).to(equal(testPrecipIntensity));
        expect(testStruct.precipProbability).to(equal(testPrecipProbability));
        expect(testStruct.precipType).to(equal(testPrecipType));
        expect(testStruct.visibility).to(equal(testVisibility));
        expect(testStruct.weatherIcon).to(equal(testWeatherIcon));
    });

    it(@"Should get correctly when initialized with a convenience init", ^{
        SDLWeatherData *testStruct = [[SDLWeatherData alloc] initWithCurrentTemperature:testCurrentTemp temperatureHigh:testTempHigh temperatureLow:testTempLow apparentTemperature:testApparentTemp apparentTemperatureHigh:testApparentTempHigh apparentTemperatureLow:testApparentTempLow weatherSummary:testWeatherSummary time:testTime humidity:@(testHumidity) cloudCover:@(testCloudCover) moonPhase:@(testMoonPhase) windBearing:@(testWindBearing) windGust:@(testWindGust) windSpeed:@(testWindSpeed) nearestStormBearing:@(testNearestStormBearing) nearestStormDistance:@(testNearestStormDistance) precipAccumulation:@(testPrecipAccumulation) precipIntensity:@(testPrecipIntensity) precipProbability:@(testPrecipProbability) precipType:testPrecipType visibility:@(testVisibility) weatherIcon:testWeatherIcon];

        expect(testStruct.currentTemperature).to(equal(testCurrentTemp));
        expect(testStruct.temperatureHigh).to(equal(testTempHigh));
        expect(testStruct.temperatureLow).to(equal(testTempLow));
        expect(testStruct.apparentTemperature).to(equal(testApparentTemp));
        expect(testStruct.apparentTemperatureHigh).to(equal(testApparentTempHigh));
        expect(testStruct.apparentTemperatureLow).to(equal(testApparentTempLow));
        expect(testStruct.weatherSummary).to(equal(testWeatherSummary));
        expect(testStruct.time).to(equal(testTime));
        expect(testStruct.humidity).to(equal(testHumidity));
        expect(testStruct.cloudCover).to(equal(testCloudCover));
        expect(testStruct.moonPhase).to(equal(testMoonPhase));
        expect(testStruct.windBearing).to(equal(testWindBearing));
        expect(testStruct.windGust).to(equal(testWindGust));
        expect(testStruct.windSpeed).to(equal(testWindSpeed));
        expect(testStruct.nearestStormBearing).to(equal(testNearestStormBearing));
        expect(testStruct.nearestStormDistance).to(equal(testNearestStormDistance));
        expect(testStruct.precipAccumulation).to(equal(testPrecipAccumulation));
        expect(testStruct.precipIntensity).to(equal(testPrecipIntensity));
        expect(testStruct.precipProbability).to(equal(testPrecipProbability));
        expect(testStruct.precipType).to(equal(testPrecipType));
        expect(testStruct.visibility).to(equal(testVisibility));
        expect(testStruct.weatherIcon).to(equal(testWeatherIcon));
    });


    it(@"Should return nil if not set", ^{
        SDLWeatherData *testStruct = [[SDLWeatherData alloc] init];

        expect(testStruct.currentTemperature).to(beNil());
        expect(testStruct.temperatureHigh).to(beNil());
        expect(testStruct.temperatureLow).to(beNil());
        expect(testStruct.apparentTemperature).to(beNil());
        expect(testStruct.apparentTemperatureHigh).to(beNil());
        expect(testStruct.apparentTemperatureLow).to(beNil());
        expect(testStruct.weatherSummary).to(beNil());
        expect(testStruct.time).to(beNil());
        expect(testStruct.humidity).to(beNil());
        expect(testStruct.cloudCover).to(beNil());
        expect(testStruct.moonPhase).to(beNil());
        expect(testStruct.windBearing).to(beNil());
        expect(testStruct.windGust).to(beNil());
        expect(testStruct.windSpeed).to(beNil());
        expect(testStruct.nearestStormBearing).to(beNil());
        expect(testStruct.nearestStormDistance).to(beNil());
        expect(testStruct.precipAccumulation).to(beNil());
        expect(testStruct.precipIntensity).to(beNil());
        expect(testStruct.precipProbability).to(beNil());
        expect(testStruct.precipType).to(beNil());
        expect(testStruct.visibility).to(beNil());
        expect(testStruct.weatherIcon).to(beNil());
    });
});

QuickSpecEnd

