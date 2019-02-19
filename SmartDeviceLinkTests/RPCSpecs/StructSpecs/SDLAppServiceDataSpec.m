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
#import "SDLNames.h"
#import "SDLWeatherServiceData.h"

QuickSpecBegin(SDLAppServiceDataSpec)

describe(@"Getter/Setter Tests", ^{
    __block NSString *testServiceType = nil;
    __block NSString *testServiceId = nil;
    __block SDLMediaServiceData *testMediaServiceData = nil;
    __block SDLWeatherServiceData *testWeatherServiceData = nil;

    beforeEach(^{
        testServiceType = SDLAppServiceTypeMedia;
        testServiceId = @"a1*54z";
        testMediaServiceData = [[SDLMediaServiceData alloc] init];
        testWeatherServiceData = [[SDLWeatherServiceData alloc] init];
    });

    it(@"Should set and get correctly", ^{
        SDLAppServiceData *testStruct = [[SDLAppServiceData alloc] init];
        testStruct.serviceType = testServiceType;
        testStruct.serviceId = testServiceId;
        testStruct.mediaServiceData = testMediaServiceData;
        testStruct.weatherServiceData = testWeatherServiceData;

        expect(testStruct.serviceType).to(equal(testServiceType));
        expect(testStruct.serviceId).to(equal(testServiceId));
        expect(testStruct.mediaServiceData).to(equal(testMediaServiceData));
        expect(testStruct.weatherServiceData).to(equal(testWeatherServiceData));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLNameServiceType:testServiceType,
                               SDLNameServiceID:testServiceId,
                               SDLNameMediaServiceData:testMediaServiceData,
                               SDLNameWeatherServiceData:testWeatherServiceData
                               };
        SDLAppServiceData *testStruct = [[SDLAppServiceData alloc] initWithDictionary:dict];

        expect(testStruct.serviceType).to(equal(testServiceType));
        expect(testStruct.serviceId).to(equal(testServiceId));
        expect(testStruct.mediaServiceData).to(equal(testMediaServiceData));
        expect(testStruct.weatherServiceData).to(equal(testWeatherServiceData));
    });

    it(@"Should return nil if not set", ^{
        SDLAppServiceData *testStruct = [[SDLAppServiceData alloc] init];

        expect(testStruct.serviceType).to(beNil());
        expect(testStruct.serviceId).to(beNil());
        expect(testStruct.mediaServiceData).to(beNil());
        expect(testStruct.weatherServiceData).to(beNil());
    });
});

QuickSpecEnd
