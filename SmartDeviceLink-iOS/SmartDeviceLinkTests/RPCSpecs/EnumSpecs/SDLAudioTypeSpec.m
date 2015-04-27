//
//  SDLAudioTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioType.h"

QuickSpecBegin(SDLAudioTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLAudioType PCM].value).to(equal(@"PCM"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLAudioType valueOf:@"PCM"]).to(equal([SDLAudioType PCM]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLAudioType valueOf:nil]).to(beNil());
        expect([SDLAudioType valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLAudioType values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLAudioType PCM]] copy];
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