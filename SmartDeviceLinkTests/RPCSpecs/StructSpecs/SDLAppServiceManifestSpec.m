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
#import "SDLAppServiceType.h"
#import "SDLFunctionID.h"
#import "SDLImage.h"
#import "SDLMediaServiceManifest.h"
#import "SDLNames.h"
#import "SDLSyncMsgVersion.h"
#import "SDLWeatherServiceManifest.h"

QuickSpecBegin(SDLAppServiceManifestSpec)

describe(@"Getter/Setter Tests", ^ {
    __block NSString *testServiceName = nil;
    __block NSString *testServiceType = nil;
    __block SDLImage *testServiceIcon = nil;
    __block NSNumber<SDLBool> *testAllowAppConsumers = nil;
    __block NSString *testURIPrefix = nil;
    __block NSString *testURIScheme = nil;
    __block SDLSyncMsgVersion *testRPCSpecVersion = nil;
    __block NSArray<SDLFunctionID *> *testHandledRPCs = nil;
    __block SDLWeatherServiceManifest *testWeatherServiceManifest = nil;
    __block SDLMediaServiceManifest *testMediaServiceManifest = nil;

    beforeEach(^{
        testServiceName = @"testService";
        testServiceType = SDLAppServiceTypeMedia;
        testServiceIcon = [[SDLImage alloc] initWithName:@"testImage" isTemplate:false];
        testAllowAppConsumers = @YES;
        testURIPrefix = @"testURIPrefix";
        testURIScheme = @"testURIScheme";
        testRPCSpecVersion = [[SDLSyncMsgVersion alloc] initWithMajorVersion:5 minorVersion:2 patchVersion:1];
        testHandledRPCs = @[];
        testWeatherServiceManifest = [[SDLWeatherServiceManifest alloc] initWithCurrentForecastSupported:true maxMultidayForecastAmount:3 maxHourlyForecastAmount:0 maxMinutelyForecastAmount:0 weatherForLocationSupported:false];
        testMediaServiceManifest = [[SDLMediaServiceManifest alloc] init];
    });

    it(@"Should set and get correctly", ^{
        SDLAppServiceManifest *testStruct = [[SDLAppServiceManifest alloc] init];
        testStruct.serviceName = testServiceName;
        testStruct.serviceType = testServiceType;
        testStruct.serviceIcon = testServiceIcon;
        testStruct.allowAppConsumers = testAllowAppConsumers;
        testStruct.uriPrefix = testURIPrefix;
        testStruct.uriScheme = testURIScheme;
        testStruct.rpcSpecVersion = testRPCSpecVersion;
        testStruct.handledRPCs = testHandledRPCs;
        testStruct.weatherServiceManifest = testWeatherServiceManifest;
        testStruct.mediaServiceManifest = testMediaServiceManifest;

        expect(testStruct.serviceName).to(match(testServiceName));
        expect(testStruct.serviceType).to(match(testServiceType));
        expect(testStruct.serviceIcon).to(equal(testServiceIcon));
        expect(testStruct.allowAppConsumers).to(beTrue());
        expect(testStruct.uriPrefix).to(match(testURIPrefix));
        expect(testStruct.uriScheme).to(match(testURIScheme));
        expect(testStruct.rpcSpecVersion).to(equal(testRPCSpecVersion));
        expect(testStruct.handledRPCs).to(equal(testHandledRPCs));
        expect(testStruct.weatherServiceManifest).to(equal(testWeatherServiceManifest));
        expect(testStruct.mediaServiceManifest).to(equal(testMediaServiceManifest));
    });

    it(@"Should init correctly", ^{
        SDLAppServiceManifest *testStruct = [[SDLAppServiceManifest alloc] initWithServiceName:testServiceName serviceType:testServiceType serviceIcon:testServiceIcon allowAppConsumers:false uriPrefix:testURIPrefix uriScheme:testURIScheme rpcSpecVersion:testRPCSpecVersion handledRPCs:testHandledRPCs mediaServiceManifest:testMediaServiceManifest weatherServiceManifest:testWeatherServiceManifest];

        expect(testStruct.serviceName).to(match(testServiceName));
        expect(testStruct.serviceType).to(match(testServiceType));
        expect(testStruct.serviceIcon).to(equal(testServiceIcon));
        expect(testStruct.allowAppConsumers).to(beFalse());
        expect(testStruct.uriPrefix).to(match(testURIPrefix));
        expect(testStruct.uriScheme).to(match(testURIScheme));
        expect(testStruct.rpcSpecVersion).to(equal(testRPCSpecVersion));
        expect(testStruct.handledRPCs).to(equal(testHandledRPCs));
        expect(testStruct.weatherServiceManifest).to(equal(testWeatherServiceManifest));
        expect(testStruct.mediaServiceManifest).to(equal(testMediaServiceManifest));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLNameServiceName:testServiceName,
                               SDLNameServiceType:testServiceType,
                               SDLNameServiceIcon:testServiceIcon,
                               SDLNameAllowAppConsumers:testAllowAppConsumers,
                               SDLNameURIPrefix:testURIPrefix,
                               SDLNameURIScheme:testURIScheme,
                               SDLNameRPCSpecVersion:testRPCSpecVersion,
                               SDLNameHandledRPCs:testHandledRPCs,
                               SDLNameWeatherServiceManifest:testWeatherServiceManifest,
                               SDLNameMediaServiceManifest:testMediaServiceManifest
                               };
        SDLAppServiceManifest *testStruct = [[SDLAppServiceManifest alloc] initWithDictionary:dict];

        expect(testStruct.serviceName).to(match(testServiceName));
        expect(testStruct.serviceType).to(equal(testServiceType));
        expect(testStruct.serviceIcon).to(equal(testServiceIcon));
        expect(testStruct.allowAppConsumers).to(beTrue());
        expect(testStruct.uriPrefix).to(match(testURIPrefix));
        expect(testStruct.uriScheme).to(match(testURIScheme));
        expect(testStruct.rpcSpecVersion).to(equal(testRPCSpecVersion));
        expect(testStruct.handledRPCs).to(equal(testHandledRPCs));
        expect(testStruct.weatherServiceManifest).to(equal(testWeatherServiceManifest));
        expect(testStruct.mediaServiceManifest).to(equal(testMediaServiceManifest));
    });

    it(@"Should return nil if not set", ^{
        SDLAppServiceManifest *testStruct = [[SDLAppServiceManifest alloc] init];

        expect(testStruct.serviceName).to(beNil());
        expect(testStruct.serviceType).to(beNil());
        expect(testStruct.serviceIcon).to(beNil());
        expect(testStruct.allowAppConsumers).to(beNil());
        expect(testStruct.uriPrefix).to(beNil());
        expect(testStruct.uriScheme).to(beNil());
        expect(testStruct.rpcSpecVersion).to(beNil());
        expect(testStruct.handledRPCs).to(beNil());
        expect(testStruct.weatherServiceManifest).to(beNil());
        expect(testStruct.mediaServiceManifest).to(beNil());
    });
});

QuickSpecEnd
