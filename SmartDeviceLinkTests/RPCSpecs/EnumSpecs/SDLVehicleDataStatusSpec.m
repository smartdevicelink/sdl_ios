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
        expect(SDLVehicleDataStatusNoDataExists).to(equal(@"NO_DATA_EXISTS"));
        expect(SDLVehicleDataStatusOff).to(equal(@"OFF"));
        expect(SDLVehicleDataStatusOn).to(equal(@"ON"));
    });
});

QuickSpecEnd
