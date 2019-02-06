//
//  SDLPerformAppServiceInteractionSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPerformAppServiceInteraction.h"
#import "SDLNames.h"

QuickSpecBegin(SDLPerformAppServiceInteractionSpec)

describe(@"Getter/Setter Tests", ^{
    __block NSString *testServiceUri = nil;
    __block NSString *testAppServiceId = nil;
    __block NSString *testOriginApp = nil;
    __block BOOL testRequestServiceActive = nil;

    beforeEach(^{
        testServiceUri = @"testServiceUri";
        testAppServiceId = @"testAppServiceId";
        testOriginApp = @"testOriginApp";
        testRequestServiceActive = true;
    });

    it(@"Should set and get correctly", ^{
        SDLPerformAppServiceInteraction *testRequest = [[SDLPerformAppServiceInteraction alloc] init];
        testRequest.serviceUri = testServiceUri;
        testRequest.appServiceId = testAppServiceId;
        testRequest.originApp = testOriginApp;
        testRequest.requestServiceActive = @(testRequestServiceActive);

        expect(testRequest.serviceUri).to(equal(testServiceUri));
        expect(testRequest.appServiceId).to(equal(testAppServiceId));
        expect(testRequest.originApp).to(equal(testOriginApp));
        expect(testRequest.requestServiceActive).to(beTrue());
    });

    it(@"Should return nil if not set", ^{
        SDLPerformAppServiceInteraction *testRequest = [[SDLPerformAppServiceInteraction alloc] init];

        expect(testRequest.serviceUri).to(beNil());
        expect(testRequest.appServiceId).to(beNil());
        expect(testRequest.originApp).to(beNil());
        expect(testRequest.requestServiceActive).to(beNil());
    });

    describe(@"initializing", ^{
        it(@"Should initialize correctly with a dictionary", ^{
            NSDictionary *dict = @{SDLNameRequest:@{
                                           SDLNameParameters:@{
                                                   SDLNameServiceUri:testServiceUri,
                                                   SDLNameAppServiceId:testAppServiceId,
                                                   SDLNameOriginApp:testOriginApp,
                                                   SDLNameRequestServiceActive:@(testRequestServiceActive)
                                                   },
                                           SDLNameOperationName:SDLNamePerformAppServiceInteraction}};
            SDLPerformAppServiceInteraction *testRequest = [[SDLPerformAppServiceInteraction alloc] initWithDictionary:dict];

            expect(testRequest.serviceUri).to(equal(testServiceUri));
            expect(testRequest.appServiceId).to(equal(testAppServiceId));
            expect(testRequest.originApp).to(equal(testOriginApp));
            expect(testRequest.requestServiceActive).to(beTrue());
        });

        it(@"Should initialize correctly with initWithServiceUri:appServiceId:originApp:requestServiceActive:", ^{
            SDLPerformAppServiceInteraction *testRequest = [[SDLPerformAppServiceInteraction alloc] initWithServiceUri:testServiceUri appServiceId:testAppServiceId originApp:testOriginApp requestServiceActive:testRequestServiceActive];

            expect(testRequest.serviceUri).to(equal(testServiceUri));
            expect(testRequest.appServiceId).to(equal(testAppServiceId));
            expect(testRequest.originApp).to(equal(testOriginApp));
            expect(testRequest.requestServiceActive).to(beTrue());
        });
    });
});

QuickSpecEnd

