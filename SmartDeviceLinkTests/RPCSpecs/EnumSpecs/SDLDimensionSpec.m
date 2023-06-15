//
//  SDLDimensionSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLDimension.h"

QuickSpecBegin(SDLDimensionSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLDimensionNoFix).to(equal(@"NO_FIX"));
        expect(SDLDimension2D).to(equal(@"2D"));
        expect(SDLDimension3D).to(equal(@"3D"));
    });
});

QuickSpecEnd
