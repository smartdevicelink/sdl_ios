//
//  SDLCloudAppPropertiesSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/26/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCloudAppProperties.h"
#import "SDLHybridAppPreference.h"
#import "SDLNames.h"

QuickSpecBegin(SDLCloudAppPropertiesSpec)

describe(@"Getter/Setter Tests", ^{
    __block NSString *testAppName = nil;
    __block NSString *testAppID = nil;
    __block BOOL testEnabled = nil;
    __block NSString *testAuthToken = nil;
    __block NSString *testCloudTransportType = nil;
    __block SDLHybridAppPreference testHybridAppPreference = nil;
    __block NSString *testEndpoint = nil;

    beforeEach(^{
        testAppName = @"testAppName";
        testAppID = @"testAppID";
        testEnabled = false;
        testAuthToken = @"testAuthToken";
        testCloudTransportType = @"testCloudTransportType";
        testHybridAppPreference = SDLHybridAppPreferenceCloud;
        testEndpoint = @"testEndpoint";
    });

    it(@"Should set and get correctly", ^{
        SDLCloudAppProperties *testStruct = [[SDLCloudAppProperties alloc] init];
        testStruct.appName = testAppName;
        testStruct.appID = testAppID;
        testStruct.enabled = @(testEnabled);
        testStruct.authToken = testAuthToken;
        testStruct.cloudTransportType = testCloudTransportType;
        testStruct.hybridAppPreference = testHybridAppPreference;
        testStruct.endpoint = testEndpoint;

        expect(testStruct.appName).to(equal(testAppName));
        expect(testStruct.appID).to(equal(testAppID));
        expect(testStruct.enabled).to(equal(testEnabled));
        expect(testStruct.authToken).to(equal(testAuthToken));
        expect(testStruct.cloudTransportType).to(equal(testCloudTransportType));
        expect(testStruct.hybridAppPreference).to(equal(testHybridAppPreference));
        expect(testStruct.endpoint).to(equal(testEndpoint));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLNameAppName:testAppName,
                               SDLNameAppId:testAppID,
                               SDLNameEnabled:@(testEnabled),
                               SDLNameAuthToken:testAuthToken,
                               SDLNameCloudTransportType:testCloudTransportType,
                               SDLNameHybridAppPreference:testHybridAppPreference,
                               SDLNameEndpoint:testEndpoint
                               };
        SDLCloudAppProperties *testStruct = [[SDLCloudAppProperties alloc] initWithDictionary:dict];

        expect(testStruct.appName).to(equal(testAppName));
        expect(testStruct.appID).to(equal(testAppID));
        expect(testStruct.enabled).to(equal(testEnabled));
        expect(testStruct.authToken).to(equal(testAuthToken));
        expect(testStruct.cloudTransportType).to(equal(testCloudTransportType));
        expect(testStruct.hybridAppPreference).to(equal(testHybridAppPreference));
        expect(testStruct.endpoint).to(equal(testEndpoint));
    });

    it(@"Should get correctly when initialized with initWithAppName:appID:", ^{
        SDLCloudAppProperties *testStruct = [[SDLCloudAppProperties alloc] initWithAppName:testAppName appID:testAppID];

        expect(testStruct.appName).to(equal(testAppName));
        expect(testStruct.appID).to(equal(testAppID));
        expect(testStruct.enabled).to(beNil());
        expect(testStruct.authToken).to(beNil());
        expect(testStruct.cloudTransportType).to(beNil());
        expect(testStruct.hybridAppPreference).to(beNil());
        expect(testStruct.endpoint).to(beNil());
    });

    it(@"Should get correctly when initialized with initWithAppName:appID:enabled:authToken:cloudTransportType: hybridAppPreference:endpoint:", ^{
        SDLCloudAppProperties *testStruct = [[SDLCloudAppProperties alloc] initWithAppName:testAppName appID:testAppID enabled:testEnabled authToken:testAuthToken cloudTransportType:testCloudTransportType hybridAppPreference:testHybridAppPreference endpoint:testEndpoint];

        expect(testStruct.appName).to(equal(testAppName));
        expect(testStruct.appID).to(equal(testAppID));
        expect(testStruct.enabled).to(equal(testEnabled));
        expect(testStruct.authToken).to(equal(testAuthToken));
        expect(testStruct.cloudTransportType).to(equal(testCloudTransportType));
        expect(testStruct.hybridAppPreference).to(equal(testHybridAppPreference));
        expect(testStruct.endpoint).to(equal(testEndpoint));
    });

    it(@"Should return nil if not set", ^{
        SDLCloudAppProperties *testStruct = [[SDLCloudAppProperties alloc] init];

        expect(testStruct.appName).to(beNil());
        expect(testStruct.appID).to(beNil());
        expect(testStruct.enabled).to(beNil());
        expect(testStruct.authToken).to(beNil());
        expect(testStruct.cloudTransportType).to(beNil());
        expect(testStruct.hybridAppPreference).to(beNil());
        expect(testStruct.endpoint).to(beNil());
    });
});

QuickSpecEnd
