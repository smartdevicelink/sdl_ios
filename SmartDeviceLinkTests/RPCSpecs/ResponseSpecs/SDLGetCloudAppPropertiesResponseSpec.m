//
//  SDLGetCloudAppPropertiesResponseSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/26/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCloudAppProperties.h"
#import "SDLGetCloudAppPropertiesResponse.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLGetCloudAppPropertiesResponseSpec)

describe(@"Getter/Setter Tests", ^{
    __block SDLCloudAppProperties *testProperties = nil;

    beforeEach(^{
        testProperties = [[SDLCloudAppProperties alloc] initWithAppID:@"testAppID"];
    });

    it(@"Should set and get correctly", ^{
        SDLGetCloudAppPropertiesResponse *testResponse = [[SDLGetCloudAppPropertiesResponse alloc] init];
        testResponse.properties = testProperties;

        expect(testResponse.properties).to(equal(testProperties));
    });

    it(@"Should initialize correctly with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameResponse:@{
                                       SDLRPCParameterNameParameters:@{
                                               SDLRPCParameterNameProperties:testProperties
                                               },
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNameSetCloudAppProperties}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGetCloudAppPropertiesResponse *testResponse = [[SDLGetCloudAppPropertiesResponse alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testResponse.properties).to(equal(testProperties));
        expect(testResponse.name).to(equal(SDLRPCFunctionNameSetCloudAppProperties));
    });

    it(@"Should initialize correctly with the convenience init", ^{
        SDLGetCloudAppPropertiesResponse *testResponse = [[SDLGetCloudAppPropertiesResponse alloc] initWithProperties:testProperties];

        expect(testResponse.properties).to(equal(testProperties));
    });

    it(@"Should return nil if not set", ^{
        SDLGetCloudAppPropertiesResponse *testResponse = [[SDLGetCloudAppPropertiesResponse alloc] init];

        expect(testResponse.properties).to(beNil());
    });
});

QuickSpecEnd

