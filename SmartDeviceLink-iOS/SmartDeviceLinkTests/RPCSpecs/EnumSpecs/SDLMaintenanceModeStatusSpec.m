//
//  SDLMaintenanceModeStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLMaintenanceModeStatus.h"

QuickSpecBegin(SDLMaintenanceModeStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLMaintenanceModeStatus NORMAL].value).to(equal(@"NORMAL"));
        expect([SDLMaintenanceModeStatus NEAR].value).to(equal(@"NEAR"));
        expect([SDLMaintenanceModeStatus ACTIVE].value).to(equal(@"ACTIVE"));
        expect([SDLMaintenanceModeStatus FEATURE_NOT_PRESENT].value).to(equal(@"FEATURE_NOT_PRESENT"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLMaintenanceModeStatus valueOf:@"NORMAL"]).to(equal([SDLMaintenanceModeStatus NORMAL]));
        expect([SDLMaintenanceModeStatus valueOf:@"NEAR"]).to(equal([SDLMaintenanceModeStatus NEAR]));
        expect([SDLMaintenanceModeStatus valueOf:@"ACTIVE"]).to(equal([SDLMaintenanceModeStatus ACTIVE]));
        expect([SDLMaintenanceModeStatus valueOf:@"FEATURE_NOT_PRESENT"]).to(equal([SDLMaintenanceModeStatus FEATURE_NOT_PRESENT]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLMaintenanceModeStatus valueOf:nil]).to(beNil());
        expect([SDLMaintenanceModeStatus valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLMaintenanceModeStatus values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLMaintenanceModeStatus NORMAL],
                        [SDLMaintenanceModeStatus NEAR],
                        [SDLMaintenanceModeStatus ACTIVE],
                        [SDLMaintenanceModeStatus FEATURE_NOT_PRESENT]] copy];
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
