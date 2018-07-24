//
//  SDLDistanceUnitSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDistanceUnit.h"

QuickSpecBegin(SDLDistanceUnitSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLDistanceUnitMiles).to(equal(@"MILES"));
        expect(SDLDistanceUnitKms).to(equal(@"KILOMETERS"));
    });
});

QuickSpecEnd
