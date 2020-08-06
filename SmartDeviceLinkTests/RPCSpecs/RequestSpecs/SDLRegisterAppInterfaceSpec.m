//
//  SDLRegisterAppInterfaceSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "NSNumber+NumberType.h"
#import "SDLAppHMIType.h"
#import "SDLAppInfo.h"
#import "SDLDeviceInfo.h"
#import "SDLLanguage.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRegisterAppInterface.h"
#import "SDLSyncMsgVersion.h"
#import "SDLMsgVersion.h"
#import "SDLTemplateColorScheme.h"
#import "SDLTTSChunk.h"


QuickSpecBegin(SDLRegisterAppInterfaceSpec)

describe(@"RegisterAppInterface Tests", ^{
    __block SDLRegisterAppInterface *testRegisterAppInterface = nil;
    __block NSString *appName = @"app56";
    __block NSString *appId = @"123456789";
    __block NSString *fullAppId = @"123-e4567-e89b-12d3-a456-426655440000";
    __block NSString *expectedAppId = @"123e4567e8";
    __block NSString *shortAppName = @"whatisanngn";
    __block NSString *resumeHash = @"gercd35grw2";
    __block NSString *vrSynonyms = @"app56";
    __block NSNumber<SDLBool> *isMediaApp = @YES;
    __block NSArray<SDLAppHMIType> *appTypes = @[SDLAppHMITypeMedia, SDLAppHMITypeNavigation, SDLAppHMITypeInformation];
    __block SDLLanguage language = SDLLanguageElGr;
    __block SDLLanguage hmiDisplayLanguage = SDLLanguageArSa;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    __block SDLSyncMsgVersion *version = nil;
#pragma clang diagnostic pop
    __block SDLMsgVersion *msgVersion = nil;
    __block SDLTTSChunk *chunk = nil;
    __block SDLDeviceInfo *info = nil;
    __block SDLAppInfo *appInfo = nil;
    __block SDLTemplateColorScheme *colorScheme = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    __block SDLSyncMsgVersion *currentSyncMsgVersion = [[SDLSyncMsgVersion alloc] initWithMajorVersion:7 minorVersion:0 patchVersion:0];
#pragma clang diagnostic pop
    __block SDLMsgVersion * currentSDLMsgVersion = [[SDLMsgVersion alloc] initWithMajorVersion:7 minorVersion:0 patchVersion:0];

    beforeEach(^{
        testRegisterAppInterface = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        version = [[SDLSyncMsgVersion alloc] initWithMajorVersion:0 minorVersion:0 patchVersion:0];
#pragma clang diagnostic pop
        msgVersion = [[SDLMsgVersion alloc] initWithMajorVersion:0 minorVersion:0 patchVersion:0];
        chunk = [[SDLTTSChunk alloc] init];
        info = [[SDLDeviceInfo alloc] init];
        appInfo = [[SDLAppInfo alloc] init];
        colorScheme = [[SDLTemplateColorScheme alloc] init];
    });

    it(@"Should set and get correctly", ^ {
        testRegisterAppInterface = [[SDLRegisterAppInterface alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testRegisterAppInterface.syncMsgVersion = version;
#pragma clang diagnostic pop
        testRegisterAppInterface.appName = appName;
        testRegisterAppInterface.ttsName = @[chunk];
        testRegisterAppInterface.ngnMediaScreenAppName = shortAppName;
        testRegisterAppInterface.vrSynonyms = @[vrSynonyms];
        testRegisterAppInterface.isMediaApplication = isMediaApp;
        testRegisterAppInterface.languageDesired = language;
        testRegisterAppInterface.hmiDisplayLanguageDesired = hmiDisplayLanguage;
        testRegisterAppInterface.appHMIType = appTypes;
        testRegisterAppInterface.hashID = resumeHash;
        testRegisterAppInterface.deviceInfo = info;
        testRegisterAppInterface.fullAppID = fullAppId;
        testRegisterAppInterface.appID = appId;
        testRegisterAppInterface.appInfo = appInfo;
        testRegisterAppInterface.dayColorScheme = colorScheme;
        testRegisterAppInterface.nightColorScheme = colorScheme;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testRegisterAppInterface.syncMsgVersion).to(equal(version));
#pragma clang diagnostic pop
        testRegisterAppInterface.sdlMsgVersion = msgVersion;
        expect(testRegisterAppInterface.sdlMsgVersion).to(equal(msgVersion));
        expect(testRegisterAppInterface.appName).to(equal(appName));
        expect(testRegisterAppInterface.ttsName).to(contain(chunk));
        expect(testRegisterAppInterface.ngnMediaScreenAppName).to(equal(shortAppName));
        expect(testRegisterAppInterface.vrSynonyms).to(contain(vrSynonyms));
        expect(testRegisterAppInterface.isMediaApplication).to(equal(isMediaApp));
        expect(testRegisterAppInterface.languageDesired).to(equal(language));
        expect(testRegisterAppInterface.hmiDisplayLanguageDesired).to(equal(hmiDisplayLanguage));
        expect(testRegisterAppInterface.appHMIType).to(equal(appTypes));
        expect(testRegisterAppInterface.hashID).to(equal(resumeHash));
        expect(testRegisterAppInterface.deviceInfo).to(equal(info));
        expect(testRegisterAppInterface.fullAppID).to(equal(fullAppId));
        expect(testRegisterAppInterface.appID).to(equal(appId));
        expect(testRegisterAppInterface.appInfo).to(equal(appInfo));
        expect(testRegisterAppInterface.dayColorScheme).to(equal(colorScheme));
        expect(testRegisterAppInterface.nightColorScheme).to(equal(colorScheme));
    });

 describe(@"Setting With Dictionary", ^{
      __block NSDictionary *dict = nil;
     beforeEach( ^{
         dict = @{SDLRPCParameterNameRequest:
                      @{SDLRPCParameterNameParameters:
                            @{SDLRPCParameterNameSyncMessageVersion:@{
                                      SDLRPCParameterNameMajorVersion: @7,
                                      SDLRPCParameterNameMinorVersion: @0,
                                      SDLRPCParameterNamePatchVersion: @0
                                      },
                              SDLRPCParameterNameAppName:appName,
                              SDLRPCParameterNameTTSName:[@[chunk] mutableCopy],
                              SDLRPCParameterNameNGNMediaScreenAppName:shortAppName,
                              SDLRPCParameterNameVRSynonyms:@[vrSynonyms],
                              SDLRPCParameterNameIsMediaApplication:isMediaApp,
                              SDLRPCParameterNameLanguageDesired:SDLLanguageNoNo,
                              SDLRPCParameterNameHMIDisplayLanguageDesired:SDLLanguagePtPt,
                              SDLRPCParameterNameAppHMIType:appTypes,
                              SDLRPCParameterNameHashId:resumeHash,
                              SDLRPCParameterNameDeviceInfo:info,
                              SDLRPCParameterNameFullAppID:fullAppId,
                              SDLRPCParameterNameAppId:appId,
                              SDLRPCParameterNameAppInfo:appInfo,
                              SDLRPCParameterNameDayColorScheme: colorScheme,
                              SDLRPCParameterNameNightColorScheme: colorScheme,
                              },
                        SDLRPCParameterNameOperationName:SDLRPCFunctionNameRegisterAppInterface}};
     });

    it(@"Should get correctly when initialized with a dictionary and get syncMsgVersion first", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLRegisterAppInterface* testRegisterAppInterface = [[SDLRegisterAppInterface alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testRegisterAppInterface.syncMsgVersion).to(equal(currentSyncMsgVersion));
#pragma clang diagnostic pop
        expect(testRegisterAppInterface.sdlMsgVersion).to(equal(currentSDLMsgVersion));
        expect(testRegisterAppInterface.appName).to(match(appName));
        expect(testRegisterAppInterface.ttsName).to(equal([@[chunk] mutableCopy]));
        expect(testRegisterAppInterface.ngnMediaScreenAppName).to(match(shortAppName));
        expect(testRegisterAppInterface.vrSynonyms).to(equal(@[vrSynonyms]));
        expect(testRegisterAppInterface.isMediaApplication).to(equal(isMediaApp));
        expect(testRegisterAppInterface.languageDesired).to(equal(SDLLanguageNoNo));
        expect(testRegisterAppInterface.hmiDisplayLanguageDesired).to(equal(SDLLanguagePtPt));
        expect(testRegisterAppInterface.appHMIType).to(equal(appTypes));
        expect(testRegisterAppInterface.hashID).to(match(resumeHash));
        expect(testRegisterAppInterface.deviceInfo).to(equal(info));
        expect(testRegisterAppInterface.fullAppID).to(match(fullAppId));
        expect(testRegisterAppInterface.appID).to(match(appId));
        expect(testRegisterAppInterface.appInfo).to(equal(appInfo));
        expect(testRegisterAppInterface.dayColorScheme).to(equal(colorScheme));
        expect(testRegisterAppInterface.nightColorScheme).to(equal(colorScheme));
    });

     it(@"Should get correctly when initialized with a dictionary and sdlMsgVersion first", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
         SDLRegisterAppInterface* testRegisterAppInterface = [[SDLRegisterAppInterface alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
         expect(testRegisterAppInterface.sdlMsgVersion).to(equal(currentSDLMsgVersion));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
         expect(testRegisterAppInterface.syncMsgVersion).to(equal(currentSyncMsgVersion));
#pragma clang diagnostic pop
         expect(testRegisterAppInterface.appName).to(match(appName));
         expect(testRegisterAppInterface.ttsName).to(equal([@[chunk] mutableCopy]));
         expect(testRegisterAppInterface.ngnMediaScreenAppName).to(match(shortAppName));
         expect(testRegisterAppInterface.vrSynonyms).to(equal(@[vrSynonyms]));
         expect(testRegisterAppInterface.isMediaApplication).to(equal(isMediaApp));
         expect(testRegisterAppInterface.languageDesired).to(equal(SDLLanguageNoNo));
         expect(testRegisterAppInterface.hmiDisplayLanguageDesired).to(equal(SDLLanguagePtPt));
         expect(testRegisterAppInterface.appHMIType).to(equal(appTypes));
         expect(testRegisterAppInterface.hashID).to(match(resumeHash));
         expect(testRegisterAppInterface.deviceInfo).to(equal(info));
         expect(testRegisterAppInterface.fullAppID).to(match(fullAppId));
         expect(testRegisterAppInterface.appID).to(match(appId));
         expect(testRegisterAppInterface.appInfo).to(equal(appInfo));
         expect(testRegisterAppInterface.dayColorScheme).to(equal(colorScheme));
         expect(testRegisterAppInterface.nightColorScheme).to(equal(colorScheme));
     });
 });

    describe(@"initializers", ^{
        it(@"init", ^{
            testRegisterAppInterface = [[SDLRegisterAppInterface alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testRegisterAppInterface.syncMsgVersion).to(equal(version));
#pragma clang diagnostic pop
            expect(testRegisterAppInterface.sdlMsgVersion).to(beNil());
            expect(testRegisterAppInterface.appName).to(beNil());
            expect(testRegisterAppInterface.ttsName).to(beNil());
            expect(testRegisterAppInterface.ngnMediaScreenAppName).to(beNil());
            expect(testRegisterAppInterface.vrSynonyms).to(beNil());
            expect(testRegisterAppInterface.isMediaApplication).to(beNil());
            expect(testRegisterAppInterface.languageDesired).to(beNil());
            expect(testRegisterAppInterface.hmiDisplayLanguageDesired).to(beNil());
            expect(testRegisterAppInterface.appHMIType).to(beNil());
            expect(testRegisterAppInterface.hashID).to(beNil());
            expect(testRegisterAppInterface.deviceInfo).to(beNil());
            expect(testRegisterAppInterface.appID).to(beNil());
            expect(testRegisterAppInterface.fullAppID).to(beNil());
            expect(testRegisterAppInterface.appInfo).to(beNil());
            expect(testRegisterAppInterface.dayColorScheme).to(beNil());
            expect(testRegisterAppInterface.nightColorScheme).to(beNil());
        });

        it(@"initWithLifecycleConfiguration:", ^{
            SDLLifecycleConfiguration *testLifecyleConfiguration = [SDLLifecycleConfiguration defaultConfigurationWithAppName:appName fullAppId:fullAppId];
            testLifecyleConfiguration.resumeHash = resumeHash;
            testLifecyleConfiguration.appType = SDLAppHMITypeSocial;
            testLifecyleConfiguration.additionalAppTypes = appTypes;
            testLifecyleConfiguration.language = language;
            testLifecyleConfiguration.shortAppName = shortAppName;
            testLifecyleConfiguration.ttsName = @[chunk];
            testLifecyleConfiguration.voiceRecognitionCommandNames = @[vrSynonyms];
            testLifecyleConfiguration.dayColorScheme = colorScheme;
            testLifecyleConfiguration.nightColorScheme = colorScheme;

            SDLRegisterAppInterface *testRegisterAppInterface = [[SDLRegisterAppInterface alloc] initWithLifecycleConfiguration:testLifecyleConfiguration];
            expect(testRegisterAppInterface.fullAppID).to(match(fullAppId));
            expect(testRegisterAppInterface.appID).to(match(expectedAppId));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testRegisterAppInterface.syncMsgVersion).to(equal(currentSyncMsgVersion));
#pragma clang diagnostic pop
            expect(testRegisterAppInterface.sdlMsgVersion).to(equal(currentSDLMsgVersion));
            expect(testRegisterAppInterface.appName).to(equal(appName));
            expect(testRegisterAppInterface.ttsName).to(contain(chunk));
            expect(testRegisterAppInterface.ngnMediaScreenAppName).to(equal(shortAppName));
            expect(testRegisterAppInterface.appHMIType).to(contain(SDLAppHMITypeSocial));
            expect(testRegisterAppInterface.appHMIType).to(contain(SDLAppHMITypeMedia));
            expect(testRegisterAppInterface.appHMIType).to(contain(SDLAppHMITypeNavigation));
            expect(testRegisterAppInterface.appHMIType).to(contain(SDLAppHMITypeInformation));
            expect(testRegisterAppInterface.isMediaApplication).to(equal(@YES));
            expect(testRegisterAppInterface.hashID).to(match(resumeHash));
            expect(testRegisterAppInterface.languageDesired).to(match(language));
            expect(testRegisterAppInterface.hmiDisplayLanguageDesired).to(match(language));
            expect(testRegisterAppInterface.vrSynonyms).to(contain(vrSynonyms));
            expect(testRegisterAppInterface.deviceInfo).toNot(beNil());
            expect(testRegisterAppInterface.appInfo).toNot(beNil());
            expect(testRegisterAppInterface.dayColorScheme).to(equal(colorScheme));
            expect(testRegisterAppInterface.nightColorScheme).to(equal(colorScheme));
        });

        it(@"initWithAppName:appId:languageDesired:", ^{
            SDLRegisterAppInterface *testRegisterAppInterface = [[SDLRegisterAppInterface alloc] initWithAppName:appName appId:appId languageDesired:language];

            expect(testRegisterAppInterface.fullAppID).to(beNil());
            expect(testRegisterAppInterface.appID).to(match(appId));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testRegisterAppInterface.syncMsgVersion).to(equal(currentSyncMsgVersion));
#pragma clang diagnostic pop
            expect(testRegisterAppInterface.sdlMsgVersion).to(equal(currentSDLMsgVersion));
            expect(testRegisterAppInterface.appName).to(equal(appName));
            expect(testRegisterAppInterface.ttsName).to(beNil());
            expect(testRegisterAppInterface.ngnMediaScreenAppName).to(beNil());
            expect(testRegisterAppInterface.appHMIType).to(beNil());
            expect(testRegisterAppInterface.isMediaApplication).to(equal(@NO));
            expect(testRegisterAppInterface.hashID).to(beNil());
            expect(testRegisterAppInterface.languageDesired).to(equal(language));
            expect(testRegisterAppInterface.hmiDisplayLanguageDesired).to(equal(language));
            expect(testRegisterAppInterface.vrSynonyms).to(beNil());
            expect(testRegisterAppInterface.deviceInfo).toNot(beNil());
            expect(testRegisterAppInterface.appInfo).toNot(beNil());
            expect(testRegisterAppInterface.dayColorScheme).to(beNil());
            expect(testRegisterAppInterface.nightColorScheme).to(beNil());
        });

        it(@"initWithAppName:appId:languageDesired:isMediaApp:appTypes:shortAppName:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLRegisterAppInterface *testRegisterAppInterface = [[SDLRegisterAppInterface alloc] initWithAppName:appName appId:appId languageDesired:language isMediaApp:isMediaApp appTypes:appTypes shortAppName:shortAppName];
#pragma clang diagnostic pop
            expect(testRegisterAppInterface.fullAppID).to(beNil());
            expect(testRegisterAppInterface.appID).to(match(appId));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testRegisterAppInterface.syncMsgVersion).to(equal(currentSyncMsgVersion));
#pragma clang diagnostic pop
            expect(testRegisterAppInterface.sdlMsgVersion).to(equal(currentSDLMsgVersion));
            expect(testRegisterAppInterface.appName).to(equal(appName));
            expect(testRegisterAppInterface.ttsName).to(beNil());
            expect(testRegisterAppInterface.ngnMediaScreenAppName).to(equal(shortAppName));
            expect(testRegisterAppInterface.appHMIType).to(contain(SDLAppHMITypeMedia));
            expect(testRegisterAppInterface.appHMIType).to(contain(SDLAppHMITypeNavigation));
            expect(testRegisterAppInterface.appHMIType).to(contain(SDLAppHMITypeInformation));
            expect(testRegisterAppInterface.isMediaApplication).to(equal(isMediaApp));
            expect(testRegisterAppInterface.hashID).to(beNil());
            expect(testRegisterAppInterface.languageDesired).to(equal(language));
            expect(testRegisterAppInterface.hmiDisplayLanguageDesired).to(equal(language));
            expect(testRegisterAppInterface.vrSynonyms).to(beNil());
            expect(testRegisterAppInterface.deviceInfo).toNot(beNil());
            expect(testRegisterAppInterface.appInfo).toNot(beNil());
            expect(testRegisterAppInterface.dayColorScheme).to(beNil());
            expect(testRegisterAppInterface.nightColorScheme).to(beNil());
        });
        it(@"initWithAppName:appId:languageDesired:isMediaApp:appTypes:shortAppName:ttsName:vrSynonyms:hmiDisplayLanguageDesired:resumeHash:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLRegisterAppInterface *testRegisterAppInterface = [[SDLRegisterAppInterface alloc] initWithAppName:appName appId:appId languageDesired:language isMediaApp:isMediaApp appTypes:appTypes shortAppName:shortAppName ttsName:@[chunk] vrSynonyms:@[vrSynonyms] hmiDisplayLanguageDesired:hmiDisplayLanguage resumeHash:resumeHash];
#pragma clang diagnostic pop
            expect(testRegisterAppInterface.fullAppID).to(beNil());
            expect(testRegisterAppInterface.appID).to(match(appId));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testRegisterAppInterface.syncMsgVersion).to(equal(currentSyncMsgVersion));
#pragma clang diagnostic pop
            expect(testRegisterAppInterface.sdlMsgVersion).to(equal(currentSDLMsgVersion));
            expect(testRegisterAppInterface.appName).to(equal(appName));
            expect(testRegisterAppInterface.ttsName).to(contain(chunk));
            expect(testRegisterAppInterface.ngnMediaScreenAppName).to(equal(shortAppName));
            expect(testRegisterAppInterface.appHMIType).to(contain(SDLAppHMITypeMedia));
            expect(testRegisterAppInterface.appHMIType).to(contain(SDLAppHMITypeNavigation));
            expect(testRegisterAppInterface.appHMIType).to(contain(SDLAppHMITypeInformation));
            expect(testRegisterAppInterface.isMediaApplication).to(equal(isMediaApp));
            expect(testRegisterAppInterface.hashID).to(match(resumeHash));
            expect(testRegisterAppInterface.languageDesired).to(equal(language));
            expect(testRegisterAppInterface.hmiDisplayLanguageDesired).to(equal(hmiDisplayLanguage));
            expect(testRegisterAppInterface.vrSynonyms).to(contain(vrSynonyms));
            expect(testRegisterAppInterface.deviceInfo).toNot(beNil());
            expect(testRegisterAppInterface.appInfo).toNot(beNil());
            expect(testRegisterAppInterface.dayColorScheme).to(beNil());
            expect(testRegisterAppInterface.nightColorScheme).to(beNil());
        });
        it(@"initWithAppName:appId:fullAppId:languageDesired:isMediaApp:appTypes:shortAppName:ttsName:vrSynonyms:hmiDisplayLanguageDesired:resumeHash:dayColorScheme:nightColorScheme:", ^{
            SDLRegisterAppInterface *testRegisterAppInterface = [[SDLRegisterAppInterface alloc] initWithAppName:appName appId:appId fullAppId:fullAppId languageDesired:language isMediaApp:isMediaApp appTypes:appTypes shortAppName:shortAppName ttsName:@[chunk] vrSynonyms:@[vrSynonyms] hmiDisplayLanguageDesired:hmiDisplayLanguage resumeHash:resumeHash dayColorScheme:colorScheme nightColorScheme:colorScheme];

            expect(testRegisterAppInterface.fullAppID).to(match(fullAppId));
            expect(testRegisterAppInterface.appID).to(match(appId));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testRegisterAppInterface.syncMsgVersion).to(equal(currentSyncMsgVersion));
#pragma clang diagnostic pop
            expect(testRegisterAppInterface.sdlMsgVersion).to(equal(currentSDLMsgVersion));
            expect(testRegisterAppInterface.appName).to(equal(appName));
            expect(testRegisterAppInterface.ttsName).to(contain(chunk));
            expect(testRegisterAppInterface.ngnMediaScreenAppName).to(equal(shortAppName));
            expect(testRegisterAppInterface.appHMIType).to(contain(SDLAppHMITypeMedia));
            expect(testRegisterAppInterface.appHMIType).to(contain(SDLAppHMITypeNavigation));
            expect(testRegisterAppInterface.appHMIType).to(contain(SDLAppHMITypeInformation));
            expect(testRegisterAppInterface.isMediaApplication).to(equal(isMediaApp));
            expect(testRegisterAppInterface.hashID).to(match(resumeHash));
            expect(testRegisterAppInterface.languageDesired).to(equal(language));
            expect(testRegisterAppInterface.hmiDisplayLanguageDesired).to(equal(hmiDisplayLanguage));
            expect(testRegisterAppInterface.vrSynonyms).to(contain(vrSynonyms));
            expect(testRegisterAppInterface.deviceInfo).toNot(beNil());
            expect(testRegisterAppInterface.appInfo).toNot(beNil());
            expect(testRegisterAppInterface.dayColorScheme).to(equal(colorScheme));
            expect(testRegisterAppInterface.nightColorScheme).to(equal(colorScheme));
        });
    });
});

QuickSpecEnd
