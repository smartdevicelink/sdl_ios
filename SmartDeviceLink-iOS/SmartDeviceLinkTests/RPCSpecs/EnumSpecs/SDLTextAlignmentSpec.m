//
//  SDLTextAlignmentSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/21/15.
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTextAlignment.h"

QuickSpecBegin(SDLTextAlignmentSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLTextAlignment LEFT_ALIGNED].value).to(equal(@"LEFT_ALIGNED"));
        expect([SDLTextAlignment RIGHT_ALIGNED].value).to(equal(@"RIGHT_ALIGNED"));
        expect([SDLTextAlignment CENTERED].value).to(equal(@"CENTERED"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLTextAlignment valueOf:@"LEFT_ALIGNED"]).to(equal([SDLTextAlignment LEFT_ALIGNED]));
        expect([SDLTextAlignment valueOf:@"RIGHT_ALIGNED"]).to(equal([SDLTextAlignment RIGHT_ALIGNED]));
        expect([SDLTextAlignment valueOf:@"CENTERED"]).to(equal([SDLTextAlignment CENTERED]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLTextAlignment valueOf:nil]).to(beNil());
        expect([SDLTextAlignment valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSMutableArray* storedValues = [SDLTextAlignment values];
    __block NSMutableArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLTextAlignment LEFT_ALIGNED],
                        [SDLTextAlignment RIGHT_ALIGNED],
                        [SDLTextAlignment CENTERED]] mutableCopy];
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