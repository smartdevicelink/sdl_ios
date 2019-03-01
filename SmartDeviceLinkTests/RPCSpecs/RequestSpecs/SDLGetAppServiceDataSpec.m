//
//  SDLGetAppServiceDataSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppServiceType.h"
#import "SDLGetAppServiceData.h"
#import "SDLNames.h"

QuickSpecBegin(SDLGetAppServiceDataSpec)

describe(@"Getter/Setter Tests", ^{
    __block NSString *testAppServiceType = nil;
    __block BOOL testSubscribe = nil;

    beforeEach(^{
        testAppServiceType = SDLAppServiceTypeWeather;
        testSubscribe = YES;
    });

    it(@"Should set and get correctly", ^{
        SDLGetAppServiceData *testRequest = [[SDLGetAppServiceData alloc] init];
        testRequest.serviceType = testAppServiceType;
        testRequest.subscribe = @(testSubscribe);

        expect(testRequest.serviceType).to(equal(testAppServiceType));
        expect(testRequest.subscribe).to(beTrue());
    });

    it(@"Should initialize correctly with a dictionary", ^{
        NSDictionary *dict = @{SDLNameRequest:@{
                                       SDLNameParameters:@{
                                               SDLNameServiceType:testAppServiceType,
                                               SDLNameSubscribe:@(testSubscribe)
                                               },
                                       SDLNameOperationName:SDLNameGetAppServiceData}};
        SDLGetAppServiceData *testRequest = [[SDLGetAppServiceData alloc] initWithDictionary:dict];

        expect(testRequest.serviceType).to(equal(testAppServiceType));
        expect(testRequest.subscribe).to(beTrue());
    });

    it(@"Should initialize correctly with initWithServiceType:", ^{
        SDLGetAppServiceData *testRequest = [[SDLGetAppServiceData alloc] initWithServiceType:testAppServiceType];

        expect(testRequest.serviceType).to(equal(testAppServiceType));
        expect(testRequest.subscribe).to(beNil());
    });

    it(@"Should initialize correctly with initWithServiceType:subscribe:", ^{
        SDLGetAppServiceData *testRequest = [[SDLGetAppServiceData alloc] initWithServiceType:testAppServiceType subscribe:testSubscribe];

        expect(testRequest.serviceType).to(equal(testAppServiceType));
        expect(testRequest.subscribe).to(beTrue());
    });

    it(@"Should return nil if not set", ^{
        SDLGetAppServiceData *testRequest = [[SDLGetAppServiceData alloc] init];

        expect(testRequest.serviceType).to(beNil());
        expect(testRequest.subscribe).to(beNil());
    });
});

QuickSpecEnd


