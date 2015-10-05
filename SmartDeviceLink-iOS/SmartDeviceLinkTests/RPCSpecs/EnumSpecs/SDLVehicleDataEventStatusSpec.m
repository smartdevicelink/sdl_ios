//
//  SDLVehicleDataEventStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVehicleDataEventStatus.h"

QuickSpecBegin(SDLVehicleDataEventStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLVehicleDataEventStatus NO_EVENT].value).to(equal(@"NO_EVENT"));
        expect([SDLVehicleDataEventStatus _NO].value).to(equal(@"NO"));
        expect([SDLVehicleDataEventStatus _YES].value).to(equal(@"YES"));
        expect([SDLVehicleDataEventStatus NOT_SUPPORTED].value).to(equal(@"NOT_SUPPORTED"));
        expect([SDLVehicleDataEventStatus FAULT].value).to(equal(@"FAULT"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLVehicleDataEventStatus valueOf:@"NO_EVENT"]).to(equal([SDLVehicleDataEventStatus NO_EVENT]));
        expect([SDLVehicleDataEventStatus valueOf:@"NO"]).to(equal([SDLVehicleDataEventStatus _NO]));
        expect([SDLVehicleDataEventStatus valueOf:@"YES"]).to(equal([SDLVehicleDataEventStatus _YES]));
        expect([SDLVehicleDataEventStatus valueOf:@"NOT_SUPPORTED"]).to(equal([SDLVehicleDataEventStatus NOT_SUPPORTED]));
        expect([SDLVehicleDataEventStatus valueOf:@"FAULT"]).to(equal([SDLVehicleDataEventStatus FAULT]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLVehicleDataEventStatus valueOf:nil]).to(beNil());
        expect([SDLVehicleDataEventStatus valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLVehicleDataEventStatus values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLVehicleDataEventStatus NO_EVENT],
                        [SDLVehicleDataEventStatus _NO],
                        [SDLVehicleDataEventStatus _YES],
                        [SDLVehicleDataEventStatus NOT_SUPPORTED],
                        [SDLVehicleDataEventStatus FAULT]] copy];
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