//
//  SDLFuelCutoffStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFuelCutoffStatus.h"

QuickSpecBegin(SDLFuelCutoffStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLFuelCutoffStatusTerminateFuel).to(equal(@"TERMINATE_FUEL"));
        expect(SDLFuelCutoffStatusNormalOperation).to(equal(@"NORMAL_OPERATION"));
        expect(SDLFuelCutoffStatusFault).to(equal(@"FAULT"));
    });
});

QuickSpecEnd
