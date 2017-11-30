//
//  SDLIgnitionStableStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLIgnitionStableStatus.h"

QuickSpecBegin(SDLIgnitionStableStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLIgnitionStableStatusNotStable).to(equal(@"IGNITION_SWITCH_NOT_STABLE"));
        expect(SDLIgnitionStableStatusStable).to(equal(@"IGNITION_SWITCH_STABLE"));
        expect(SDLIgnitionStableStatusMissingFromTransmitter).to(equal(@"MISSING_FROM_TRANSMITTER"));
    });
});

QuickSpecEnd
