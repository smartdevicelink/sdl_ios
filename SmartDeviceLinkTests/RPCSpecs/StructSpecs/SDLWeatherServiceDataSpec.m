//
//  SDLWeatherServiceDataSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/8/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLocationDetails.h"
#import "SDLRPCParameterNames.h"
#import "SDLWeatherData.h"
#import "SDLWeatherAlert.h"
#import "SDLWeatherServiceData.h"

QuickSpecBegin(SDLWeatherServiceDataSpec)

describe(@"Getter/Setter Tests", ^{
    __block SDLLocationDetails *testLocation = nil;
    __block SDLWeatherData *testCurrentForecast = nil;
    __block NSArray<SDLWeatherData *> *testMinuteForecast = nil;
    __block NSArray<SDLWeatherData *> *testHourlyForecast = nil;
    __block NSArray<SDLWeatherData *> *testMultidayForecast = nil;
    __block NSArray<SDLWeatherAlert *> *testAlerts = nil;

    beforeEach(^{
        testLocation = [[SDLLocationDetails alloc] init];
        testLocation.locationName = @"testLocationName";

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLWeatherData *testWeatherDataA = [[SDLWeatherData alloc] initWithDictionary:@{SDLRPCParameterNameWeatherSummary:@"testWeatherDataA"}];
        SDLWeatherData *testWeatherDataB = [[SDLWeatherData alloc] initWithDictionary:@{SDLRPCParameterNameWeatherSummary:@"testWeatherDataB"}];
        SDLWeatherData *testWeatherDataC = [[SDLWeatherData alloc] initWithDictionary:@{SDLRPCParameterNameWeatherSummary:@"testWeatherDataC"}];
        testCurrentForecast = testWeatherDataA;
        testMinuteForecast = @[testWeatherDataA];
        testHourlyForecast = @[testWeatherDataB, testWeatherDataA];
        testMultidayForecast = @[testWeatherDataA, testWeatherDataC];

        SDLWeatherAlert *testWeatherAlertA = [[SDLWeatherAlert alloc] initWithDictionary:@{SDLRPCParameterNameTitle:@"testWeatherAlertA"}];
#pragma clang diagnostic pop
        testAlerts = @[testWeatherAlertA];
    });

    it(@"Should set and get correctly", ^{
        SDLWeatherServiceData *testStruct = [[SDLWeatherServiceData alloc] init];
        testStruct.location = testLocation;
        testStruct.currentForecast = testCurrentForecast;
        testStruct.minuteForecast = testMinuteForecast;
        testStruct.hourlyForecast = testHourlyForecast;
        testStruct.multidayForecast = testMultidayForecast;
        testStruct.alerts = testAlerts;

        expect(testStruct.location).to(equal(testLocation));
        expect(testStruct.currentForecast).to(equal(testCurrentForecast));
        expect(testStruct.minuteForecast).to(equal(testMinuteForecast));
        expect(testStruct.hourlyForecast).to(equal(testHourlyForecast));
        expect(testStruct.multidayForecast).to(equal(testMultidayForecast));
        expect(testStruct.alerts).to(equal(testAlerts));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameLocation:testLocation,
                               SDLRPCParameterNameCurrentForecast:testCurrentForecast,
                               SDLRPCParameterNameMinuteForecast:testMinuteForecast,
                               SDLRPCParameterNameHourlyForecast:testHourlyForecast,
                               SDLRPCParameterNameMultidayForecast:testMultidayForecast,
                               SDLRPCParameterNameAlerts:testAlerts
                               };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLWeatherServiceData *testStruct = [[SDLWeatherServiceData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.location).to(equal(testLocation));
        expect(testStruct.currentForecast).to(equal(testCurrentForecast));
        expect(testStruct.minuteForecast).to(equal(testMinuteForecast));
        expect(testStruct.hourlyForecast).to(equal(testHourlyForecast));
        expect(testStruct.multidayForecast).to(equal(testMultidayForecast));
        expect(testStruct.alerts).to(equal(testAlerts));
    });

    it(@"Should get correctly when initialized with initWithLocation:", ^{
        SDLWeatherServiceData *testStruct = [[SDLWeatherServiceData alloc] initWithLocation:testLocation];

        expect(testStruct.location).to(equal(testLocation));
        expect(testStruct.currentForecast).to(beNil());
        expect(testStruct.minuteForecast).to(beNil());
        expect(testStruct.hourlyForecast).to(beNil());
        expect(testStruct.multidayForecast).to(beNil());
        expect(testStruct.alerts).to(beNil());
    });

    it(@"Should get correctly when initialized with initWithLocation:currentForecast:currentForecast minuteForecast:hourlyForecast:multidayForecast:alerts:", ^{
        SDLWeatherServiceData *testStruct = [[SDLWeatherServiceData alloc] initWithLocation:testLocation currentForecast:testCurrentForecast minuteForecast:testMinuteForecast hourlyForecast:testHourlyForecast multidayForecast:testMultidayForecast alerts:testAlerts];

        expect(testStruct.location).to(equal(testLocation));
        expect(testStruct.currentForecast).to(equal(testCurrentForecast));
        expect(testStruct.minuteForecast).to(equal(testMinuteForecast));
        expect(testStruct.hourlyForecast).to(equal(testHourlyForecast));
        expect(testStruct.multidayForecast).to(equal(testMultidayForecast));
        expect(testStruct.alerts).to(equal(testAlerts));
    });

    it(@"Should return nil if not set", ^{
        SDLWeatherServiceData *testStruct = [[SDLWeatherServiceData alloc] init];
        
        expect(testStruct.location).to(beNil());
        expect(testStruct.currentForecast).to(beNil());
        expect(testStruct.minuteForecast).to(beNil());
        expect(testStruct.hourlyForecast).to(beNil());
        expect(testStruct.multidayForecast).to(beNil());
        expect(testStruct.alerts).to(beNil());
    });
});

QuickSpecEnd


