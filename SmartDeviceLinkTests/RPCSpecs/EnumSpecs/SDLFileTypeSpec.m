//
//  SDLFileTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFileType.h"

QuickSpecBegin(SDLFileTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLFileType GRAPHIC_BMP].value).to(equal(@"GRAPHIC_BMP"));
        expect([SDLFileType GRAPHIC_JPEG].value).to(equal(@"GRAPHIC_JPEG"));
        expect([SDLFileType GRAPHIC_PNG].value).to(equal(@"GRAPHIC_PNG"));
        expect([SDLFileType AUDIO_WAVE].value).to(equal(@"AUDIO_WAVE"));
        expect([SDLFileType AUDIO_MP3].value).to(equal(@"AUDIO_MP3"));
        expect([SDLFileType AUDIO_AAC].value).to(equal(@"AUDIO_AAC"));
        expect([SDLFileType BINARY].value).to(equal(@"BINARY"));
        expect([SDLFileType JSON].value).to(equal(@"JSON"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLFileType valueOf:@"GRAPHIC_BMP"]).to(equal([SDLFileType GRAPHIC_BMP]));
        expect([SDLFileType valueOf:@"GRAPHIC_JPEG"]).to(equal([SDLFileType GRAPHIC_JPEG]));
        expect([SDLFileType valueOf:@"GRAPHIC_PNG"]).to(equal([SDLFileType GRAPHIC_PNG]));
        expect([SDLFileType valueOf:@"AUDIO_WAVE"]).to(equal([SDLFileType AUDIO_WAVE]));
        expect([SDLFileType valueOf:@"AUDIO_MP3"]).to(equal([SDLFileType AUDIO_MP3]));
        expect([SDLFileType valueOf:@"AUDIO_AAC"]).to(equal([SDLFileType AUDIO_AAC]));
        expect([SDLFileType valueOf:@"BINARY"]).to(equal([SDLFileType BINARY]));
        expect([SDLFileType valueOf:@"JSON"]).to(equal([SDLFileType JSON]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLFileType valueOf:nil]).to(beNil());
        expect([SDLFileType valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLFileType values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLFileType GRAPHIC_BMP],
                        [SDLFileType GRAPHIC_JPEG],
                        [SDLFileType GRAPHIC_PNG],
                        [SDLFileType AUDIO_WAVE],
                        [SDLFileType AUDIO_MP3],
                        [SDLFileType AUDIO_AAC],
                        [SDLFileType BINARY],
                        [SDLFileType JSON]] copy];
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