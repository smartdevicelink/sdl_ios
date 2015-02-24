//
//  SDLDriverDistractionStateSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/21/15.
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDriverDistractionState.h"

QuickSpecBegin(SDLDriverDistractionStateSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLDriverDistractionState DD_OFF].value).to(equal(@"DD_OFF"));
        expect([SDLDriverDistractionState DD_ON].value).to(equal(@"DD_ON"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLDriverDistractionState valueOf:@"DD_OFF"]).to(equal([SDLDriverDistractionState DD_OFF]));
        expect([SDLDriverDistractionState valueOf:@"DD_ON"]).to(equal([SDLDriverDistractionState DD_ON]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLDriverDistractionState valueOf:nil]).to(beNil());
        expect([SDLDriverDistractionState valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSMutableArray* storedValues = [SDLDriverDistractionState values];
    __block NSMutableArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLDriverDistractionState DD_OFF],
                        [SDLDriverDistractionState DD_ON]] mutableCopy];
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
