//
//  SDLFuelCutoffStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFuelCutoffStatus.h"

QuickSpecBegin(SDLFuelCutoffStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLFuelCutoffStatus TERMINATE_FUEL].value).to(equal(@"TERMINATE_FUEL"));
        expect([SDLFuelCutoffStatus NORMAL_OPERATION].value).to(equal(@"NORMAL_OPERATION"));
        expect([SDLFuelCutoffStatus FAULT].value).to(equal(@"FAULT"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLFuelCutoffStatus valueOf:@"TERMINATE_FUEL"]).to(equal([SDLFuelCutoffStatus TERMINATE_FUEL]));
        expect([SDLFuelCutoffStatus valueOf:@"NORMAL_OPERATION"]).to(equal([SDLFuelCutoffStatus NORMAL_OPERATION]));
        expect([SDLFuelCutoffStatus valueOf:@"FAULT"]).to(equal([SDLFuelCutoffStatus FAULT]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLFuelCutoffStatus valueOf:nil]).to(beNil());
        expect([SDLFuelCutoffStatus valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLFuelCutoffStatus values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLFuelCutoffStatus TERMINATE_FUEL],
                        [SDLFuelCutoffStatus NORMAL_OPERATION],
                        [SDLFuelCutoffStatus FAULT]] copy];
    });
    
    it(@"Should contain all defined enum values", ^ {
        for (int i = 0; i < definedValues.count; i++) {
            expect(storedValues).to(contain(definedValues[i]));
        }
    });
    
    it(@"Should contain only defined enum values", ^ {
        for (int i = 0; i < storedValues.count; i++) {
            expect(definedValues).to(contain(storedValues[i]));
        }
    });
});

QuickSpecEnd
