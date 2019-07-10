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
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLGetAppServiceDataSpec)

describe(@"Getter/Setter Tests", ^{
    __block NSString *testServiceType = nil;
    __block SDLAppServiceType testAppServiceType = nil;
    __block BOOL testSubscribe = nil;

    beforeEach(^{
        testServiceType = SDLAppServiceTypeWeather;
        testAppServiceType = SDLAppServiceTypeMedia;
        testSubscribe = YES;
    });

    it(@"Should set and get correctly", ^{
        SDLGetAppServiceData *testRequest = [[SDLGetAppServiceData alloc] init];
        testRequest.serviceType = testServiceType;
        testRequest.subscribe = @(testSubscribe);

        expect(testRequest.serviceType).to(equal(testServiceType));
        expect(testRequest.subscribe).to(beTrue());
    });

    it(@"Should initialize correctly with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameRequest:@{
                                       SDLRPCParameterNameParameters:@{
                                               SDLRPCParameterNameServiceType:testServiceType,
                                               SDLRPCParameterNameSubscribe:@(testSubscribe)
                                               },
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNameGetAppServiceData}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGetAppServiceData *testRequest = [[SDLGetAppServiceData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testRequest.serviceType).to(equal(testServiceType));
        expect(testRequest.subscribe).to(beTrue());
    });

    it(@"Should initialize correctly with initWithAppServiceType:", ^{
        SDLGetAppServiceData *testRequest = [[SDLGetAppServiceData alloc] initWithAppServiceType:testAppServiceType];

        expect(testRequest.serviceType).to(equal(testAppServiceType));
        expect(testRequest.subscribe).to(beNil());
    });

    it(@"Should initialize correctly with initAndSubscribeToAppServiceType:", ^{
        SDLGetAppServiceData *testRequest = [[SDLGetAppServiceData alloc] initAndSubscribeToAppServiceType:testAppServiceType];

        expect(testRequest.serviceType).to(equal(testAppServiceType));
        expect(testRequest.subscribe).to(beTrue());
    });

    it(@"Should initialize correctly with initAndUnsubscribeToAppServiceType:", ^{
        SDLGetAppServiceData *testRequest = [[SDLGetAppServiceData alloc] initAndUnsubscribeToAppServiceType:testAppServiceType];

        expect(testRequest.serviceType).to(equal(testAppServiceType));
        expect(testRequest.subscribe).to(beFalse());
    });

    it(@"Should return nil if not set", ^{
        SDLGetAppServiceData *testRequest = [[SDLGetAppServiceData alloc] init];

        expect(testRequest.serviceType).to(beNil());
        expect(testRequest.subscribe).to(beNil());
    });
});

QuickSpecEnd


