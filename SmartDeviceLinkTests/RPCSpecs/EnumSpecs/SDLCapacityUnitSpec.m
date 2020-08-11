//
//  SDLCapacityUnitSpec.m
//  SmartDeviceLinkTests
//

#import <Nimble/Nimble.h>
#import <Quick/Quick.h>

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
