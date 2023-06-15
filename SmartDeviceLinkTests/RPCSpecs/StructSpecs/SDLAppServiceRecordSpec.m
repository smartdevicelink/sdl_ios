//
//  SDLAppServiceRecordSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 1/29/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;

#import "SDLAppServiceManifest.h"
#import "SDLAppServiceRecord.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLAppServiceRecordSpec)

describe(@"Getter/Setter Tests", ^{
    __block NSString *testServiceID = nil;
    __block SDLAppServiceManifest *testAppServiceManifest = nil;
    __block NSNumber<SDLBool> *testServicePublished = nil;
    __block NSNumber<SDLBool> *testServiceActive = nil;

    beforeEach(^{
        testServiceID = @"12345";
        testAppServiceManifest = [[SDLAppServiceManifest alloc] initWithDictionary:@{SDLRPCParameterNameAllowAppConsumers:@NO}];
        testServicePublished = @NO;
        testServiceActive = @YES;
    });

    it(@"Should set and get correctly", ^{
        SDLAppServiceRecord *testStruct = [[SDLAppServiceRecord alloc] init];
        testStruct.serviceID = testServiceID;
        testStruct.serviceManifest = testAppServiceManifest;
        testStruct.servicePublished = testServicePublished;
        testStruct.serviceActive = testServiceActive;

        expect(testStruct.serviceID).to(match(testServiceID));
        expect(testStruct.serviceManifest).to(equal(testAppServiceManifest));
        expect(testStruct.servicePublished).to(equal(testServicePublished));
        expect(testStruct.serviceActive).to(equal(testServiceActive));
    });

    it(@"Should initWithServiceId:serviceManifest:servicePublished:serviceActive: correctly", ^{
        SDLAppServiceRecord *testStruct = [[SDLAppServiceRecord alloc] initWithServiceID:testServiceID serviceManifest:testAppServiceManifest servicePublished:false serviceActive:true];

        expect(testStruct.serviceID).to(match(testServiceID));
        expect(testStruct.serviceManifest).to(equal(testAppServiceManifest));
        expect(testStruct.servicePublished).to(equal(testServicePublished));
        expect(testStruct.serviceActive).to(equal(testServiceActive));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameServiceID:testServiceID,
                               SDLRPCParameterNameServiceManifest:testAppServiceManifest,
                               SDLRPCParameterNameServicePublished:testServicePublished,
                               SDLRPCParameterNameServiceActive:testServiceActive
                                    };
        SDLAppServiceRecord *testStruct = [[SDLAppServiceRecord alloc] initWithDictionary:dict];

        expect(testStruct.serviceID).to(match(testServiceID));
        expect(testStruct.serviceManifest).to(equal(testAppServiceManifest));
        expect(testStruct.servicePublished).to(equal(testServicePublished));
        expect(testStruct.serviceActive).to(equal(testServiceActive));
    });

    it(@"Should return nil if not set", ^{
        SDLAppServiceRecord *testStruct = [[SDLAppServiceRecord alloc] init];

        expect(testStruct.serviceID).to(beNil());
        expect(testStruct.serviceManifest).to(beNil());
        expect(testStruct.servicePublished).to(beNil());
        expect(testStruct.serviceActive).to(beNil());
    });
});

QuickSpecEnd

