//
//  SDLSpeechCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSpeechCapabilities.h"

QuickSpecBegin(SDLSpeechCapabilitiesSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLSpeechCapabilitiesText).to(equal(@"TEXT"));
        expect(SDLSpeechCapabilitiesSAPIPhonemes).to(equal(@"SAPI_PHONEMES"));
        expect(SDLSpeechCapabilitiesLHPlusPhonemes).to(equal(@"LHPLUS_PHONEMES"));
        expect(SDLSpeechCapabilitiesPrerecorded).to(equal(@"PRE_RECORDED"));
        expect(SDLSpeechCapabilitiesSilence).to(equal(@"SILENCE"));
    });
});

QuickSpecEnd
