//
//  SDLSubtleAlertResponseSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 7/28/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCFunctionNames.h"
#import "SDLRPCParameterNames.h"
#import "SDLSubtleAlertResponse.h"

QuickSpecBegin(SDLSubtleAlertResponseSpec)

describe(@"Getter/Setter Tests", ^{
    __block SDLSubtleAlertResponse *testSubtleAlertResponse = nil;
    __block int testTryAgainTime = 6;

    it(@"Should set and get correctly", ^{
        testSubtleAlertResponse = [[SDLSubtleAlertResponse alloc] init];
        testSubtleAlertResponse.tryAgainTime = @(testTryAgainTime);

        expect(testSubtleAlertResponse.tryAgainTime).to(equal(testTryAgainTime));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameResponse:@{
                                       SDLRPCParameterNameParameters:@{
                                               SDLRPCParameterNameTryAgainTime:@(testTryAgainTime)
                                       },
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNameSubtleAlert}};
        testSubtleAlertResponse = [[SDLSubtleAlertResponse alloc] initWithDictionary:dict];

        expect(testSubtleAlertResponse.tryAgainTime).to(equal(testTryAgainTime));
    });

    it(@"Should get correctly when initialized with initWithTryAgainTime:", ^{
        testSubtleAlertResponse = [[SDLSubtleAlertResponse alloc] initWithTryAgainTime:@(testTryAgainTime)];

        expect(testSubtleAlertResponse.tryAgainTime).to(equal(testTryAgainTime));
    });

    it(@"Should return nil if not set", ^{
        testSubtleAlertResponse = [[SDLSubtleAlertResponse alloc] init];

        expect(testSubtleAlertResponse.tryAgainTime).to(beNil());
    });
});

QuickSpecEnd

