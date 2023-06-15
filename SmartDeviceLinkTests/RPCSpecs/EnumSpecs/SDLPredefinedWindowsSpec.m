//
//  SDLPredefinedWindowsSpec.m
//  SmartDeviceLinkTests

@import Quick;
@import Nimble;
#import "SDLPredefinedWindows.h"

QuickSpecBegin(SDLPredefinedWindowsSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(@(SDLPredefinedWindowsDefaultWindow)).to(equal(0));
        expect(@(SDLPredefinedWindowsPrimaryWidget)).to(equal(1));
    });
});

QuickSpecEnd
