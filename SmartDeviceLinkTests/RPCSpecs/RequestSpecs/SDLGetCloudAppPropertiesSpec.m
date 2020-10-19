//
//  SDLGetCloudAppPropertiesSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/26/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGetDTCs.h"
#import "SDLGetCloudAppProperties.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"


QuickSpecBegin(SDLGetCloudAppPropertiesSpec)

describe(@"Getter/Setter Tests", ^{
    __block NSString *testAppID = nil;

    beforeEach(^{
        testAppID = @"testAppID";
    });

    it(@"Should set and get correctly", ^{
        SDLGetCloudAppProperties *testRequest = [[SDLGetCloudAppProperties alloc] init];
        testRequest.appID = testAppID;

        expect(testRequest.appID).to(equal(testAppID));
    });

    it(@"Should initialize correctly with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameRequest:@{
                                       SDLRPCParameterNameParameters:@{
                                               SDLRPCParameterNameAppId:testAppID
                                               },
                                       SDLRPCParameterNameOperationName:SDLRPCFunctionNameGetCloudAppProperties}};
        SDLGetCloudAppProperties *testRequest = [[SDLGetCloudAppProperties alloc] initWithDictionary:dict];

        expect(testRequest.appID).to(equal(testAppID));
    });

    it(@"Should initialize correctly with the convenience init", ^{
        SDLGetCloudAppProperties *testRequest = [[SDLGetCloudAppProperties alloc] initWithAppID:testAppID];

        expect(testRequest.appID).to(equal(testAppID));
    });

    it(@"Should return nil if not set", ^{
        SDLGetCloudAppProperties *testRequest = [[SDLGetCloudAppProperties alloc] init];

        expect(testRequest.appID).to(beNil());
    });
});

QuickSpecEnd

