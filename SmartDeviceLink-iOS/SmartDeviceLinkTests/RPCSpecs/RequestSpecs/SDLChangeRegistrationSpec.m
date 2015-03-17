//
//  SDLChangeRegistrationSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLChangeRegistration.h"
//#import "SDLTTSChunk.h"
#import "SDLNames.h"

QuickSpecBegin(SDLChangeRegistrationSpec)

//SDLTTSChunk* tts = [[SDLTTSChunk alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLChangeRegistration* testRequest = [[SDLChangeRegistration alloc] init];
        
        testRequest.language = [SDLLanguage IT_IT];
        testRequest.hmiDisplayLanguage = [SDLLanguage KO_KR];
        //testRequest.appName = @"theName";
        //testRequest.ttsName = [@[tts] mutableCopy];
        //testRequest.ngnMediaScreenAppName = @"q";
        //testRequest.vrSynonyms = [@[@"paraphrase", @"thesaurus"] mutableCopy];
        
        expect(testRequest.language).to(equal([SDLLanguage IT_IT]));
        expect(testRequest.hmiDisplayLanguage).to(equal([SDLLanguage KO_KR]));
        //expect(testRequest.appName).to(equal(@"theName"));
        //expect(testRequest.ttsName).to(equal([@[tts] mutableCopy]));
        //expect(testRequest.ngnMediaScreenAppName).to(equal(@"q"));
        //expect(testRequest.vrSynonyms).to(equal([@[@"paraphrase", @"thesaurus"] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_language:[SDLLanguage IT_IT],
                                                   NAMES_hmiDisplayLanguage:[SDLLanguage KO_KR]},
                                             //NAMES_appName:@"theName",
                                             //NAMES_ttsName:[@[tts] mutableCopy],
                                             //NAMES_ngnMediaScreenAppName:@"q",
                                             //NAMES_vrSynonyms:[@[@"paraphrase", @"thesaurus"] mutableCopy]},
                                             NAMES_operation_name:NAMES_ChangeRegistration}} mutableCopy];
        SDLChangeRegistration* testRequest = [[SDLChangeRegistration alloc] initWithDictionary:dict];
        
        expect(testRequest.language).to(equal([SDLLanguage IT_IT]));
        expect(testRequest.hmiDisplayLanguage).to(equal([SDLLanguage KO_KR]));
        //expect(testRequest.appName).to(equal(@"theName"));
        //expect(testRequest.ttsName).to(equal([@[tts] mutableCopy]));
        //expect(testRequest.ngnMediaScreenAppName).to(equal(@"q"));
        //expect(testRequest.vrSynonyms).to(equal([@[@"paraphrase", @"thesaurus"] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLChangeRegistration* testRequest = [[SDLChangeRegistration alloc] init];
        
        expect(testRequest.language).to(beNil());
        expect(testRequest.hmiDisplayLanguage).to(beNil());
        //expect(testRequest.appName).to(beNil());
        //expect(testRequest.ttsName).to(beNil());
        //expect(testRequest.ngnMediaScreenAppName).to(beNil());
        //expect(testRequest.vrSynonyms).to(beNil());
    });
});

QuickSpecEnd