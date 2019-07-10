//
//  SDLWeatherAlertSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDateTime.h"
#import "SDLRPCParameterNames.h"
#import "SDLWeatherAlert.h"

QuickSpecBegin(SDLWeatherAlertSpec)

describe(@"Getter/Setter Tests", ^{
    __block NSString *testTitle = nil;
    __block NSString *testSummary = nil;
    __block SDLDateTime *testExpires = nil;
    __block NSArray<NSString *> *testRegions = nil;
    __block NSString *testSeverity = nil;
    __block SDLDateTime *testTimeIssued = nil;

    beforeEach(^{
        testTitle = @"testTitle";
        testSummary = @"testSummary";
        testExpires = [[SDLDateTime alloc] initWithHour:5 minute:1 second:2 millisecond:2];
        testRegions = @[@"testRegion1" , @"testRegion2"];
        testSeverity = @"testSeverity";
        testTimeIssued = [[SDLDateTime alloc] initWithHour:3 minute:1 second:1 millisecond:23 day:1 month:2 year:1223];
    });

    it(@"Should set and get correctly", ^{
        SDLWeatherAlert *testStruct = [[SDLWeatherAlert alloc] init];
        testStruct.title = testTitle;
        testStruct.summary = testSummary;
        testStruct.expires = testExpires;
        testStruct.regions = testRegions;
        testStruct.severity = testSeverity;
        testStruct.timeIssued = testTimeIssued;

        expect(testStruct.title).to(equal(testTitle));
        expect(testStruct.summary).to(equal(testSummary));
        expect(testStruct.expires).to(equal(testExpires));
        expect(testStruct.regions).to(equal(testRegions));
        expect(testStruct.severity).to(equal(testSeverity));
        expect(testStruct.timeIssued).to(equal(testTimeIssued));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameTitle:testTitle,
                               SDLRPCParameterNameSummary:testSummary,
                               SDLRPCParameterNameExpires:testExpires,
                               SDLRPCParameterNameRegions:testRegions,
                               SDLRPCParameterNameSeverity:testSeverity,
                               SDLRPCParameterNameTimeIssued:testTimeIssued
                               };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLWeatherAlert *testStruct = [[SDLWeatherAlert alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.title).to(equal(testTitle));
        expect(testStruct.summary).to(equal(testSummary));
        expect(testStruct.expires).to(equal(testExpires));
        expect(testStruct.regions).to(equal(testRegions));
        expect(testStruct.severity).to(equal(testSeverity));
        expect(testStruct.timeIssued).to(equal(testTimeIssued));
    });

    it(@"Should get correctly when initialized with a convenience init", ^{
        SDLWeatherAlert *testStruct = [[SDLWeatherAlert alloc] initWithTitle:testTitle summary:testSummary expires:testExpires regions:testRegions severity:testSeverity timeIssued:testTimeIssued];

        expect(testStruct.title).to(equal(testTitle));
        expect(testStruct.summary).to(equal(testSummary));
        expect(testStruct.expires).to(equal(testExpires));
        expect(testStruct.regions).to(equal(testRegions));
        expect(testStruct.severity).to(equal(testSeverity));
        expect(testStruct.timeIssued).to(equal(testTimeIssued));
    });

    it(@"Should return nil if not set", ^{
        SDLWeatherAlert *testStruct = [[SDLWeatherAlert alloc] init];

        expect(testStruct.title).to(beNil());
        expect(testStruct.summary).to(beNil());
        expect(testStruct.expires).to(beNil());
        expect(testStruct.regions).to(beNil());
        expect(testStruct.severity).to(beNil());
        expect(testStruct.timeIssued).to(beNil());
    });
});

QuickSpecEnd

