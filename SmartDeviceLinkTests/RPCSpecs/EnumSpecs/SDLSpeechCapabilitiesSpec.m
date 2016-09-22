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
        expect(SDLSpeechCapabilitiesSapiPhonemes).to(equal(@"SAPI_PHONEMES"));
        expect(SDLSpeechCapabilitiesLhplusPhonemes).to(equal(@"LHPLUS_PHONEMES"));
        expect(SDLSpeechCapabilitiesPreRecorded).to(equal(@"PRE_RECORDED"));
        expect(SDLSpeechCapabilitiesSilence).to(equal(@"SILENCE"));
    });
});

QuickSpecEnd
