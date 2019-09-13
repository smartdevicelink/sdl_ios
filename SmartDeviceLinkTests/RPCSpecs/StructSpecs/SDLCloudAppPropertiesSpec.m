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
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLCloudAppPropertiesSpec)

describe(@"Getter/Setter Tests", ^{
    __block NSArray<NSString *> *testNicknames = nil;
    __block NSString *testAppID = nil;
    __block BOOL testEnabled = NO;
    __block NSString *testAuthToken = nil;
    __block NSString *testCloudTransportType = nil;
    __block SDLHybridAppPreference testHybridAppPreference = nil;
    __block NSString *testEndpoint = nil;

    beforeEach(^{
        testNicknames = @[@"testNickname1", @"testNickname2", @"testNickname3"];
        testAppID = @"testAppID";
        testEnabled = NO;
        testAuthToken = @"testAuthToken";
        testCloudTransportType = @"testCloudTransportType";
        testHybridAppPreference = SDLHybridAppPreferenceCloud;
        testEndpoint = @"testEndpoint";
    });

    it(@"Should set and get correctly", ^{
        SDLCloudAppProperties *testStruct = [[SDLCloudAppProperties alloc] init];
        testStruct.nicknames = testNicknames;
        testStruct.appID = testAppID;
        testStruct.enabled = @(testEnabled);
        testStruct.authToken = testAuthToken;
        testStruct.cloudTransportType = testCloudTransportType;
        testStruct.hybridAppPreference = testHybridAppPreference;
        testStruct.endpoint = testEndpoint;

        expect(testStruct.nicknames).to(equal(testNicknames));
        expect(testStruct.appID).to(equal(testAppID));
        expect(testStruct.enabled).to(equal(testEnabled));
        expect(testStruct.authToken).to(equal(testAuthToken));
        expect(testStruct.cloudTransportType).to(equal(testCloudTransportType));
        expect(testStruct.hybridAppPreference).to(equal(testHybridAppPreference));
        expect(testStruct.endpoint).to(equal(testEndpoint));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameNicknames:testNicknames,
                               SDLRPCParameterNameAppId:testAppID,
                               SDLRPCParameterNameEnabled:@(testEnabled),
                               SDLRPCParameterNameAuthToken:testAuthToken,
                               SDLRPCParameterNameCloudTransportType:testCloudTransportType,
                               SDLRPCParameterNameHybridAppPreference:testHybridAppPreference,
                               SDLRPCParameterNameEndpoint:testEndpoint
                               };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLCloudAppProperties *testStruct = [[SDLCloudAppProperties alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.nicknames).to(equal(testNicknames));
        expect(testStruct.appID).to(equal(testAppID));
        expect(testStruct.enabled).to(equal(testEnabled));
        expect(testStruct.authToken).to(equal(testAuthToken));
        expect(testStruct.cloudTransportType).to(equal(testCloudTransportType));
        expect(testStruct.hybridAppPreference).to(equal(testHybridAppPreference));
        expect(testStruct.endpoint).to(equal(testEndpoint));
    });

    it(@"Should get correctly when initialized with initWithAppID:", ^{
        SDLCloudAppProperties *testStruct = [[SDLCloudAppProperties alloc] initWithAppID:testAppID];

        expect(testStruct.appID).to(equal(testAppID));
        expect(testStruct.nicknames).to(beNil());
        expect(testStruct.enabled).to(beNil());
        expect(testStruct.authToken).to(beNil());
        expect(testStruct.cloudTransportType).to(beNil());
        expect(testStruct.hybridAppPreference).to(beNil());
        expect(testStruct.endpoint).to(beNil());
    });

    it(@"Should get correctly when initialized with initWithAppName:appID:enabled:authToken:cloudTransportType: hybridAppPreference:endpoint:", ^{
        SDLCloudAppProperties *testStruct = [[SDLCloudAppProperties alloc] initWithAppID:testAppID nicknames:testNicknames enabled:testEnabled authToken:testAuthToken cloudTransportType:testCloudTransportType hybridAppPreference:testHybridAppPreference endpoint:testEndpoint];

        expect(testStruct.nicknames).to(equal(testNicknames));
        expect(testStruct.appID).to(equal(testAppID));
        expect(testStruct.enabled).to(equal(testEnabled));
        expect(testStruct.authToken).to(equal(testAuthToken));
        expect(testStruct.cloudTransportType).to(equal(testCloudTransportType));
        expect(testStruct.hybridAppPreference).to(equal(testHybridAppPreference));
        expect(testStruct.endpoint).to(equal(testEndpoint));
    });

    it(@"Should return nil if not set", ^{
        SDLCloudAppProperties *testStruct = [[SDLCloudAppProperties alloc] init];

        expect(testStruct.nicknames).to(beNil());
        expect(testStruct.appID).to(beNil());
        expect(testStruct.enabled).to(beNil());
        expect(testStruct.authToken).to(beNil());
        expect(testStruct.cloudTransportType).to(beNil());
        expect(testStruct.hybridAppPreference).to(beNil());
        expect(testStruct.endpoint).to(beNil());
    });
});

QuickSpecEnd
