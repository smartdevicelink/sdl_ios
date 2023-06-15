//
//  SDLPublishAppServiceResponseSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/5/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;

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
        SDLPublishAppServiceResponse *testResponse = [[SDLPublishAppServiceResponse alloc] initWithDictionary:dict];

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


