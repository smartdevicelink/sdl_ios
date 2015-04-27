//
//  SDLVehicleDataNotificationStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVehicleDataNotificationStatus.h"

QuickSpecBegin(SDLVehicleDataNotificationStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLVehicleDataNotificationStatus NOT_SUPPORTED].value).to(equal(@"NOT_SUPPORTED"));
        expect([SDLVehicleDataNotificationStatus NORMAL].value).to(equal(@"NORMAL"));
        expect([SDLVehicleDataNotificationStatus ACTIVE].value).to(equal(@"ACTIVE"));
        expect([SDLVehicleDataNotificationStatus NOT_USED].value).to(equal(@"NOT_USED"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLVehicleDataNotificationStatus valueOf:@"NOT_SUPPORTED"]).to(equal([SDLVehicleDataNotificationStatus NOT_SUPPORTED]));
        expect([SDLVehicleDataNotificationStatus valueOf:@"NORMAL"]).to(equal([SDLVehicleDataNotificationStatus NORMAL]));
        expect([SDLVehicleDataNotificationStatus valueOf:@"ACTIVE"]).to(equal([SDLVehicleDataNotificationStatus ACTIVE]));
        expect([SDLVehicleDataNotificationStatus valueOf:@"NOT_USED"]).to(equal([SDLVehicleDataNotificationStatus NOT_USED]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLVehicleDataNotificationStatus valueOf:nil]).to(beNil());
        expect([SDLVehicleDataNotificationStatus valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLVehicleDataNotificationStatus values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLVehicleDataNotificationStatus NOT_SUPPORTED],
                        [SDLVehicleDataNotificationStatus NORMAL],
                        [SDLVehicleDataNotificationStatus ACTIVE],
                        [SDLVehicleDataNotificationStatus NOT_USED]] copy];
        
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