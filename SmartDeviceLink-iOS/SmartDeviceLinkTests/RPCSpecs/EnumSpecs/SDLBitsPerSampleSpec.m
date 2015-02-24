//
//  SDLBitsPerSampleSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/21/15.
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

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
    NSMutableArray* storedValues = [SDLBitsPerSample values];
    __block NSMutableArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLBitsPerSample _8_BIT],
                        [SDLBitsPerSample _16_BIT]] mutableCopy];
    });
    
    it(@"Should contain all defined enum values", ^ {
        for (int i = 0; i < definedValues.count; i++) {
            expect(storedValues).to(contain([definedValues objectAtIndex:i]));
        }
    });
    
    it(@"Should contain only defined enum values", ^ {
        for (int i = 0; i < storedValues.count; i++) {
            expect(definedValues).to(contain([storedValues objectAtIndex:i]));
        }
    });
});

QuickSpecEnd
