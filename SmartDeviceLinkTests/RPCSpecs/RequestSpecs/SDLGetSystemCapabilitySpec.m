//
//  SDLGetSystemCapabilitySpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;

#import "SDLGetSystemCapability.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSystemCapabilityType.h"

QuickSpecBegin(SDLGetSystemCapabilitySpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLSystemCapabilityType testSystemCapabilityType = nil;
    __block BOOL testSubcribe = nil;

    beforeEach(^{
        testSystemCapabilityType = SDLSystemCapabilityTypeAppServices;
        testSubcribe = NO;
    });

    it(@"Should set and get correctly", ^{
        SDLGetSystemCapability *testRequest = [[SDLGetSystemCapability alloc] init];
        testRequest.systemCapabilityType = testSystemCapabilityType;
        testRequest.subscribe = @(testSubcribe);

        expect(testRequest.systemCapabilityType).to(equal(testSystemCapabilityType));
        expect(testRequest.subscribe).to(beFalse());
    });

    it(@"Should return nil if not set", ^{
        SDLGetSystemCapability *testRequest = [[SDLGetSystemCapability alloc] init];

        expect(testRequest.systemCapabilityType).to(beNil());
        expect(testRequest.subscribe).to(beNil());
    });

    describe(@"initializing", ^{
        it(@"Should initialize correctly with a dictionary", ^{
            NSDictionary *dict = @{SDLRPCParameterNameRequest:@{
                                           SDLRPCParameterNameParameters:@{
                                                   SDLRPCParameterNameSystemCapabilityType:testSystemCapabilityType,
                                                   SDLRPCParameterNameSubscribe:@(testSubcribe)
                                                   },
                                           SDLRPCParameterNameOperationName:SDLRPCFunctionNameGetSystemCapability}};
            SDLGetSystemCapability *testRequest = [[SDLGetSystemCapability alloc] initWithDictionary:dict];

            expect(testRequest.systemCapabilityType).to(equal(testSystemCapabilityType));
            expect(testRequest.subscribe).to(beFalse());
        });


        it(@"Should initialize correctly with initWithType:", ^{
            SDLGetSystemCapability *testRequest = [[SDLGetSystemCapability alloc] initWithType:testSystemCapabilityType];

            expect(testRequest.systemCapabilityType).to(equal(testSystemCapabilityType));
            expect(testRequest.subscribe).to(beNil());
        });

        it(@"Should initialize correctly with initWithType:subscribe:", ^{
            SDLGetSystemCapability *testRequest = [[SDLGetSystemCapability alloc] initWithType:testSystemCapabilityType subscribe:testSubcribe];

            expect(testRequest.systemCapabilityType).to(equal(testSystemCapabilityType));
            expect(testRequest.subscribe).to(beFalse());
        });
    });
});

QuickSpecEnd

