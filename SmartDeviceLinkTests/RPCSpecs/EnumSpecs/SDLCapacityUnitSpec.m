//
//  SDLCapacityUnitSpec.m
//  SmartDeviceLinkTests
//

@import Quick;
@import Nimble;

#import "SDLCapacityUnit.h"

QuickSpecBegin(SDLCapacityUnitSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLCapacityUnitKilograms).to(equal(@"KILOGRAMS"));
        expect(SDLCapacityUnitKilowatthours).to(equal(@"KILOWATTHOURS"));
        expect(SDLCapacityUnitLiters).to(equal(@"LITERS"));
    });
});

QuickSpecEnd
