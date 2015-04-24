//
//  SDLBitsPerSampleSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLBitsPerSample.h"

QuickSpecBegin(SDLBitsPerSampleSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLBitsPerSample _8_BIT].value).to(equal(@"8_BIT"));
        expect([SDLBitsPerSample _16_BIT].value).to(equal(@"16_BIT"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLBitsPerSample valueOf:@"8_BIT"]).to(equal([SDLBitsPerSample _8_BIT]));
        expect([SDLBitsPerSample valueOf:@"16_BIT"]).to(equal([SDLBitsPerSample _16_BIT]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLBitsPerSample valueOf:nil]).to(beNil());
        expect([SDLBitsPerSample valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLBitsPerSample values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLBitsPerSample _8_BIT],
                        [SDLBitsPerSample _16_BIT]] copy];
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
