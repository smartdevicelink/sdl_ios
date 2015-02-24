//
//  SDLKeypressModeSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/21/15.
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLKeypressMode.h"

QuickSpecBegin(SDLKeypressModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLKeypressMode SINGLE_KEYPRESS].value).to(equal(@"SINGLE_KEYPRESS"));
        expect([SDLKeypressMode QUEUE_KEYPRESSES].value).to(equal(@"QUEUE_KEYPRESSES"));
        expect([SDLKeypressMode RESEND_CURRENT_ENTRY].value).to(equal(@"RESEND_CURRENT_ENTRY"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLKeypressMode valueOf:@"SINGLE_KEYPRESS"]).to(equal([SDLKeypressMode SINGLE_KEYPRESS]));
        expect([SDLKeypressMode valueOf:@"QUEUE_KEYPRESSES"]).to(equal([SDLKeypressMode QUEUE_KEYPRESSES]));
        expect([SDLKeypressMode valueOf:@"RESEND_CURRENT_ENTRY"]).to(equal([SDLKeypressMode RESEND_CURRENT_ENTRY]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLKeypressMode valueOf:nil]).to(beNil());
        expect([SDLKeypressMode valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSMutableArray* storedValues = [SDLKeypressMode values];
    __block NSMutableArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLKeypressMode SINGLE_KEYPRESS],
                        [SDLKeypressMode QUEUE_KEYPRESSES],
                        [SDLKeypressMode RESEND_CURRENT_ENTRY]] mutableCopy];
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