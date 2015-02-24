//
//  SDLIgnitionStatusSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/21/15.
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLIgnitionStatus.h"

QuickSpecBegin(SDLIgnitionStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLIgnitionStatus UNKNOWN].value).to(equal(@"UNKNOWN"));
        expect([SDLIgnitionStatus OFF].value).to(equal(@"OFF"));
        expect([SDLIgnitionStatus ACCESSORY].value).to(equal(@"ACCESSORY"));
        expect([SDLIgnitionStatus RUN].value).to(equal(@"RUN"));
        expect([SDLIgnitionStatus START].value).to(equal(@"START"));
        expect([SDLIgnitionStatus INVALID].value).to(equal(@"INVALID"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLIgnitionStatus valueOf:@"UNKNOWN"]).to(equal([SDLIgnitionStatus UNKNOWN]));
        expect([SDLIgnitionStatus valueOf:@"OFF"]).to(equal([SDLIgnitionStatus OFF]));
        expect([SDLIgnitionStatus valueOf:@"ACCESSORY"]).to(equal([SDLIgnitionStatus ACCESSORY]));
        expect([SDLIgnitionStatus valueOf:@"RUN"]).to(equal([SDLIgnitionStatus RUN]));
        expect([SDLIgnitionStatus valueOf:@"START"]).to(equal([SDLIgnitionStatus START]));
        expect([SDLIgnitionStatus valueOf:@"INVALID"]).to(equal([SDLIgnitionStatus INVALID]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLIgnitionStatus valueOf:nil]).to(beNil());
        expect([SDLIgnitionStatus valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSMutableArray* storedValues = [SDLIgnitionStatus values];
    __block NSMutableArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLIgnitionStatus UNKNOWN],
                        [SDLIgnitionStatus OFF],
                        [SDLIgnitionStatus ACCESSORY],
                        [SDLIgnitionStatus RUN],
                        [SDLIgnitionStatus START],
                        [SDLIgnitionStatus INVALID]] mutableCopy];
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
