//
//  SDLAppServiceDataSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/5/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppServiceData.h"
#import "SDLAppServiceType.h"
#import "SDLMediaServiceData.h"
#import "SDLNavigationServiceData.h"
#import "SDLRPCParameterNames.h"
#import "SDLWeatherServiceData.h"

QuickSpecBegin(SDLAppServiceDataSpec)

describe(@"Getter/Setter Tests", ^{
    __block NSString *testServiceType = nil;
    __block SDLAppServiceType testAppServiceType = nil;
    __block NSString *testServiceId = nil;
    __block SDLMediaServiceData *testMediaServiceData = nil;
    __block SDLWeatherServiceData *testWeatherServiceData = nil;
    __block SDLNavigationServiceData *testNavigationServiceData = nil;

    beforeEach(^{
        testServiceType = SDLAppServiceTypeMedia;
        testAppServiceType = SDLAppServiceTypeNavigation;
        testServiceId = @"a1*54z";
        testMediaServiceData = [[SDLMediaServiceData alloc] init];
        testWeatherServiceData = [[SDLWeatherServiceData alloc] init];
        testNavigationServiceData = [[SDLNavigationServiceData alloc] init];
    });

    it(@"Should set and get correctly", ^{
        SDLAppServiceData *testStruct = [[SDLAppServiceData alloc] init];
        testStruct.serviceType = testServiceType;
        testStruct.serviceId = testServiceId;
        testStruct.mediaServiceData = testMediaServiceData;
        testStruct.weatherServiceData = testWeatherServiceData;
        testStruct.navigationServiceData = testNavigationServiceData;

        expect(testStruct.serviceType).to(equal(testServiceType));
        expect(testStruct.serviceId).to(equal(testServiceId));
        expect(testStruct.mediaServiceData).to(equal(testMediaServiceData));
        expect(testStruct.weatherServiceData).to(equal(testWeatherServiceData));
        expect(testStruct.navigationServiceData).to(equal(testNavigationServiceData));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameServiceType:testServiceType,
                               SDLRPCParameterNameServiceID:testServiceId,
                               SDLRPCParameterNameMediaServiceData:testMediaServiceData,
                               SDLRPCParameterNameWeatherServiceData:testWeatherServiceData,
                               SDLRPCParameterNameNavigationServiceData:testNavigationServiceData
                               };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLAppServiceData *testStruct = [[SDLAppServiceData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.serviceType).to(equal(testServiceType));
        expect(testStruct.serviceId).to(equal(testServiceId));
        expect(testStruct.mediaServiceData).to(equal(testMediaServiceData));
        expect(testStruct.weatherServiceData).to(equal(testWeatherServiceData));
        expect(testStruct.navigationServiceData).to(equal(testNavigationServiceData));
    });

    it(@"Should get correctly when initialized with initWithAppServiceType:serviceId:", ^{
        SDLAppServiceData *testStruct = [[SDLAppServiceData alloc] initWithAppServiceType:testAppServiceType serviceId:testServiceId];

        expect(testStruct.serviceType).to(equal(testAppServiceType));
        expect(testStruct.serviceId).to(equal(testServiceId));
        expect(testStruct.mediaServiceData).to(beNil());
        expect(testStruct.weatherServiceData).to(beNil());
        expect(testStruct.navigationServiceData).to(beNil());
    });

    it(@"Should get correctly when initialized with initWithMediaServiceData:serviceId:", ^{
        SDLAppServiceData *testStruct = [[SDLAppServiceData alloc] initWithMediaServiceData:testMediaServiceData serviceId:testServiceId];

        expect(testStruct.serviceType).to(equal(SDLAppServiceTypeMedia));
        expect(testStruct.serviceId).to(equal(testServiceId));
        expect(testStruct.mediaServiceData).to(equal(testMediaServiceData));
        expect(testStruct.weatherServiceData).to(beNil());
        expect(testStruct.navigationServiceData).to(beNil());
    });

    it(@"Should get correctly when initialized with initWithWeatherServiceData:serviceId:", ^{
        SDLAppServiceData *testStruct = [[SDLAppServiceData alloc] initWithWeatherServiceData:testWeatherServiceData serviceId:testServiceId];

        expect(testStruct.serviceType).to(equal(SDLAppServiceTypeWeather));
        expect(testStruct.serviceId).to(equal(testServiceId));
        expect(testStruct.mediaServiceData).to(beNil());
        expect(testStruct.weatherServiceData).to(equal(testWeatherServiceData));
        expect(testStruct.navigationServiceData).to(beNil());
    });

    it(@"Should get correctly when initialized with initWithNavigationServiceData:serviceId:", ^{
        SDLAppServiceData *testStruct = [[SDLAppServiceData alloc] initWithNavigationServiceData:testNavigationServiceData serviceId:testServiceId];

        expect(testStruct.serviceType).to(equal(SDLAppServiceTypeNavigation));
        expect(testStruct.serviceId).to(equal(testServiceId));
        expect(testStruct.mediaServiceData).to(beNil());
        expect(testStruct.weatherServiceData).to(beNil());
        expect(testStruct.navigationServiceData).to(equal(testNavigationServiceData));
    });

    it(@"Should get correctly when initialized with initWithServiceType:serviceId:mediaServiceData:weatherServiceData:navigationServiceData:", ^{
        SDLAppServiceData *testStruct = [[SDLAppServiceData alloc] initWithAppServiceType:testServiceType serviceId:testServiceId mediaServiceData:testMediaServiceData weatherServiceData:testWeatherServiceData navigationServiceData:testNavigationServiceData];

        expect(testStruct.serviceType).to(equal(testServiceType));
        expect(testStruct.serviceId).to(equal(testServiceId));
        expect(testStruct.mediaServiceData).to(equal(testMediaServiceData));
        expect(testStruct.weatherServiceData).to(equal(testWeatherServiceData));
        expect(testStruct.navigationServiceData).to(equal(testNavigationServiceData));
    });

    it(@"Should return nil if not set", ^{
        SDLAppServiceData *testStruct = [[SDLAppServiceData alloc] init];

        expect(testStruct.serviceType).to(beNil());
        expect(testStruct.serviceId).to(beNil());
        expect(testStruct.mediaServiceData).to(beNil());
        expect(testStruct.weatherServiceData).to(beNil());
        expect(testStruct.navigationServiceData).to(beNil());
    });
});

QuickSpecEnd
