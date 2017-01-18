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
        expect(SDLVehicleDataResultCodeSuccess).to(equal(@"SUCCESS"));
        expect(SDLVehicleDataResultCodeTruncatedData).to(equal(@"TRUNCATED_DATA"));
        expect(SDLVehicleDataResultCodeDisallowed).to(equal(@"DISALLOWED"));
        expect(SDLVehicleDataResultCodeUserDisallowed).to(equal(@"USER_DISALLOWED"));
        expect(SDLVehicleDataResultCodeInvalidId).to(equal(@"INVALID_ID"));
        expect(SDLVehicleDataResultCodeVehicleDataNotAvailable).to(equal(@"VEHICLE_DATA_NOT_AVAILABLE"));
        expect(SDLVehicleDataResultCodeDataAlreadySubscribed).to(equal(@"DATA_ALREADY_SUBSCRIBED"));
        expect(SDLVehicleDataResultCodeDataNotSubscribed).to(equal(@"DATA_NOT_SUBSCRIBED"));
        expect(SDLVehicleDataResultCodeIgnored).to(equal(@"IGNORED"));
    });
});

QuickSpecEnd
