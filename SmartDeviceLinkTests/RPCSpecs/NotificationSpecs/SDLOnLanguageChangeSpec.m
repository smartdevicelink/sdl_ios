//
//  SDLOnLanguageChangeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLanguage.h"
#import "SDLOnLanguageChange.h"
#import "SDLNames.h"


QuickSpecBegin(SDLOnLanguageChangeSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnLanguageChange* testNotification = [[SDLOnLanguageChange alloc] init];
        
        testNotification.language = SDLLanguageEsEs;
        testNotification.hmiDisplayLanguage = SDLLanguageDeDe;
        
        expect(testNotification.language).to(equal(SDLLanguageEsEs));
        expect(testNotification.hmiDisplayLanguage).to(equal(SDLLanguageDeDe));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_notification:
                                           @{NAMES_parameters:
                                                 @{NAMES_language:SDLLanguageEsEs,
                                                   NAMES_hmiDisplayLanguage:SDLLanguageDeDe},
                                             NAMES_operation_name:NAMES_OnLanguageChange}} mutableCopy];
        SDLOnLanguageChange* testNotification = [[SDLOnLanguageChange alloc] initWithDictionary:dict];
        
        expect(testNotification.language).to(equal(SDLLanguageEsEs));
        expect(testNotification.hmiDisplayLanguage).to(equal(SDLLanguageDeDe));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnLanguageChange* testNotification = [[SDLOnLanguageChange alloc] init];
        
        expect(testNotification.language).to(beNil());
        expect(testNotification.hmiDisplayLanguage).to(beNil());
    });
});

QuickSpecEnd
