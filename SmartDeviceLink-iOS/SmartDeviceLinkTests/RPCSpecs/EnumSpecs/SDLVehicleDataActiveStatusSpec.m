//
//  SDLVehicleDataActiveStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVehicleDataActiveStatus.h"

QuickSpecBegin(SDLVehicleDataActiveStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLVehicleDataActiveStatus INACTIVE_NOT_CONFIRMED].value).to(equal(@"INACTIVE_NOT_CONFIRMED"));
        expect([SDLVehicleDataActiveStatus INACTIVE_CONFIRMED].value).to(equal(@"INACTIVE_CONFIRMED"));
        expect([SDLVehicleDataActiveStatus ACTIVE_NOT_CONFIRMED].value).to(equal(@"ACTIVE_NOT_CONFIRMED"));
        expect([SDLVehicleDataActiveStatus ACTIVE_CONFIRMED].value).to(equal(@"ACTIVE_CONFIRMED"));
        expect([SDLVehicleDataActiveStatus FAULT].value).to(equal(@"FAULT"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLVehicleDataActiveStatus valueOf:@"INACTIVE_NOT_CONFIRMED"]).to(equal([SDLVehicleDataActiveStatus INACTIVE_NOT_CONFIRMED]));
        expect([SDLVehicleDataActiveStatus valueOf:@"INACTIVE_CONFIRMED"]).to(equal([SDLVehicleDataActiveStatus INACTIVE_CONFIRMED]));
        expect([SDLVehicleDataActiveStatus valueOf:@"ACTIVE_NOT_CONFIRMED"]).to(equal([SDLVehicleDataActiveStatus ACTIVE_NOT_CONFIRMED]));
        expect([SDLVehicleDataActiveStatus valueOf:@"ACTIVE_CONFIRMED"]).to(equal([SDLVehicleDataActiveStatus ACTIVE_CONFIRMED]));
        expect([SDLVehicleDataActiveStatus valueOf:@"FAULT"]).to(equal([SDLVehicleDataActiveStatus FAULT]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLVehicleDataActiveStatus valueOf:nil]).to(beNil());
        expect([SDLVehicleDataActiveStatus valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLVehicleDataActiveStatus values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLVehicleDataActiveStatus INACTIVE_NOT_CONFIRMED],
                        [SDLVehicleDataActiveStatus INACTIVE_CONFIRMED],
                        [SDLVehicleDataActiveStatus ACTIVE_NOT_CONFIRMED],
                        [SDLVehicleDataActiveStatus ACTIVE_CONFIRMED],
                        [SDLVehicleDataActiveStatus FAULT]] copy];
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