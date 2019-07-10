//
//  SDLSupportedSeatSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSupportedSeat.h"

QuickSpecBegin(SDLSupportedSeatSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLSupportedSeatDriver).to(equal(@"DRIVER"));
        expect(SDLSupportedSeatFrontPassenger).to(equal(@"FRONT_PASSENGER"));
    });
});

QuickSpecEnd
