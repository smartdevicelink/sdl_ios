//
//  SDLLanguageSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLanguage.h"

QuickSpecBegin(SDLLanguageSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLLanguage EN_US].value).to(equal(@"EN-US"));
        expect([SDLLanguage ES_MX].value).to(equal(@"ES-MX"));
        expect([SDLLanguage FR_CA].value).to(equal(@"FR-CA"));
        expect([SDLLanguage DE_DE].value).to(equal(@"DE-DE"));
        expect([SDLLanguage ES_ES].value).to(equal(@"ES-ES"));
        expect([SDLLanguage EN_GB].value).to(equal(@"EN-GB"));
        expect([SDLLanguage RU_RU].value).to(equal(@"RU-RU"));
        expect([SDLLanguage TR_TR].value).to(equal(@"TR-TR"));
        expect([SDLLanguage PL_PL].value).to(equal(@"PL-PL"));
        expect([SDLLanguage FR_FR].value).to(equal(@"FR-FR"));
        expect([SDLLanguage IT_IT].value).to(equal(@"IT-IT"));
        expect([SDLLanguage SV_SE].value).to(equal(@"SV-SE"));
        expect([SDLLanguage PT_PT].value).to(equal(@"PT-PT"));
        expect([SDLLanguage NL_NL].value).to(equal(@"NL-NL"));
        expect([SDLLanguage EN_AU].value).to(equal(@"EN-AU"));
        expect([SDLLanguage ZH_CN].value).to(equal(@"ZH-CN"));
        expect([SDLLanguage ZH_TW].value).to(equal(@"ZH-TW"));
        expect([SDLLanguage JA_JP].value).to(equal(@"JA-JP"));
        expect([SDLLanguage AR_SA].value).to(equal(@"AR-SA"));
        expect([SDLLanguage KO_KR].value).to(equal(@"KO-KR"));
        expect([SDLLanguage PT_BR].value).to(equal(@"PT-BR"));
        expect([SDLLanguage CS_CZ].value).to(equal(@"CS-CZ"));
        expect([SDLLanguage DA_DK].value).to(equal(@"DA-DK"));
        expect([SDLLanguage NO_NO].value).to(equal(@"NO-NO"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLLanguage valueOf:@"EN-US"]).to(equal([SDLLanguage EN_US]));
        expect([SDLLanguage valueOf:@"ES-MX"]).to(equal([SDLLanguage ES_MX]));
        expect([SDLLanguage valueOf:@"FR-CA"]).to(equal([SDLLanguage FR_CA]));
        expect([SDLLanguage valueOf:@"DE-DE"]).to(equal([SDLLanguage DE_DE]));
        expect([SDLLanguage valueOf:@"ES-ES"]).to(equal([SDLLanguage ES_ES]));
        expect([SDLLanguage valueOf:@"EN-GB"]).to(equal([SDLLanguage EN_GB]));
        expect([SDLLanguage valueOf:@"RU-RU"]).to(equal([SDLLanguage RU_RU]));
        expect([SDLLanguage valueOf:@"TR-TR"]).to(equal([SDLLanguage TR_TR]));
        expect([SDLLanguage valueOf:@"PL-PL"]).to(equal([SDLLanguage PL_PL]));
        expect([SDLLanguage valueOf:@"FR-FR"]).to(equal([SDLLanguage FR_FR]));
        expect([SDLLanguage valueOf:@"IT-IT"]).to(equal([SDLLanguage IT_IT]));
        expect([SDLLanguage valueOf:@"SV-SE"]).to(equal([SDLLanguage SV_SE]));
        expect([SDLLanguage valueOf:@"PT-PT"]).to(equal([SDLLanguage PT_PT]));
        expect([SDLLanguage valueOf:@"NL-NL"]).to(equal([SDLLanguage NL_NL]));
        expect([SDLLanguage valueOf:@"EN-AU"]).to(equal([SDLLanguage EN_AU]));
        expect([SDLLanguage valueOf:@"ZH-CN"]).to(equal([SDLLanguage ZH_CN]));
        expect([SDLLanguage valueOf:@"ZH-TW"]).to(equal([SDLLanguage ZH_TW]));
        expect([SDLLanguage valueOf:@"JA-JP"]).to(equal([SDLLanguage JA_JP]));
        expect([SDLLanguage valueOf:@"AR-SA"]).to(equal([SDLLanguage AR_SA]));
        expect([SDLLanguage valueOf:@"KO-KR"]).to(equal([SDLLanguage KO_KR]));
        expect([SDLLanguage valueOf:@"PT-BR"]).to(equal([SDLLanguage PT_BR]));
        expect([SDLLanguage valueOf:@"CS-CZ"]).to(equal([SDLLanguage CS_CZ]));
        expect([SDLLanguage valueOf:@"DA-DK"]).to(equal([SDLLanguage DA_DK]));
        expect([SDLLanguage valueOf:@"NO-NO"]).to(equal([SDLLanguage NO_NO]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLLanguage valueOf:nil]).to(beNil());
        expect([SDLLanguage valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLLanguage values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLLanguage EN_US],
                        [SDLLanguage ES_MX],
                        [SDLLanguage FR_CA],
                        [SDLLanguage DE_DE],
                        [SDLLanguage ES_ES],
                        [SDLLanguage EN_GB],
                        [SDLLanguage RU_RU],
                        [SDLLanguage TR_TR],
                        [SDLLanguage PL_PL],
                        [SDLLanguage FR_FR],
                        [SDLLanguage IT_IT],
                        [SDLLanguage SV_SE],
                        [SDLLanguage PT_PT],
                        [SDLLanguage NL_NL],
                        [SDLLanguage EN_AU],
                        [SDLLanguage ZH_CN],
                        [SDLLanguage ZH_TW],
                        [SDLLanguage JA_JP],
                        [SDLLanguage AR_SA],
                        [SDLLanguage KO_KR],
                        [SDLLanguage PT_BR],
                        [SDLLanguage CS_CZ],
                        [SDLLanguage DA_DK],
                        [SDLLanguage NO_NO]] copy];
    });
    
    it(@"Should contain all defined enum values", ^ {
        for (int i = 0; i < definedValues.count; i++) {
            expect(storedValues).to(contain(definedValues[i]));
        }
    });
    
    it(@"Should contain only defined enum values", ^ {
        for (int i = 0; i < storedValues.count; i++) {
            expect(definedValues).to(contain(storedValues[i]));
        }
    });
});

QuickSpecEnd