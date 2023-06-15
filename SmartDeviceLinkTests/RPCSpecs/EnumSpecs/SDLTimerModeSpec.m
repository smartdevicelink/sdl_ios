//
//  SDLTimerModeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLTimerMode.h"

QuickSpecBegin(SDLTimerModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLTimerModeUp).to(equal(@"UP"));
        expect(SDLTimerModeDown).to(equal(@"DOWN"));
        expect(SDLTimerModeNone).to(equal(@"NONE"));
    });
});

QuickSpecEnd
