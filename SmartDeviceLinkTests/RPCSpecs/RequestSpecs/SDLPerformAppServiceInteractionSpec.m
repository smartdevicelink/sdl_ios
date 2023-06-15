//
//  SDLPerformAppServiceInteractionSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;

#import "SDLPerformAppServiceInteraction.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLPerformAppServiceInteractionSpec)

describe(@"Getter/Setter Tests", ^{
    __block NSString *testServiceUri = nil;
    __block NSString *testServiceID = nil;
    __block NSString *testOriginApp = nil;
    __block BOOL testRequestServiceActive = nil;

    beforeEach(^{
        testServiceUri = @"testServiceUri";
        testServiceID = @"testServiceID";
        testOriginApp = @"testOriginApp";
        testRequestServiceActive = true;
    });

    it(@"Should set and get correctly", ^{
        SDLPerformAppServiceInteraction *testRequest = [[SDLPerformAppServiceInteraction alloc] init];
        testRequest.serviceUri = testServiceUri;
        testRequest.serviceID = testServiceID;
        testRequest.originApp = testOriginApp;
        testRequest.requestServiceActive = @(testRequestServiceActive);

        expect(testRequest.serviceUri).to(equal(testServiceUri));
        expect(testRequest.serviceID).to(equal(testServiceID));
        expect(testRequest.originApp).to(equal(testOriginApp));
        expect(testRequest.requestServiceActive).to(beTrue());
    });

    it(@"Should initialize correctly with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameRequest:@{
                                       SDLRPCParameterNameParameters:@{
                                               SDLRPCParameterNameServiceUri:testServiceUri,
                                               SDLRPCParameterNameServiceID:testServiceID,
                                               SDLRPCParameterNameOriginApp:testOriginApp,
                                               SDLRPCParameterNameRequestServiceActive:@(testRequestServiceActive)
                                               },
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNamePerformAppServiceInteraction}};
        SDLPerformAppServiceInteraction *testRequest = [[SDLPerformAppServiceInteraction alloc] initWithDictionary:dict];

        expect(testRequest.serviceUri).to(equal(testServiceUri));
        expect(testRequest.serviceID).to(equal(testServiceID));
        expect(testRequest.originApp).to(equal(testOriginApp));
        expect(testRequest.requestServiceActive).to(beTrue());
    });

    it(@"Should initialize correctly with initWithServiceUri:appServiceId:originApp:", ^{
        SDLPerformAppServiceInteraction *testRequest = [[SDLPerformAppServiceInteraction alloc] initWithServiceUri:testServiceUri serviceID:testServiceID originApp:testOriginApp];

        expect(testRequest.serviceUri).to(equal(testServiceUri));
        expect(testRequest.serviceID).to(equal(testServiceID));
        expect(testRequest.originApp).to(equal(testOriginApp));
        expect(testRequest.requestServiceActive).to(beNil());
    });

    it(@"Should initialize correctly with initWithServiceUri:appServiceId:originApp:requestServiceActive:", ^{
        SDLPerformAppServiceInteraction *testRequest = [[SDLPerformAppServiceInteraction alloc] initWithServiceUri:testServiceUri serviceID:testServiceID originApp:testOriginApp requestServiceActive:testRequestServiceActive];

        expect(testRequest.serviceUri).to(equal(testServiceUri));
        expect(testRequest.serviceID).to(equal(testServiceID));
        expect(testRequest.originApp).to(equal(testOriginApp));
        expect(testRequest.requestServiceActive).to(beTrue());
    });

    it(@"Should return nil if not set", ^{
        SDLPerformAppServiceInteraction *testRequest = [[SDLPerformAppServiceInteraction alloc] init];

        expect(testRequest.serviceUri).to(beNil());
        expect(testRequest.serviceID).to(beNil());
        expect(testRequest.originApp).to(beNil());
        expect(testRequest.requestServiceActive).to(beNil());
    });
});

QuickSpecEnd

