//
//  SDLPrerecordedSpeechSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPrerecordedSpeech.h"

QuickSpecBegin(SDLPrerecordedSpeechSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLPrerecordedSpeech HELP_JINGLE].value).to(equal(@"HELP_JINGLE"));
        expect([SDLPrerecordedSpeech INITIAL_JINGLE].value).to(equal(@"INITIAL_JINGLE"));
        expect([SDLPrerecordedSpeech LISTEN_JINGLE].value).to(equal(@"LISTEN_JINGLE"));
        expect([SDLPrerecordedSpeech POSITIVE_JINGLE].value).to(equal(@"POSITIVE_JINGLE"));
        expect([SDLPrerecordedSpeech NEGATIVE_JINGLE].value).to(equal(@"NEGATIVE_JINGLE"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLPrerecordedSpeech valueOf:@"HELP_JINGLE"]).to(equal([SDLPrerecordedSpeech HELP_JINGLE]));
        expect([SDLPrerecordedSpeech valueOf:@"INITIAL_JINGLE"]).to(equal([SDLPrerecordedSpeech INITIAL_JINGLE]));
        expect([SDLPrerecordedSpeech valueOf:@"LISTEN_JINGLE"]).to(equal([SDLPrerecordedSpeech LISTEN_JINGLE]));
        expect([SDLPrerecordedSpeech valueOf:@"POSITIVE_JINGLE"]).to(equal([SDLPrerecordedSpeech POSITIVE_JINGLE]));
        expect([SDLPrerecordedSpeech valueOf:@"NEGATIVE_JINGLE"]).to(equal([SDLPrerecordedSpeech NEGATIVE_JINGLE]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLPrerecordedSpeech valueOf:nil]).to(beNil());
        expect([SDLPrerecordedSpeech valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLPrerecordedSpeech values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLPrerecordedSpeech HELP_JINGLE],
                        [SDLPrerecordedSpeech INITIAL_JINGLE],
                        [SDLPrerecordedSpeech LISTEN_JINGLE],
                        [SDLPrerecordedSpeech POSITIVE_JINGLE],
                        [SDLPrerecordedSpeech NEGATIVE_JINGLE]] copy];
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