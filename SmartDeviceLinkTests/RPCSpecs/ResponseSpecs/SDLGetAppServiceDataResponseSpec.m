//
//  SDLGetAppServiceDataResponseSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppServiceData.h"
#import "SDLAppServiceType.h"
#import "SDLGetAppServiceDataResponse.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLGetAppServiceDataResponseSpec)

describe(@"Getter/Setter Tests", ^{
    __block SDLAppServiceData *testAppServiceData = nil;

    beforeEach(^{
        testAppServiceData = [[SDLAppServiceData alloc] init];
        testAppServiceData.serviceType = SDLAppServiceTypeMedia;
    });

    it(@"Should set and get correctly", ^{
        SDLGetAppServiceDataResponse *testResponse = [[SDLGetAppServiceDataResponse alloc] init];
        testResponse.serviceData = testAppServiceData;

        expect(testResponse.serviceData).to(equal(testAppServiceData));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameResponse:@{
                                       SDLRPCParameterNameParameters:@{
                                               SDLRPCParameterNameServiceData:testAppServiceData
                                               },
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNameGetAppServiceData}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGetAppServiceDataResponse *testResponse = [[SDLGetAppServiceDataResponse alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testResponse.serviceData).to(equal(testAppServiceData));
    });

    it(@"Should get correctly when initialized with initWithAppServiceData:", ^{
        SDLGetAppServiceDataResponse *testResponse = [[SDLGetAppServiceDataResponse alloc] initWithAppServiceData:testAppServiceData];

        expect(testResponse.serviceData).to(equal(testAppServiceData));
    });

    it(@"Should return nil if not set", ^{
        SDLGetAppServiceDataResponse *testResponse = [[SDLGetAppServiceDataResponse alloc] init];

        expect(testResponse.serviceData).to(beNil())
        ;
    });
});

QuickSpecEnd
