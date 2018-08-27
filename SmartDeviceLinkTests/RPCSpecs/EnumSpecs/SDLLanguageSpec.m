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
        expect(SDLLanguageEnSa).to(equal(@"EN-SA"));
        expect(SDLLanguageHeIl).to(equal(@"HE-IL"));
        expect(SDLLanguageRoRo).to(equal(@"RO-RO"));
        expect(SDLLanguageUkUa).to(equal(@"UK-UA"));
        expect(SDLLanguageIdId).to(equal(@"ID-ID"));
        expect(SDLLanguageViVn).to(equal(@"VI-VN"));
        expect(SDLLanguageMsMy).to(equal(@"MS-MY"));
        expect(SDLLanguageHiIn).to(equal(@"HI-IN"));
        expect(SDLLanguageNlBe).to(equal(@"NL-BE"));
        expect(SDLLanguageElGr).to(equal(@"EL-GR"));
        expect(SDLLanguageHuHu).to(equal(@"HU-HU"));
        expect(SDLLanguageFiFi).to(equal(@"FI-FI"));
        expect(SDLLanguageSkSk).to(equal(@"SK-SK"));
        expect(SDLLanguageEnUs).to(equal(@"EN-US"));
        expect(SDLLanguageEnIn).to(equal(@"EN-IN"));
        expect(SDLLanguageThTh).to(equal(@"TH-TH"));
        expect(SDLLanguageEsMx).to(equal(@"ES-MX"));
        expect(SDLLanguageFrCa).to(equal(@"FR-CA"));
        expect(SDLLanguageDeDe).to(equal(@"DE-DE"));
        expect(SDLLanguageEsEs).to(equal(@"ES-ES"));
        expect(SDLLanguageEnGb).to(equal(@"EN-GB"));
        expect(SDLLanguageRuRu).to(equal(@"RU-RU"));
        expect(SDLLanguageTrTr).to(equal(@"TR-TR"));
        expect(SDLLanguagePlPl).to(equal(@"PL-PL"));
        expect(SDLLanguageFrFr).to(equal(@"FR-FR"));
        expect(SDLLanguageItIt).to(equal(@"IT-IT"));
        expect(SDLLanguageSvSe).to(equal(@"SV-SE"));
        expect(SDLLanguagePtPt).to(equal(@"PT-PT"));
        expect(SDLLanguageNlNl).to(equal(@"NL-NL"));
        expect(SDLLanguageEnAu).to(equal(@"EN-AU"));
        expect(SDLLanguageZhCn).to(equal(@"ZH-CN"));
        expect(SDLLanguageZhTw).to(equal(@"ZH-TW"));
        expect(SDLLanguageJaJp).to(equal(@"JA-JP"));
        expect(SDLLanguageArSa).to(equal(@"AR-SA"));
        expect(SDLLanguageKoKr).to(equal(@"KO-KR"));
        expect(SDLLanguagePtBr).to(equal(@"PT-BR"));
        expect(SDLLanguageCsCz).to(equal(@"CS-CZ"));
        expect(SDLLanguageDaDk).to(equal(@"DA-DK"));
        expect(SDLLanguageNoNo).to(equal(@"NO-NO"));
    });
});

QuickSpecEnd
