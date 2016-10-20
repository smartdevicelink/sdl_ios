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
        expect(SDLVehicleDataActiveStatusInactiveNotConfirmed).to(equal(@"INACTIVE_NOT_CONFIRMED"));
        expect(SDLVehicleDataActiveStatusInactiveConfirmed).to(equal(@"INACTIVE_CONFIRMED"));
        expect(SDLVehicleDataActiveStatusActiveNotConfirmed).to(equal(@"ACTIVE_NOT_CONFIRMED"));
        expect(SDLVehicleDataActiveStatusActiveConfirmed).to(equal(@"ACTIVE_CONFIRMED"));
        expect(SDLVehicleDataActiveStatusFault).to(equal(@"FAULT"));
    });
});

QuickSpecEnd
