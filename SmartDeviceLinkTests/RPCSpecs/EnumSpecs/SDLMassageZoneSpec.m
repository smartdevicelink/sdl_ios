//
//  SDLMassageZoneSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLMassageZone.h"

QuickSpecBegin(SDLMassageZoneSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLMassageZoneLumbar).to(equal(@"LUMBAR"));
        expect(SDLMassageZoneSeatCushion).to(equal(@"SEAT_CUSHION"));
    });
});

QuickSpecEnd
