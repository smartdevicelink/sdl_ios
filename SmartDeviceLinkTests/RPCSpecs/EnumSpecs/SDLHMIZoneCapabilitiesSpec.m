//
//  SDLHMIZoneCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHMIZoneCapabilities.h"

QuickSpecBegin(SDLHMIZoneCapabilitiesSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLHMIZoneCapabilitiesFront).to(equal(@"FRONT"));
        expect(SDLHMIZoneCapabilitiesBack).to(equal(@"BACK"));
    });
});

QuickSpecEnd
