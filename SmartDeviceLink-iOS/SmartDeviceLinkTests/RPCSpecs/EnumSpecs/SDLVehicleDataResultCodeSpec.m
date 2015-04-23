//
//  SDLVehicleDataResultCodeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVehicleDataResultCode.h"

QuickSpecBegin(SDLVehicleDataResultCodeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLVehicleDataResultCode SUCCESS].value).to(equal(@"SUCCESS"));
        expect([SDLVehicleDataResultCode TRUNCATED_DATA].value).to(equal(@"TRUNCATED_DATA"));
        expect([SDLVehicleDataResultCode DISALLOWED].value).to(equal(@"DISALLOWED"));
        expect([SDLVehicleDataResultCode USER_DISALLOWED].value).to(equal(@"USER_DISALLOWED"));
        expect([SDLVehicleDataResultCode INVALID_ID].value).to(equal(@"INVALID_ID"));
        expect([SDLVehicleDataResultCode VEHICLE_DATA_NOT_AVAILABLE].value).to(equal(@"VEHICLE_DATA_NOT_AVAILABLE"));
        expect([SDLVehicleDataResultCode DATA_ALREADY_SUBSCRIBED].value).to(equal(@"DATA_ALREADY_SUBSCRIBED"));
        expect([SDLVehicleDataResultCode DATA_NOT_SUBSCRIBED].value).to(equal(@"DATA_NOT_SUBSCRIBED"));
        expect([SDLVehicleDataResultCode IGNORED].value).to(equal(@"IGNORED"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLVehicleDataResultCode valueOf:@"SUCCESS"]).to(equal([SDLVehicleDataResultCode SUCCESS]));
        expect([SDLVehicleDataResultCode valueOf:@"TRUNCATED_DATA"]).to(equal([SDLVehicleDataResultCode TRUNCATED_DATA]));
        expect([SDLVehicleDataResultCode valueOf:@"DISALLOWED"]).to(equal([SDLVehicleDataResultCode DISALLOWED]));
        expect([SDLVehicleDataResultCode valueOf:@"USER_DISALLOWED"]).to(equal([SDLVehicleDataResultCode USER_DISALLOWED]));
        expect([SDLVehicleDataResultCode valueOf:@"INVALID_ID"]).to(equal([SDLVehicleDataResultCode INVALID_ID]));
        expect([SDLVehicleDataResultCode valueOf:@"VEHICLE_DATA_NOT_AVAILABLE"]).to(equal([SDLVehicleDataResultCode VEHICLE_DATA_NOT_AVAILABLE]));
        expect([SDLVehicleDataResultCode valueOf:@"DATA_ALREADY_SUBSCRIBED"]).to(equal([SDLVehicleDataResultCode DATA_ALREADY_SUBSCRIBED]));
        expect([SDLVehicleDataResultCode valueOf:@"DATA_NOT_SUBSCRIBED"]).to(equal([SDLVehicleDataResultCode DATA_NOT_SUBSCRIBED]));
        expect([SDLVehicleDataResultCode valueOf:@"IGNORED"]).to(equal([SDLVehicleDataResultCode IGNORED]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLVehicleDataResultCode valueOf:nil]).to(beNil());
        expect([SDLVehicleDataResultCode valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLVehicleDataResultCode values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLVehicleDataResultCode SUCCESS],
                        [SDLVehicleDataResultCode TRUNCATED_DATA],
                        [SDLVehicleDataResultCode DISALLOWED],
                        [SDLVehicleDataResultCode USER_DISALLOWED],
                        [SDLVehicleDataResultCode INVALID_ID],
                        [SDLVehicleDataResultCode VEHICLE_DATA_NOT_AVAILABLE],
                        [SDLVehicleDataResultCode DATA_ALREADY_SUBSCRIBED],
                        [SDLVehicleDataResultCode DATA_NOT_SUBSCRIBED],
                        [SDLVehicleDataResultCode IGNORED]] copy];
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