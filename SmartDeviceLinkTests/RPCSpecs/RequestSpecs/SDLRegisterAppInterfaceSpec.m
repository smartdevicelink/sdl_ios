//
//  SDLRegisterAppInterfaceSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppHMIType.h"
#import "SDLAppInfo.h"
#import "SDLDeviceInfo.h"
#import "SDLLanguage.h"
#import "SDLNames.h"
#import "SDLRegisterAppInterface.h"
#import "SDLSyncMsgVersion.h"
#import "SDLTTSChunk.h"


QuickSpecBegin(SDLRegisterAppInterfaceSpec)

SDLSyncMsgVersion* version = [[SDLSyncMsgVersion alloc] init];
SDLTTSChunk* chunk = [[SDLTTSChunk alloc] init];
SDLDeviceInfo* info = [[SDLDeviceInfo alloc] init];
SDLAppInfo* appInfo = [[SDLAppInfo alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLRegisterAppInterface* testRequest = [[SDLRegisterAppInterface alloc] init];
        
        testRequest.syncMsgVersion = version;
        testRequest.appName = @"app56";
        testRequest.ttsName = [@[chunk] mutableCopy];
        testRequest.ngnMediaScreenAppName = @"whatisanngn";
        testRequest.vrSynonyms = [@[@"paraphrase of the original name"] mutableCopy];
        testRequest.isMediaApplication = @NO;
        testRequest.languageDesired = SDLLanguageNoNo;
        testRequest.hmiDisplayLanguageDesired = SDLLanguagePtPt;
        testRequest.appHMIType = [@[SDLAppHMITypeMessaging, SDLAppHMITypeInformation] copy];
        testRequest.hashID = @"gercd35grw2";
        testRequest.deviceInfo = info;
        testRequest.appID = @"123456789";
        testRequest.appInfo = appInfo;
        
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
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameRequest:
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
                                                   SDLNameAppInfo:appInfo},
                                             SDLNameOperationName:SDLNameRegisterAppInterface}} mutableCopy];
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
    });
    
    it(@"Should return nil if not set", ^ {
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
    });
});

QuickSpecEnd
