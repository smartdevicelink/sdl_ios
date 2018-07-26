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

QuickSpecBegin(SDLLifecycleConfigurationSpec)

describe(@"A lifecycle configuration", ^{
    __block SDLLifecycleConfiguration *testConfig = nil;
    __block NSString *testAppName = nil;
    __block NSString *testAppId = nil;
    __block NSString *testFullAppId = nil;

    beforeEach(^{
        testConfig = nil;
        testAppName = @"An App Name";
        testAppId = @"00542596";
        testFullAppId = @"ab987adfa651kj-212346h3kjkaju";
    });

    context(@"created with a default configuration", ^{
        context(@"should be successfully initialized", ^{
            it(@"defaultConfigurationWithAppName:appId:", ^{
                testConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:testAppName appId:testAppId];

                expect(testConfig.appId).to(match(testAppId));
                expect(testConfig.fullAppId).to(beEmpty());
            });

            it(@"defaultConfigurationWithAppName:fullAppId:", ^{
                testConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:testAppName fullAppId:testFullAppId];

                expect(testConfig.appId).to(beEmpty());
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
            });
        });

        context(@"If customized", ^{
            __block NSString *testShortAppName = nil;
            __block SDLTTSChunk *testTTSChunk = nil;
            __block NSArray<SDLTTSChunk *> *testTTSName = nil;
            __block NSArray<NSString *> *testSynonyms = nil;
            __block NSString *testResumeHashString = nil;

            beforeEach(^{
                testConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:testAppName fullAppId:testFullAppId];
            });

            it(@"it should get and set correctly", ^{
                testShortAppName = @"Short Name";
                testTTSChunk = [[SDLTTSChunk alloc] initWithText:@"test tts name" type:SDLSpeechCapabilitiesText];
                testTTSName = @[testTTSChunk];
                testSynonyms = @[@"Test 1", @"Test 2", @"Test 3", @"Test 4"];
                testResumeHashString = @"testing";

                testConfig.appType = SDLAppHMITypeMedia;
                testConfig.additionalAppTypes = @[SDLAppHMITypeProjection];
                testConfig.language = SDLLanguageArSa;
                testConfig.languagesSupported = @[SDLLanguageArSa, SDLLanguageEnAu, SDLLanguageEnUs];
                testConfig.shortAppName = testShortAppName;
                testConfig.ttsName = testTTSName;
                testConfig.voiceRecognitionCommandNames = testSynonyms;
                testConfig.resumeHash = testResumeHashString;
            });

            afterEach(^{
                expect(testConfig.appName).to(match(testAppName));
                expect(testConfig.shortAppName).to(match(testShortAppName));
                expect(testConfig.fullAppId).to(match(testFullAppId));
                expect(testConfig.appId).to(beEmpty());
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
            it(@"debugConfigurationWithAppName:appId:ipAddress:port:", ^{
                testConfig = [SDLLifecycleConfiguration debugConfigurationWithAppName:testAppName appId:testAppId ipAddress:testIPAddress port:testPort];

                expect(testConfig.appId).to(match(testAppId));
                expect(testConfig.fullAppId).to(beEmpty());
            });

            it(@"debugConfigurationWithAppName:fullAppId:ipAddress:port:", ^{
                testConfig = [SDLLifecycleConfiguration debugConfigurationWithAppName:testAppName fullAppId:testFullAppId ipAddress:testIPAddress port:testPort];

                expect(testConfig.appId).to(beEmpty());
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
            });
        });

        context(@"If customized", ^{
            __block NSString *testShortAppName = nil;
            __block SDLTTSChunk *testTTSChunk = nil;
            __block NSArray<SDLTTSChunk *> *testTTSName = nil;
            __block NSArray<NSString *> *testSynonyms = nil;
            __block NSString *testResumeHashString = nil;

            beforeEach(^{
                testConfig = [SDLLifecycleConfiguration debugConfigurationWithAppName:testAppName fullAppId:testFullAppId ipAddress:testIPAddress port:testPort];
            });

            it(@"it should get and set correctly", ^{
                testShortAppName = @"Test Short Name";
                testTTSChunk = [[SDLTTSChunk alloc] initWithText:@"test tts name" type:SDLSpeechCapabilitiesText];
                testTTSName = @[testTTSChunk];
                testSynonyms = @[@"Test 1", @"Test 2", @"Test 3", @"Test 4"];
                testResumeHashString = @"testing";

                testConfig.appType = SDLAppHMITypeInformation;
                testConfig.additionalAppTypes = @[SDLAppHMITypeProjection];
                testConfig.language = SDLLanguageArSa;
                testConfig.languagesSupported = @[SDLLanguageArSa, SDLLanguageEnAu, SDLLanguageEnUs];
                testConfig.shortAppName = testShortAppName;
                testConfig.ttsName = testTTSName;
                testConfig.voiceRecognitionCommandNames = testSynonyms;
                testConfig.resumeHash = testResumeHashString;
            });

            afterEach(^{
                expect(testConfig.appName).to(match(testAppName));
                expect(testConfig.shortAppName).to(match(testShortAppName));
                expect(testConfig.fullAppId).to(match(testFullAppId));
                expect(testConfig.appId).to(beEmpty());
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
            });
        });
    });
});

QuickSpecEnd
