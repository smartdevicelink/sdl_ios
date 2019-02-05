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
#import "SDLNames.h"

QuickSpecBegin(SDLAppServiceDataSpec)

describe(@"Getter/Setter Tests", ^{
    __block SDLAppServiceType testServiceType = nil;
    __block NSString *testServiceId = nil;

    beforeEach(^{
        testServiceType = SDLAppServiceTypeGeneric;
        testServiceId = @"a1*54z";
    });

    it(@"Should set and get correctly", ^{
        SDLAppServiceData *testStruct = [[SDLAppServiceData alloc] init];
        testStruct.serviceType = testServiceType;
        testStruct.serviceId = testServiceId;

        expect(testStruct.serviceType).to(equal(testServiceType));
        expect(testStruct.serviceId).to(equal(testServiceId));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLNameServiceType:testServiceType,
                               SDLNameServiceId:testServiceId,
                               };
        SDLAppServiceData *testStruct = [[SDLAppServiceData alloc] initWithDictionary:dict];

        expect(testStruct.serviceType).to(equal(testServiceType));
        expect(testStruct.serviceId).to(equal(testServiceId));
    });

    it(@"Should return nil if not set", ^{
        SDLAppServiceData *testStruct = [[SDLAppServiceData alloc] init];

        expect(testStruct.serviceType).to(beNil());
        expect(testStruct.serviceId).to(beNil());
    });
});

QuickSpecEnd
