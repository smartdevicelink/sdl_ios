//
//  SDLVehicleDataStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVehicleDataStatus.h"

QuickSpecBegin(SDLVehicleDataStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLVehicleDataStatus NO_DATA_EXISTS].value).to(equal(@"NO_DATA_EXISTS"));
        expect([SDLVehicleDataStatus OFF].value).to(equal(@"OFF"));
        expect([SDLVehicleDataStatus ON].value).to(equal(@"ON"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLVehicleDataStatus valueOf:@"NO_DATA_EXISTS"]).to(equal([SDLVehicleDataStatus NO_DATA_EXISTS]));
        expect([SDLVehicleDataStatus valueOf:@"OFF"]).to(equal([SDLVehicleDataStatus OFF]));
        expect([SDLVehicleDataStatus valueOf:@"ON"]).to(equal([SDLVehicleDataStatus ON]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLVehicleDataStatus valueOf:nil]).to(beNil());
        expect([SDLVehicleDataStatus valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLVehicleDataStatus values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLVehicleDataStatus NO_DATA_EXISTS],
                        [SDLVehicleDataStatus OFF],
                        [SDLVehicleDataStatus ON]] copy];
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