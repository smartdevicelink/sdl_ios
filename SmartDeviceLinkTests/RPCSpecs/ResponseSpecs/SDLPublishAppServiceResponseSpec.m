//
//  SDLPublishAppServiceResponseSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/5/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPublishAppServiceResponse.h"
#import "SDLAppServiceRecord.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLPublishAppServiceResponseSpec)

describe(@"Getter/Setter Tests", ^{
    __block SDLAppServiceRecord *testAppServiceRecord = nil;

    beforeEach(^{
        testAppServiceRecord = [[SDLAppServiceRecord alloc] init];
        testAppServiceRecord.serviceID = @"testServiceId";
    });

    it(@"Should set and get correctly", ^{
        SDLPublishAppServiceResponse *testResponse = [[SDLPublishAppServiceResponse alloc] init];
        testResponse.appServiceRecord = testAppServiceRecord;

        expect(testResponse.appServiceRecord).to(equal(testAppServiceRecord));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameResponse:@{
                                       SDLRPCParameterNameParameters:@{
                                               SDLRPCParameterNameAppServiceRecord:testAppServiceRecord
                                               },
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNamePublishAppService}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLPublishAppServiceResponse *testResponse = [[SDLPublishAppServiceResponse alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testResponse.appServiceRecord).to(equal(testAppServiceRecord));
    });

    it(@"Should get correctly when initialized with initWithAppServiceRecord:", ^{
        SDLPublishAppServiceResponse *testResponse = [[SDLPublishAppServiceResponse alloc] initWithAppServiceRecord:testAppServiceRecord];

        expect(testResponse.appServiceRecord).to(equal(testAppServiceRecord));
    });

    it(@"Should return nil if not set", ^{
        SDLPublishAppServiceResponse *testResponse = [[SDLPublishAppServiceResponse alloc] init];

        expect(testResponse.appServiceRecord).to(beNil());
    });
});

QuickSpecEnd


