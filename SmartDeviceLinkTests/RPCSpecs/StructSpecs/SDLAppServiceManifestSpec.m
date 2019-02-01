//
//  SDLAppServiceManifestSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 1/30/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppServiceManifest.h"
#import "SDLNames.h"

QuickSpecBegin(SDLAppServiceManifestSpec)

describe(@"Getter/Setter Tests", ^ {
    __block NSString *testServiceName = nil;
    __block SDLAppServiceType testServiceType = nil;
    __block NSString *testServiceIcon = nil;
    __block NSNumber<SDLBool> *testAllowAppConsumers = nil;
    __block NSString *testURIPrefix = nil;
    __block SDLSyncMsgVersion *testRPCSpecVersion = nil;
    __block NSArray<SDLFunctionID *> *testHandledRPCs = nil;

    beforeEach(^{
        testServiceName = @"testService";
        testServiceType = SDLAppServiceTypeMedia;
        testServiceIcon = @"testIcon";
        testAllowAppConsumers = @YES;
        testURIPrefix = @"testURIPrefix";
        testRPCSpecVersion = [[SDLSyncMsgVersion alloc] initWithMajorVersion:5 minorVersion:2 patchVersion:1];
        testHandledRPCs = @[SDLFunctionID.sharedInstance];
    });

    it(@"Should set and get correctly", ^{
        SDLAppServiceManifest *testStruct = [[SDLAppServiceManifest alloc] init];
        testStruct.serviceName = testServiceName;
        testStruct.serviceType = testServiceType;
        testStruct.serviceIcon = testServiceIcon;
        testStruct.allowAppConsumers = testAllowAppConsumers;
        testStruct.uriPrefix = testURIPrefix;
        testStruct.rpcSpecVersion = testRPCSpecVersion;
        testStruct.handledRPCs = testHandledRPCs;

        expect(testStruct.serviceName).to(match(testServiceName));
        expect(testStruct.serviceType).to(equal(testServiceType));
        expect(testStruct.serviceIcon).to(match(testServiceIcon));
        expect(testStruct.allowAppConsumers).to(beTrue());
        expect(testStruct.uriPrefix).to(match(testURIPrefix));
        expect(testStruct.rpcSpecVersion).to(equal(testRPCSpecVersion));
        expect(testStruct.handledRPCs).to(equal(testHandledRPCs));
    });

    it(@"Should init correctly", ^{
        SDLAppServiceManifest *testStruct = [[SDLAppServiceManifest alloc] initWithServiceName:testServiceName serviceType:testServiceType serviceIcon:testServiceIcon allowAppConsumers:false uriPrefix:testURIPrefix rpcSpecVersion:testRPCSpecVersion handledRPCs:testHandledRPCs];

        expect(testStruct.serviceName).to(match(testServiceName));
        expect(testStruct.serviceType).to(equal(testServiceType));
        expect(testStruct.serviceIcon).to(match(testServiceIcon));
        expect(testStruct.allowAppConsumers).to(beFalse());
        expect(testStruct.uriPrefix).to(match(testURIPrefix));
        expect(testStruct.rpcSpecVersion).to(equal(testRPCSpecVersion));
        expect(testStruct.handledRPCs).to(equal(testHandledRPCs));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLNameServiceName:testServiceName,
                               SDLNameServiceType:testServiceType,
                               SDLNameServiceIcon:testServiceIcon,
                               SDLNameAllowAppConsumers:testAllowAppConsumers,
                               SDLNameURIPrefix:testURIPrefix,
                               SDLNameRPCSpecVersion:testRPCSpecVersion,
                               SDLNameHandledRPCs:testHandledRPCs
                               };
        SDLAppServiceManifest *testStruct = [[SDLAppServiceManifest alloc] initWithDictionary:dict];

        expect(testStruct.serviceName).to(match(testServiceName));
        expect(testStruct.serviceType).to(equal(testServiceType));
        expect(testStruct.serviceIcon).to(match(testServiceIcon));
        expect(testStruct.allowAppConsumers).to(beTrue());
        expect(testStruct.uriPrefix).to(match(testURIPrefix));
        expect(testStruct.rpcSpecVersion).to(equal(testRPCSpecVersion));
        expect(testStruct.handledRPCs).to(equal(testHandledRPCs));
    });

    it(@"Should return nil if not set", ^{
        SDLAppServiceManifest *testStruct = [[SDLAppServiceManifest alloc] init];

        expect(testStruct.serviceName).to(beNil());
        expect(testStruct.serviceType).to(beNil());
        expect(testStruct.serviceIcon).to(beNil());
        expect(testStruct.allowAppConsumers).to(beNil());
        expect(testStruct.uriPrefix).to(beNil());
        expect(testStruct.rpcSpecVersion).to(beNil());
        expect(testStruct.handledRPCs).to(beNil());
    });
});

QuickSpecEnd
