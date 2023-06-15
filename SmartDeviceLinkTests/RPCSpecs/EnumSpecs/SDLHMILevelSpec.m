//
//  SDLHMILevelSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLHMILevel.h"

QuickSpecBegin(SDLHMILevelSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLHMILevelFull).to(equal(@"FULL"));
        expect(SDLHMILevelLimited).to(equal(@"LIMITED"));
        expect(SDLHMILevelBackground).to(equal(@"BACKGROUND"));
        expect(SDLHMILevelNone).to(equal(@"NONE"));
    });
});

QuickSpecEnd
