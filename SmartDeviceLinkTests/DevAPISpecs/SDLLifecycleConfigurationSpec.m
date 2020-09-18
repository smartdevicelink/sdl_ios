//
//  SDLLifecycleConfigurationSpec.m
//  SmartDeviceLinkTests
//
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppHMIType.h"
#import "SDLLanguage.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLifecycleConfigurationUpdate.h"
#import "SDLSpeechCapabilities.h"
#import "SDLTTSChunk.h"
#import "SDLVersion.h"


@interface SDLLifecycleConfiguration()

+ (NSString *)sdl_shortAppIdFromFullAppId:(NSString *)fullAppId;

@end


QuickSpecBegin(SDLLifecycleConfigurationSpec)

describe(@"A lifecycle configuration", ^{
    __block SDLLifecycleConfiguration *testConfig = nil;
    __block NSString *testAppName = @"An App Name";
    __block NSString *testFullAppId = @"123e4567-e89b-12d3-a456-426614174000";
    __block NSString *expectedGeneratedAppId = @"123e4567e8";
    __block SDLVersion *baseVersion = nil;

    beforeEach(^{
        testConfig = nil;
        baseVersion = [SDLVersion versionWithMajor:1 minor:0 patch:0];
    });

    context(@"created with a default configuration", ^{
        context(@"should be successfully initialized", ^{
            it(@"defaultConfigurationWithAppName:fullAppId:", ^{
                testConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:testAppName fullAppId:testFullAppId];

                expect(testConfig.appId).to(match(expectedGeneratedAppId));
                expect(testConfig.fullAppId).to(match(testFullAppId));
            });

            afterEach(^{
                expect(testConfig.appName).to(match(testAppName));
                expect(testConfig.tcpDebugMode).to(beFalse());
                expect(testConfig.tcpDebugIPAddress).to(match(@"192.168.0.1"));
                expect(@(testConfig.tcpDebugPort)).to(equal(@12345));
                expect(testConfig.appType).to(match(SDLAppHMITypeDefault));
                expect(testConfig.additionalAppTypes).to(beNil());
                expect(testConfig.isMedia).to(beFalse());
                expect(testConfig.language).to(match(SDLLanguageEnUs));
                expect(testConfig.languagesSupported.firstObject).to(match(SDLLanguageEnUs));
                expect(testConfig.shortAppName).to(beNil());
                expect(testConfig.ttsName).to(beNil());
                expect(testConfig.voiceRecognitionCommandNames).to(beNil());
                expect(testConfig.resumeHash).to(beNil());
                expect(testConfig.minimumProtocolVersion).to(equal(baseVersion));
                expect(testConfig.minimumRPCVersion).to(equal(baseVersion));
            });
        });

        context(@"If customized", ^{
            __block NSString *testShortAppName = nil;
            __block SDLTTSChunk *testTTSChunk = nil;
            __block NSArray<SDLTTSChunk *> *testTTSName = nil;
            __block NSArray<NSString *> *testSynonyms = nil;
            __block NSString *testResumeHashString = nil;
            __block NSString *testAppId = nil;

            beforeEach(^{
                testShortAppName = @"Short Name";
                testTTSChunk = [[SDLTTSChunk alloc] initWithText:@"test tts name" type:SDLSpeechCapabilitiesText];
                testTTSName = @[testTTSChunk];
                testSynonyms = @[@"Test 1", @"Test 2", @"Test 3", @"Test 4"];
                testResumeHashString = @"testing";
                testAppId = @"pppppppppppppppppppppppppppppppppppppppppp";

                testConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:testAppName fullAppId:testFullAppId];
            });

            it(@"it should get and set correctly", ^{
                testConfig.appType = SDLAppHMITypeMedia;
                testConfig.additionalAppTypes = @[SDLAppHMITypeProjection];
                testConfig.language = SDLLanguageArSa;
                testConfig.languagesSupported = @[SDLLanguageArSa, SDLLanguageEnAu, SDLLanguageEnUs];
                testConfig.shortAppName = testShortAppName;
                testConfig.ttsName = testTTSName;
                testConfig.voiceRecognitionCommandNames = testSynonyms;
                testConfig.resumeHash = testResumeHashString;
                testConfig.minimumProtocolVersion = [SDLVersion versionWithString:@"1.0.0"];
                testConfig.minimumRPCVersion = [SDLVersion versionWithString:@"2.0.0"];
                testConfig.appId = testAppId;
            });

            afterEach(^{
                expect(testConfig.appName).to(match(testAppName));
                expect(testConfig.shortAppName).to(match(testShortAppName));
                expect(testConfig.fullAppId).to(match(testFullAppId));
                expect(testConfig.appId).to(match(testAppId));
                expect(testConfig.tcpDebugMode).to(beFalse());
                expect(testConfig.tcpDebugIPAddress).to(match(@"192.168.0.1"));
                expect(@(testConfig.tcpDebugPort)).to(equal(@12345));
                expect(testConfig.appType).to(match(SDLAppHMITypeMedia));
                expect(testConfig.additionalAppTypes.firstObject).to(match(SDLAppHMITypeProjection));
                expect(testConfig.isMedia).to(beTrue());
                expect(testConfig.language).to(match(SDLLanguageArSa));
                expect(testConfig.languagesSupported).to(haveCount(@3));
                expect(testConfig.ttsName).to(contain(testTTSChunk));
                expect(testConfig.ttsName).to(haveCount(@1));
                expect(testConfig.voiceRecognitionCommandNames).to(haveCount(@(testSynonyms.count)));
                expect(testConfig.resumeHash).to(match(testResumeHashString));
                expect(testConfig.minimumProtocolVersion.stringVersion).to(equal(@"1.0.0"));
                expect(testConfig.minimumRPCVersion.stringVersion).to(equal(@"2.0.0"));
            });
        });
    });
    
    context(@"created with a debug configuration", ^{
        __block NSString *testIPAddress = nil;
        __block UInt16 testPort = 0;
        
        beforeEach(^{
            testIPAddress = @"1.1.1.1";
            testPort = 42;
        });

        context(@"should be successfully initialized", ^{
            it(@"debugConfigurationWithAppName:fullAppId:ipAddress:port:", ^{
                testConfig = [SDLLifecycleConfiguration debugConfigurationWithAppName:testAppName fullAppId:testFullAppId ipAddress:testIPAddress port:testPort];

                expect(testConfig.appId).to(match(expectedGeneratedAppId));
                expect(testConfig.fullAppId).to(match(testFullAppId));
            });

            afterEach(^{
                expect(testConfig.appName).to(match(testAppName));
                expect(testConfig.tcpDebugMode).to(beTrue());
                expect(testConfig.tcpDebugIPAddress).to(match(testIPAddress));
                expect(@(testConfig.tcpDebugPort)).to(equal(@(testPort)));
                expect(testConfig.appType).to(match(SDLAppHMITypeDefault));
                expect(testConfig.additionalAppTypes).to(beNil());
                expect(testConfig.language).to(match(SDLLanguageEnUs));
                expect(testConfig.languagesSupported.firstObject).to(match(SDLLanguageEnUs));
                expect(testConfig.shortAppName).to(beNil());
                expect(testConfig.ttsName).to(beNil());
                expect(testConfig.voiceRecognitionCommandNames).to(beNil());
                expect(testConfig.resumeHash).to(beNil());
                expect(testConfig.minimumProtocolVersion).to(equal(baseVersion));
                expect(testConfig.minimumRPCVersion).to(equal(baseVersion));
            });
        });

        context(@"If customized", ^{
            __block NSString *testShortAppName = nil;
            __block SDLTTSChunk *testTTSChunk = nil;
            __block NSArray<SDLTTSChunk *> *testTTSName = nil;
            __block NSArray<NSString *> *testSynonyms = nil;
            __block NSString *testResumeHashString = nil;
            __block SDLVersion *testVersion = nil;
            __block NSString *testAppId = nil;

            beforeEach(^{
                testConfig = [SDLLifecycleConfiguration debugConfigurationWithAppName:testAppName fullAppId:testFullAppId ipAddress:testIPAddress port:testPort];
            });

            it(@"it should get and set correctly", ^{
                testShortAppName = @"Test Short Name";
                testTTSChunk = [[SDLTTSChunk alloc] initWithText:@"test tts name" type:SDLSpeechCapabilitiesText];
                testTTSName = @[testTTSChunk];
                testSynonyms = @[@"Test 1", @"Test 2", @"Test 3", @"Test 4"];
                testResumeHashString = @"testing";
                testVersion = [SDLVersion versionWithMajor:1 minor:0 patch:0];
                testAppId = @"p&4rrqwervw-jolmk";

                testConfig.appType = SDLAppHMITypeInformation;
                testConfig.additionalAppTypes = @[SDLAppHMITypeProjection];
                testConfig.language = SDLLanguageArSa;
                testConfig.languagesSupported = @[SDLLanguageArSa, SDLLanguageEnAu, SDLLanguageEnUs];
                testConfig.shortAppName = testShortAppName;
                testConfig.ttsName = testTTSName;
                testConfig.voiceRecognitionCommandNames = testSynonyms;
                testConfig.resumeHash = testResumeHashString;
                testConfig.minimumRPCVersion = testVersion;
                testConfig.minimumProtocolVersion = testVersion;
                testConfig.appId = testAppId;
            });

            afterEach(^{
                expect(testConfig.appName).to(match(testAppName));
                expect(testConfig.shortAppName).to(match(testShortAppName));
                expect(testConfig.fullAppId).to(match(testFullAppId));
                expect(testConfig.appId).to(match(testAppId));
                expect(testConfig.tcpDebugMode).to(beTrue());
                expect(testConfig.tcpDebugIPAddress).to(match(@"1.1.1.1"));
                expect(@(testConfig.tcpDebugPort)).to(equal(@42));
                expect(testConfig.appType).to(match(SDLAppHMITypeInformation));
                expect(testConfig.additionalAppTypes.firstObject).to(match(SDLAppHMITypeProjection));
                expect(testConfig.isMedia).to(beFalse());
                expect(testConfig.language).to(match(SDLLanguageArSa));
                expect(testConfig.languagesSupported).to(haveCount(@3));
                expect(testConfig.ttsName).to(contain(testTTSChunk));
                expect(testConfig.ttsName).to(haveCount(@1));
                expect(testConfig.voiceRecognitionCommandNames).to(haveCount(@(testSynonyms.count)));
                expect(testConfig.resumeHash).to(match(testResumeHashString));
                expect(testConfig.minimumRPCVersion).to(equal(testVersion));
                expect(testConfig.minimumProtocolVersion).to(equal(testVersion));
            });
        });
    });
});

describe(@"When generating the `appId` from the `fullAppId`", ^{
    it(@"should return an empty string if the full app id is empty", ^{
        NSString *testFullAppId = @"";
        NSString *appId = [SDLLifecycleConfiguration sdl_shortAppIdFromFullAppId:testFullAppId];
        expect(appId).to(beEmpty());
    });

    it(@"should return an empty string if the full app id only has dashes", ^{
        NSString *testFullAppId = @"--";
        NSString *appId = [SDLLifecycleConfiguration sdl_shortAppIdFromFullAppId:testFullAppId];
        expect(appId).to(beEmpty());
    });

    it(@"should return a string truncated to the first non-dash 10 characters", ^{
        NSString *testFullAppId = @"34-uipe--k-rtqwedeftg-1";
        NSString *appId = [SDLLifecycleConfiguration sdl_shortAppIdFromFullAppId:testFullAppId];
        expect(appId).to(match(@"34uipekrtq"));
    });

    it(@"should return the full app id if the full app id is less than 10 characters", ^{
        NSString *testFullAppId = @"ab";
        NSString *appId = [SDLLifecycleConfiguration sdl_shortAppIdFromFullAppId:testFullAppId];
        expect(appId).to(equal(testFullAppId));
    });
});

QuickSpecEnd
