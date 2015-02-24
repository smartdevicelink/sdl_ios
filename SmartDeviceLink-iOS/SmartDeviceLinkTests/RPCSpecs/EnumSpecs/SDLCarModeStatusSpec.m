//
//  SDLCarModeStatusSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/21/15.
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCarModeStatus.h"

QuickSpecBegin(SDLCarModeStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLCarModeStatus NORMAL].value).to(equal(@"NORMAL"));
        expect([SDLCarModeStatus FACTORY].value).to(equal(@"FACTORY"));
        expect([SDLCarModeStatus TRANSPORT].value).to(equal(@"TRANSPORT"));
        expect([SDLCarModeStatus CRASH].value).to(equal(@"CRASH"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLCarModeStatus valueOf:@"NORMAL"]).to(equal([SDLCarModeStatus NORMAL]));
        expect([SDLCarModeStatus valueOf:@"FACTORY"]).to(equal([SDLCarModeStatus FACTORY]));
        expect([SDLCarModeStatus valueOf:@"TRANSPORT"]).to(equal([SDLCarModeStatus TRANSPORT]));
        expect([SDLCarModeStatus valueOf:@"CRASH"]).to(equal([SDLCarModeStatus CRASH]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLCarModeStatus valueOf:nil]).to(beNil());
        expect([SDLCarModeStatus valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSMutableArray* storedValues = [SDLCarModeStatus values];
    __block NSMutableArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLCarModeStatus NORMAL],
                        [SDLCarModeStatus FACTORY],
                        [SDLCarModeStatus TRANSPORT],
                        [SDLCarModeStatus CRASH]] mutableCopy];
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

