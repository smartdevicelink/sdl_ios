//
//  SDLCharacterSetSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/21/15.
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCharacterSet.h"

QuickSpecBegin(SDLCharacterSetSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLCharacterSet TYPE2SET].value).to(equal(@"TYPE2SET"));
        expect([SDLCharacterSet TYPE5SET].value).to(equal(@"TYPE5SET"));
        expect([SDLCharacterSet CID1SET].value).to(equal(@"CID1SET"));
        expect([SDLCharacterSet CID2SET].value).to(equal(@"CID2SET"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLCharacterSet valueOf:@"TYPE2SET"]).to(equal([SDLCharacterSet TYPE2SET]));
        expect([SDLCharacterSet valueOf:@"TYPE5SET"]).to(equal([SDLCharacterSet TYPE5SET]));
        expect([SDLCharacterSet valueOf:@"CID1SET"]).to(equal([SDLCharacterSet CID1SET]));
        expect([SDLCharacterSet valueOf:@"CID2SET"]).to(equal([SDLCharacterSet CID2SET]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLCharacterSet valueOf:nil]).to(beNil());
        expect([SDLCharacterSet valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSMutableArray* storedValues = [SDLCharacterSet values];
    __block NSMutableArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLCharacterSet TYPE2SET],
                        [SDLCharacterSet TYPE5SET],
                        [SDLCharacterSet CID1SET],
                        [SDLCharacterSet CID2SET]] mutableCopy];
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