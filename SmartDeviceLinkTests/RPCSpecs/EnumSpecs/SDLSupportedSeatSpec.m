//
//  SDLSupportedSeatSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLSupportedSeat.h"

QuickSpecBegin(SDLSupportedSeatSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(SDLSupportedSeatDriver).to(equal(@"DRIVER"));
        expect(SDLSupportedSeatFrontPassenger).to(equal(@"FRONT_PASSENGER"));
#pragma clang diagnostic pop
    });
});

QuickSpecEnd
