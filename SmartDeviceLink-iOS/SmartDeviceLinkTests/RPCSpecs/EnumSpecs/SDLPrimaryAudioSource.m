//
//  SDLPrimaryAudioSourceSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPrimaryAudioSource.h"

QuickSpecBegin(SDLPrimaryAudioSourceSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLPrimaryAudioSource NO_SOURCE_SELECTED].value).to(equal(@"NO_SOURCE_SELECTED"));
        expect([SDLPrimaryAudioSource USB].value).to(equal(@"USB"));
        expect([SDLPrimaryAudioSource USB2].value).to(equal(@"USB2"));
        expect([SDLPrimaryAudioSource BLUETOOTH_STEREO_BTST].value).to(equal(@"BLUETOOTH_STEREO_BTST"));
        expect([SDLPrimaryAudioSource LINE_IN].value).to(equal(@"LINE_IN"));
        expect([SDLPrimaryAudioSource IPOD].value).to(equal(@"IPOD"));
        expect([SDLPrimaryAudioSource MOBILE_APP].value).to(equal(@"MOBILE_APP"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLPrimaryAudioSource valueOf:@"NO_SOURCE_SELECTED"]).to(equal([SDLPrimaryAudioSource NO_SOURCE_SELECTED]));
        expect([SDLPrimaryAudioSource valueOf:@"USB"]).to(equal([SDLPrimaryAudioSource USB]));
        expect([SDLPrimaryAudioSource valueOf:@"USB2"]).to(equal([SDLPrimaryAudioSource USB2]));
        expect([SDLPrimaryAudioSource valueOf:@"BLUETOOTH_STEREO_BTST"]).to(equal([SDLPrimaryAudioSource BLUETOOTH_STEREO_BTST]));
        expect([SDLPrimaryAudioSource valueOf:@"LINE_IN"]).to(equal([SDLPrimaryAudioSource LINE_IN]));
        expect([SDLPrimaryAudioSource valueOf:@"IPOD"]).to(equal([SDLPrimaryAudioSource IPOD]));
        expect([SDLPrimaryAudioSource valueOf:@"MOBILE_APP"]).to(equal([SDLPrimaryAudioSource MOBILE_APP]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLPrimaryAudioSource valueOf:nil]).to(beNil());
        expect([SDLPrimaryAudioSource valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLPrimaryAudioSource values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLPrimaryAudioSource NO_SOURCE_SELECTED],
                        [SDLPrimaryAudioSource USB],
                        [SDLPrimaryAudioSource USB2],
                        [SDLPrimaryAudioSource BLUETOOTH_STEREO_BTST],
                        [SDLPrimaryAudioSource LINE_IN],
                        [SDLPrimaryAudioSource IPOD],
                        [SDLPrimaryAudioSource MOBILE_APP]] copy];
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