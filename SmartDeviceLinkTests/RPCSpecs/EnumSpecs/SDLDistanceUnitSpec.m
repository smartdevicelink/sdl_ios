//
//  SDLDistanceUnitSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLDistanceUnit.h"

QuickSpecBegin(SDLDistanceUnitSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLDistanceUnitMiles).to(equal(@"MILES"));
        expect(SDLDistanceUnitKilometers).to(equal(@"KILOMETERS"));
    });
});

QuickSpecEnd
