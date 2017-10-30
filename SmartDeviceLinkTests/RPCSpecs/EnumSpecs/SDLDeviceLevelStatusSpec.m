//
//  SDLDeviceLevelStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeviceLevelStatus.h"

QuickSpecBegin(SDLDeviceLevelStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLDeviceLevelStatusZeroBars).to(equal(@"ZERO_LEVEL_BARS"));
        expect(SDLDeviceLevelStatusOneBar).to(equal(@"ONE_LEVEL_BARS"));
        expect(SDLDeviceLevelStatusTwoBars).to(equal(@"TWO_LEVEL_BARS"));
        expect(SDLDeviceLevelStatusThreeBars).to(equal(@"THREE_LEVEL_BARS"));
        expect(SDLDeviceLevelStatusFourBars).to(equal(@"FOUR_LEVEL_BARS"));
        expect(SDLDeviceLevelStatusNotProvided).to(equal(@"NOT_PROVIDED"));
    });
});

QuickSpecEnd
