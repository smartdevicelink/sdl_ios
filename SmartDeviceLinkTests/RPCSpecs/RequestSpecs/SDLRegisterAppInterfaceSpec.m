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
#import "SDLNames.h"
#import "SDLRegisterAppInterface.h"
#import "SDLSyncMsgVersion.h"
#import "SDLTemplateColorScheme.h"
#import "SDLTTSChunk.h"


QuickSpecBegin(SDLRegisterAppInterfaceSpec)

describe(@"RegisterAppInterface Tests", ^{
    __block NSString *appName = @"app56";
    __block NSString *appId = @"123456789";
    __block NSString *shortAppName = @"whatisanngn";
    __block NSString *resumeHash = @"gercd35grw2";
    __block NSString *vrSynonyms = @"app56";
    __block NSNumber<SDLBool> *isMediaApp = @YES;
    __block SDLAppHMIType appType = SDLAppHMITypeMedia;
    __block SDLLanguage language = SDLLanguageElGr;
    __block SDLLanguage hmiDisplayLanguage = SDLLanguageArSa;
    __block SDLSyncMsgVersion* version = nil;
    __block SDLTTSChunk* chunk = nil;
    __block SDLDeviceInfo* info = nil;
    __block SDLAppInfo* appInfo = nil;
    __block SDLTemplateColorScheme *colorScheme = nil;

    beforeEach(^{
        version = [[SDLSyncMsgVersion alloc] init];
        chunk = [[SDLTTSChunk alloc] init];
        info = [[SDLDeviceInfo alloc] init];
        appInfo = [[SDLAppInfo alloc] init];
        colorScheme = [[SDLTemplateColorScheme alloc] init];
    });

    describe(@"initializers", ^{
        it(@"initWithLifecycleConfiguration:", ^{
            SDLLifecycleConfiguration *testConfiguration = [SDLLifecycleConfiguration defaultConfigurationWithAppName:appName appId:appId];
            testConfiguration.resumeHash = resumeHash;
            testConfiguration.appType = appType;
            testConfiguration.language = language;
            testConfiguration.shortAppName = shortAppName;
            testConfiguration.ttsName = @[chunk];
            testConfiguration.voiceRecognitionCommandNames = @[vrSynonyms];
            testConfiguration.dayColorScheme = colorScheme;
            testConfiguration.nightColorScheme = colorScheme;

            SDLRegisterAppInterface *testRequest = [[SDLRegisterAppInterface alloc] initWithLifecycleConfiguration:testConfiguration];
            expect(testRequest.syncMsgVersion).toNot(beNil());
            expect(testRequest.appName).to(equal(appName));
            expect(testRequest.ttsName).to(contain(chunk));
            expect(testRequest.ngnMediaScreenAppName).to(equal(shortAppName));
            expect(testRequest.appHMIType).to(contain(appType));
            expect(testRequest.isMediaApplication).to(equal(@YES));
            expect(testRequest.hashID).to(equal(resumeHash));
            expect(testRequest.languageDesired).to(equal(language));
            expect(testRequest.hmiDisplayLanguageDesired).to(equal(language));
            expect(testRequest.vrSynonyms).to(contain(vrSynonyms));
            expect(testRequest.deviceInfo).toNot(beNil());
            expect(testRequest.appInfo).toNot(beNil());
            expect(testRequest.dayColorScheme).to(equal(colorScheme));
            expect(testRequest.nightColorScheme).to(equal(colorScheme));
        });

        it(@"initWithAppName:appId:languageDesired:isMediaApp:appTypes:shortAppName:", ^{
            SDLRegisterAppInterface *testRequest = [[SDLRegisterAppInterface alloc] initWithAppName:appName appId:appId languageDesired:language];

            expect(testRequest.syncMsgVersion).to(equal([[SDLSyncMsgVersion alloc] initWithMajorVersion:5 minorVersion:0 patchVersion:0]));
            expect(testRequest.appName).to(equal(appName));
            expect(testRequest.ttsName).to(beNil());
            expect(testRequest.ngnMediaScreenAppName).to(beNil());
            expect(testRequest.appHMIType).to(beNil());
            expect(testRequest.isMediaApplication).to(equal(@NO));
            expect(testRequest.hashID).to(beNil());
            expect(testRequest.languageDesired).to(equal(language));
            expect(testRequest.hmiDisplayLanguageDesired).to(equal(language));
            expect(testRequest.vrSynonyms).to(beNil());
            expect(testRequest.deviceInfo).toNot(beNil());
            expect(testRequest.appInfo).toNot(beNil());
            expect(testRequest.dayColorScheme).to(beNil());
            expect(testRequest.nightColorScheme).to(beNil());
        });

        it(@"initWithAppName:appId:languageDesired:isMediaApp:appTypes:shortAppName:", ^{
            SDLRegisterAppInterface *testRequest = [[SDLRegisterAppInterface alloc] initWithAppName:appName appId:appId languageDesired:language isMediaApp:isMediaApp appTypes:@[appType] shortAppName:shortAppName];

            expect(testRequest.syncMsgVersion).toNot(beNil());
            expect(testRequest.appName).to(equal(appName));
            expect(testRequest.ttsName).to(beNil());
            expect(testRequest.ngnMediaScreenAppName).to(equal(shortAppName));
            expect(testRequest.appHMIType).to(contain(appType));
            expect(testRequest.isMediaApplication).to(equal(isMediaApp));
            expect(testRequest.hashID).to(beNil());
            expect(testRequest.languageDesired).to(equal(language));
            expect(testRequest.hmiDisplayLanguageDesired).to(equal(language));
            expect(testRequest.vrSynonyms).to(beNil());
            expect(testRequest.deviceInfo).toNot(beNil());
            expect(testRequest.appInfo).toNot(beNil());
            expect(testRequest.dayColorScheme).to(beNil());
            expect(testRequest.nightColorScheme).to(beNil());
        });

        it(@"initWithAppName:appId:languageDesired:isMediaApp:appTypes:shortAppName:ttsName:vrSynonyms:hmiDisplayLanguageDesired:resumeHash:dayColorScheme:nightColorScheme:", ^{
            SDLRegisterAppInterface *testRequest = [[SDLRegisterAppInterface alloc] initWithAppName:appName appId:appId languageDesired:language isMediaApp:isMediaApp appTypes:@[appType] shortAppName:shortAppName ttsName:@[chunk] vrSynonyms:@[vrSynonyms] hmiDisplayLanguageDesired:hmiDisplayLanguage resumeHash:resumeHash dayColorScheme:colorScheme nightColorScheme:colorScheme];

            expect(testRequest.syncMsgVersion).toNot(beNil());
            expect(testRequest.appName).to(equal(appName));
            expect(testRequest.ttsName).to(contain(chunk));
            expect(testRequest.ngnMediaScreenAppName).to(equal(shortAppName));
            expect(testRequest.appHMIType).to(contain(appType));
            expect(testRequest.isMediaApplication).to(equal(isMediaApp));
            expect(testRequest.hashID).to(equal(resumeHash));
            expect(testRequest.languageDesired).to(equal(language));
            expect(testRequest.hmiDisplayLanguageDesired).to(equal(hmiDisplayLanguage));
            expect(testRequest.vrSynonyms).to(contain(vrSynonyms));
            expect(testRequest.deviceInfo).toNot(beNil());
            expect(testRequest.appInfo).toNot(beNil());
            expect(testRequest.dayColorScheme).to(equal(colorScheme));
            expect(testRequest.nightColorScheme).to(equal(colorScheme));
        });

        it(@"init with a dictionary", ^ {
            NSDictionary* dict = @{SDLNameRequest:
                                               @{SDLNameParameters:
                                                     @{SDLNameSyncMessageVersion:version,
                                                       SDLNameAppName:@"app56",
                                                       SDLNameTTSName:[@[chunk] mutableCopy],
                                                       SDLNameNGNMediaScreenAppName:@"whatisanngn",
                                                       SDLNameVRSynonyms:[@[@"paraphrase of the original name"] mutableCopy],
                                                       SDLNameIsMediaApplication:@NO,
                                                       SDLNameLanguageDesired:SDLLanguageNoNo,
                                                       SDLNameHMIDisplayLanguageDesired:SDLLanguagePtPt,
                                                       SDLNameAppHMIType:[@[SDLAppHMITypeMessaging, SDLAppHMITypeInformation] copy],
                                                       SDLNameHashId:@"gercd35grw2",
                                                       SDLNameDeviceInfo:info,
                                                       SDLNameAppId:@"123456789",
                                                       SDLNameAppInfo:appInfo,
                                                       SDLNameDayColorScheme: colorScheme,
                                                       SDLNameNightColorScheme: colorScheme,
                                                       },
                                                 SDLNameOperationName:SDLNameRegisterAppInterface}};
            SDLRegisterAppInterface* testRequest = [[SDLRegisterAppInterface alloc] initWithDictionary:dict];

            expect(testRequest.syncMsgVersion).to(equal(version));
            expect(testRequest.appName).to(equal(@"app56"));
            expect(testRequest.ttsName).to(equal([@[chunk] mutableCopy]));
            expect(testRequest.ngnMediaScreenAppName).to(equal(@"whatisanngn"));
            expect(testRequest.vrSynonyms).to(equal([@[@"paraphrase of the original name"] mutableCopy]));
            expect(testRequest.isMediaApplication).to(equal(@NO));
            expect(testRequest.languageDesired).to(equal(SDLLanguageNoNo));
            expect(testRequest.hmiDisplayLanguageDesired).to(equal(SDLLanguagePtPt));
            expect(testRequest.appHMIType).to(equal([@[SDLAppHMITypeMessaging, SDLAppHMITypeInformation] copy]));
            expect(testRequest.hashID).to(equal(@"gercd35grw2"));
            expect(testRequest.deviceInfo).to(equal(info));
            expect(testRequest.appID).to(equal(@"123456789"));
            expect(testRequest.appInfo).to(equal(appInfo));
            expect(testRequest.dayColorScheme).to(equal(colorScheme));
            expect(testRequest.nightColorScheme).to(equal(colorScheme));
        });

        it(@"init", ^ {
            SDLRegisterAppInterface* testRequest = [[SDLRegisterAppInterface alloc] init];

            expect(testRequest.syncMsgVersion).to(beNil());
            expect(testRequest.appName).to(beNil());
            expect(testRequest.ttsName).to(beNil());
            expect(testRequest.ngnMediaScreenAppName).to(beNil());
            expect(testRequest.vrSynonyms).to(beNil());
            expect(testRequest.isMediaApplication).to(beNil());
            expect(testRequest.languageDesired).to(beNil());
            expect(testRequest.hmiDisplayLanguageDesired).to(beNil());
            expect(testRequest.appHMIType).to(beNil());
            expect(testRequest.hashID).to(beNil());
            expect(testRequest.deviceInfo).to(beNil());
            expect(testRequest.appID).to(beNil());
            expect(testRequest.appInfo).to(beNil());
            expect(testRequest.dayColorScheme).to(beNil());
            expect(testRequest.nightColorScheme).to(beNil());
        });
    });

    describe(@"getters / setters", ^{
        it(@"Should set and get correctly", ^ {
            SDLRegisterAppInterface* testRequest = [[SDLRegisterAppInterface alloc] init];

            testRequest.syncMsgVersion = version;
            testRequest.appName = appName;
            testRequest.ttsName = @[chunk];
            testRequest.ngnMediaScreenAppName = shortAppName;
            testRequest.vrSynonyms = @[vrSynonyms];
            testRequest.isMediaApplication = @NO;
            testRequest.languageDesired = language;
            testRequest.hmiDisplayLanguageDesired = hmiDisplayLanguage;
            testRequest.appHMIType = @[SDLAppHMITypeMessaging, SDLAppHMITypeInformation];
            testRequest.hashID = resumeHash;
            testRequest.deviceInfo = info;
            testRequest.appID = @"123456789";
            testRequest.appInfo = appInfo;
            testRequest.dayColorScheme = colorScheme;
            testRequest.nightColorScheme = colorScheme;

            expect(testRequest.syncMsgVersion).to(equal(version));
            expect(testRequest.appName).to(equal(appName));
            expect(testRequest.ttsName).to(contain(chunk));
            expect(testRequest.ngnMediaScreenAppName).to(equal(shortAppName));
            expect(testRequest.vrSynonyms).to(contain(vrSynonyms));
            expect(testRequest.isMediaApplication).to(equal(@NO));
            expect(testRequest.languageDesired).to(equal(language));
            expect(testRequest.hmiDisplayLanguageDesired).to(equal(hmiDisplayLanguage));
            expect(testRequest.appHMIType).to(equal([@[SDLAppHMITypeMessaging, SDLAppHMITypeInformation] copy]));
            expect(testRequest.hashID).to(equal(resumeHash));
            expect(testRequest.deviceInfo).to(equal(info));
            expect(testRequest.appID).to(equal(appId));
            expect(testRequest.appInfo).to(equal(appInfo));
            expect(testRequest.dayColorScheme).to(equal(colorScheme));
            expect(testRequest.nightColorScheme).to(equal(colorScheme));
        });
    });
});

QuickSpecEnd
