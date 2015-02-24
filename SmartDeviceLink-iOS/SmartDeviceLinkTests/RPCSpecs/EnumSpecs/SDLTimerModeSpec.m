//
//  SDLTimerModeSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/21/15.
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTimerMode.h"

QuickSpecBegin(SDLTimerModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLTimerMode UP].value).to(equal(@"UP"));
        expect([SDLTimerMode DOWN].value).to(equal(@"DOWN"));
        expect([SDLTimerMode NONE].value).to(equal(@"NONE"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLTimerMode valueOf:@"UP"]).to(equal([SDLTimerMode UP]));
        expect([SDLTimerMode valueOf:@"DOWN"]).to(equal([SDLTimerMode DOWN]));
        expect([SDLTimerMode valueOf:@"NONE"]).to(equal([SDLTimerMode NONE]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLTimerMode valueOf:nil]).to(beNil());
        expect([SDLTimerMode valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSMutableArray* storedValues = [SDLTimerMode values];
    __block NSMutableArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLTimerMode UP],
                        [SDLTimerMode DOWN],
                        [SDLTimerMode NONE]] mutableCopy];
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