//
//  SDLAppServicesCapabilitiesSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 1/30/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppServiceCapability.h"
#import "SDLAppServicesCapabilities.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLAppServicesCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^{
    __block NSArray<SDLAppServiceCapability *> *testAppServices = nil;

    beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testAppServices = @[[[SDLAppServiceCapability alloc] initWithDictionary:@{SDLRPCParameterNameUpdateReason:SDLServiceUpdateRemoved}]];
#pragma clang diagnostic pop
    });

    it(@"Should set and get correctly", ^{
        SDLAppServicesCapabilities *testStruct = [[SDLAppServicesCapabilities alloc] init];
        testStruct.appServices = testAppServices;

        expect(testStruct.appServices).to(equal(testAppServices));
    });

    it(@"Should set and get with initWithServicesSupported:appServices:", ^{
        SDLAppServicesCapabilities *testStruct = [[SDLAppServicesCapabilities alloc] initWithAppServices:testAppServices];

        expect(testStruct.appServices).to(equal(testAppServices));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameAppServices:testAppServices
                               };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLAppServicesCapabilities *testStruct = [[SDLAppServicesCapabilities alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.appServices).to(equal(testAppServices));
    });

    it(@"Should return nil if not set", ^{
        SDLAppServicesCapabilities *testStruct = [[SDLAppServicesCapabilities alloc] init];

        expect(testStruct.appServices).to(beNil());
    });
});

QuickSpecEnd
