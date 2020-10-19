//
//  SDLSetCloudAppPropertiesSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/26/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCloudAppProperties.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSetCloudAppProperties.h"

QuickSpecBegin(SDLSetCloudAppPropertiesSpec)

describe(@"Getter/Setter Tests", ^{
    __block SDLCloudAppProperties *testProperties = nil;

    beforeEach(^{
        testProperties = [[SDLCloudAppProperties alloc] initWithAppID:@"testAppID"];
    });

    it(@"Should set and get correctly", ^{
        SDLSetCloudAppProperties *testRequest = [[SDLSetCloudAppProperties alloc] init];
        testRequest.properties = testProperties;

        expect(testRequest.properties).to(equal(testProperties));
    });

    it(@"Should initialize correctly with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameRequest:@{
                                       SDLRPCParameterNameParameters:@{
                                               SDLRPCParameterNameProperties:testProperties
                                               },
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNameSetCloudAppProperties}};
        SDLSetCloudAppProperties *testRequest = [[SDLSetCloudAppProperties alloc] initWithDictionary:dict];

        expect(testRequest.properties).to(equal(testProperties));
    });

    it(@"Should initialize correctly with the convenience init", ^{
        SDLSetCloudAppProperties *testRequest = [[SDLSetCloudAppProperties alloc] initWithProperties:testProperties];

        expect(testRequest.properties).to(equal(testProperties));
    });

    it(@"Should return nil if not set", ^{
        SDLSetCloudAppProperties *testRequest = [[SDLSetCloudAppProperties alloc] init];

        expect(testRequest.properties).to(beNil());
    });
});

QuickSpecEnd

