//
//  SDLPerformAppServiceInteractionResponseSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPerformAppServiceInteractionResponse.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLPerformAppServiceInteractionResponseSpec)

describe(@"Getter/Setter Tests", ^{
    __block NSString *testServiceSpecificResult = nil;

    beforeEach(^{
        testServiceSpecificResult = @"testServiceSpecificResult";
    });

    it(@"Should set and get correctly", ^{
        SDLPerformAppServiceInteractionResponse *testResponse = [[SDLPerformAppServiceInteractionResponse alloc] init];
        testResponse.serviceSpecificResult = testServiceSpecificResult;

        expect(testResponse.serviceSpecificResult).to(equal(testServiceSpecificResult));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameResponse:@{
                                       SDLRPCParameterNameParameters:@{
                                               SDLRPCParameterNameServiceSpecificResult:testServiceSpecificResult
                                               },
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNamePublishAppService}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLPerformAppServiceInteractionResponse *testResponse = [[SDLPerformAppServiceInteractionResponse alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testResponse.serviceSpecificResult).to(equal(testServiceSpecificResult));
    });

    it(@"Should get correctly when initialized with initWithServiceSpecificResult:", ^{
        SDLPerformAppServiceInteractionResponse *testResponse = [[SDLPerformAppServiceInteractionResponse alloc] initWithServiceSpecificResult:testServiceSpecificResult];

        expect(testResponse.serviceSpecificResult).to(equal(testServiceSpecificResult));
    });

    it(@"Should return nil if not set", ^{
        SDLPerformAppServiceInteractionResponse *testResponse = [[SDLPerformAppServiceInteractionResponse alloc] init];

        expect(testResponse.serviceSpecificResult).to(beNil());
    });
});

QuickSpecEnd
