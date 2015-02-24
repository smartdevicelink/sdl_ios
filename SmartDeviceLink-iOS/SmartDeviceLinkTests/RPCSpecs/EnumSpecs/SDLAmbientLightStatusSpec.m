//
//  SDLAmbientLightStatusSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/20/15.
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAmbientLightStatus.h"

QuickSpecBegin(SDLAmbientLightStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLAmbientLightStatus NIGHT].value).to(equal(@"NIGHT"));
        expect([SDLAmbientLightStatus TWILIGHT_1].value).to(equal(@"TWILIGHT_1"));
        expect([SDLAmbientLightStatus TWILIGHT_2].value).to(equal(@"TWILIGHT_2"));
        expect([SDLAmbientLightStatus TWILIGHT_3].value).to(equal(@"TWILIGHT_3"));
        expect([SDLAmbientLightStatus TWILIGHT_4].value).to(equal(@"TWILIGHT_4"));
        expect([SDLAmbientLightStatus DAY].value).to(equal(@"DAY"));
        expect([SDLAmbientLightStatus UNKNOWN].value).to(equal(@"UNKNOWN"));
        expect([SDLAmbientLightStatus INVALID].value).to(equal(@"INVALID"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLAmbientLightStatus valueOf:@"NIGHT"]).to(equal([SDLAmbientLightStatus NIGHT]));
        expect([SDLAmbientLightStatus valueOf:@"TWILIGHT_1"]).to(equal([SDLAmbientLightStatus TWILIGHT_1]));
        expect([SDLAmbientLightStatus valueOf:@"TWILIGHT_2"]).to(equal([SDLAmbientLightStatus TWILIGHT_2]));
        expect([SDLAmbientLightStatus valueOf:@"TWILIGHT_3"]).to(equal([SDLAmbientLightStatus TWILIGHT_3]));
        expect([SDLAmbientLightStatus valueOf:@"TWILIGHT_4"]).to(equal([SDLAmbientLightStatus TWILIGHT_4]));
        expect([SDLAmbientLightStatus valueOf:@"DAY"]).to(equal([SDLAmbientLightStatus DAY]));
        expect([SDLAmbientLightStatus valueOf:@"UNKNOWN"]).to(equal([SDLAmbientLightStatus UNKNOWN]));
        expect([SDLAmbientLightStatus valueOf:@"INVALID"]).to(equal([SDLAmbientLightStatus INVALID]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLAmbientLightStatus valueOf:nil]).to(beNil());
        expect([SDLAmbientLightStatus valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSMutableArray* storedValues = [SDLAmbientLightStatus values];
    __block NSMutableArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLAmbientLightStatus NIGHT],
                           [SDLAmbientLightStatus TWILIGHT_1],
                           [SDLAmbientLightStatus TWILIGHT_2],
                           [SDLAmbientLightStatus TWILIGHT_3],
                           [SDLAmbientLightStatus TWILIGHT_4],
                           [SDLAmbientLightStatus DAY],
                           [SDLAmbientLightStatus UNKNOWN],
                           [SDLAmbientLightStatus INVALID]] mutableCopy];
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