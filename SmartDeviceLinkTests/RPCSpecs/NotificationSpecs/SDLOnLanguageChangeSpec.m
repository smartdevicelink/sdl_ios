//
//  SDLOnLanguageChangeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLanguage.h"
#import "SDLOnLanguageChange.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"


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
        NSMutableDictionary* dict = [@{SDLRPCParameterNameNotification:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameLanguage:SDLLanguageEsEs,
                                                   SDLRPCParameterNameHMIDisplayLanguage:SDLLanguageDeDe},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnLanguageChange}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnLanguageChange* testNotification = [[SDLOnLanguageChange alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
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
