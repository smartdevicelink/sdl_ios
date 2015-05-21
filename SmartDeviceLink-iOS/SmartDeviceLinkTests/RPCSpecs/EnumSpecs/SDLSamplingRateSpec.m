//
//  SDLSamplingRateSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSamplingRate.h"

QuickSpecBegin(SDLSamplingRateSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLSamplingRate _8KHZ].value).to(equal(@"8KHZ"));
        expect([SDLSamplingRate _16KHZ].value).to(equal(@"16KHZ"));
        expect([SDLSamplingRate _22KHZ].value).to(equal(@"22KHZ"));
        expect([SDLSamplingRate _44KHZ].value).to(equal(@"44KHZ"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLSamplingRate valueOf:@"8KHZ"]).to(equal([SDLSamplingRate _8KHZ]));
        expect([SDLSamplingRate valueOf:@"16KHZ"]).to(equal([SDLSamplingRate _16KHZ]));
        expect([SDLSamplingRate valueOf:@"22KHZ"]).to(equal([SDLSamplingRate _22KHZ]));
        expect([SDLSamplingRate valueOf:@"44KHZ"]).to(equal([SDLSamplingRate _44KHZ]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLSamplingRate valueOf:nil]).to(beNil());
        expect([SDLSamplingRate valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLSamplingRate values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLSamplingRate _8KHZ],
                        [SDLSamplingRate _16KHZ],
                        [SDLSamplingRate _22KHZ],
                        [SDLSamplingRate _44KHZ]] copy];
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
