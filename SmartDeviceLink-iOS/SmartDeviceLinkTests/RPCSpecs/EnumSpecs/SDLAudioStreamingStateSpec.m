//
//  SDLAudioStreamingStateSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioStreamingState.h"

QuickSpecBegin(SDLAudioStreamingStateSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLAudioStreamingState AUDIBLE].value).to(equal(@"AUDIBLE"));
        expect([SDLAudioStreamingState ATTENUATED].value).to(equal(@"ATTENUATED"));
        expect([SDLAudioStreamingState NOT_AUDIBLE].value).to(equal(@"NOT_AUDIBLE"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLAudioStreamingState valueOf:@"AUDIBLE"]).to(equal([SDLAudioStreamingState AUDIBLE]));
        expect([SDLAudioStreamingState valueOf:@"ATTENUATED"]).to(equal([SDLAudioStreamingState ATTENUATED]));
        expect([SDLAudioStreamingState valueOf:@"NOT_AUDIBLE"]).to(equal([SDLAudioStreamingState NOT_AUDIBLE]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLAudioStreamingState valueOf:nil]).to(beNil());
        expect([SDLAudioStreamingState valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLAudioStreamingState values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLAudioStreamingState AUDIBLE],
                        [SDLAudioStreamingState ATTENUATED],
                        [SDLAudioStreamingState NOT_AUDIBLE]] copy];
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