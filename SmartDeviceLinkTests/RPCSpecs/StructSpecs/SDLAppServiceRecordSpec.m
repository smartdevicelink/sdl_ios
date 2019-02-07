//
//  SDLAppServiceRecordSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 1/29/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppServiceManifest.h"
#import "SDLAppServiceRecord.h"
#import "SDLNames.h"

QuickSpecBegin(SDLAppServiceRecordSpec)

describe(@"Getter/Setter Tests", ^{
    __block NSString *testServiceId = nil;
    __block SDLAppServiceManifest *testAppServiceManifest = nil;
    __block NSNumber<SDLBool> *testServicePublished = nil;
    __block NSNumber<SDLBool> *testServiceActive = nil;

    beforeEach(^{
        testServiceId = @"12345";
        testAppServiceManifest = [[SDLAppServiceManifest alloc] initWithDictionary:@{SDLNameAllowAppConsumers:@NO}];
        testServicePublished = @NO;
        testServiceActive = @YES;
    });

    it(@"Should set and get correctly", ^{
        SDLAppServiceRecord *testStruct = [[SDLAppServiceRecord alloc] init];
        testStruct.serviceId = testServiceId;
        testStruct.serviceManifest = testAppServiceManifest;
        testStruct.servicePublished = testServicePublished;
        testStruct.serviceActive = testServiceActive;

        expect(testStruct.serviceId).to(match(testServiceId));
        expect(testStruct.serviceManifest).to(equal(testAppServiceManifest));
        expect(testStruct.servicePublished).to(equal(testServicePublished));
        expect(testStruct.serviceActive).to(equal(testServiceActive));
    });

    it(@"Should initWithServiceId:serviceManifest:servicePublished:serviceActive: correctly", ^{
        SDLAppServiceRecord *testStruct = [[SDLAppServiceRecord alloc] initWithServiceId:testServiceId serviceManifest:testAppServiceManifest servicePublished:false serviceActive:true];

        expect(testStruct.serviceId).to(match(testServiceId));
        expect(testStruct.serviceManifest).to(equal(testAppServiceManifest));
        expect(testStruct.servicePublished).to(equal(testServicePublished));
        expect(testStruct.serviceActive).to(equal(testServiceActive));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLNameServiceId:testServiceId,
                               SDLNameServiceManifest:testAppServiceManifest,
                               SDLNameServicePublished:testServicePublished,
                               SDLNameServiceActive:testServiceActive
                                    };
        SDLAppServiceRecord *testStruct = [[SDLAppServiceRecord alloc] initWithDictionary:dict];

        expect(testStruct.serviceId).to(match(testServiceId));
        expect(testStruct.serviceManifest).to(equal(testAppServiceManifest));
        expect(testStruct.servicePublished).to(equal(testServicePublished));
        expect(testStruct.serviceActive).to(equal(testServiceActive));
    });

    it(@"Should return nil if not set", ^{
        SDLAppServiceRecord *testStruct = [[SDLAppServiceRecord alloc] init];

        expect(testStruct.serviceId).to(beNil());
        expect(testStruct.serviceManifest).to(beNil());
        expect(testStruct.servicePublished).to(beNil());
        expect(testStruct.serviceActive).to(beNil());
    });
});

QuickSpecEnd

