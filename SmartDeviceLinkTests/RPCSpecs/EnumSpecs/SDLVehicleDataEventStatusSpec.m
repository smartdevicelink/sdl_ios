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
        expect(SDLVehicleDataEventStatusNoEvent).to(equal(@"NO_EVENT"));
        expect(SDLVehicleDataEventStatusNo).to(equal(@"NO"));
        expect(SDLVehicleDataEventStatusYes).to(equal(@"YES"));
        expect(SDLVehicleDataEventStatusNotSupported).to(equal(@"NOT_SUPPORTED"));
        expect(SDLVehicleDataEventStatusFault).to(equal(@"FAULT"));
    });
});

QuickSpecEnd
