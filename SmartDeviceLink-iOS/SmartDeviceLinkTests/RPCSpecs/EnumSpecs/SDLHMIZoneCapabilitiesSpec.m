//
//  SDLHMIZoneCapabilitiesSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/21/15.
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHMIZoneCapabilities.h"

QuickSpecBegin(SDLHmiZoneCapabilitiesSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLHmiZoneCapabilities FRONT].value).to(equal(@"FRONT"));
        expect([SDLHmiZoneCapabilities BACK].value).to(equal(@"BACK"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLHmiZoneCapabilities valueOf:@"FRONT"]).to(equal([SDLHmiZoneCapabilities FRONT]));
        expect([SDLHmiZoneCapabilities valueOf:@"BACK"]).to(equal([SDLHmiZoneCapabilities BACK]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLHmiZoneCapabilities valueOf:nil]).to(beNil());
        expect([SDLHmiZoneCapabilities valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSMutableArray* storedValues = [SDLHmiZoneCapabilities values];
    __block NSMutableArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLHmiZoneCapabilities FRONT],
                        [SDLHmiZoneCapabilities BACK]] mutableCopy];
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