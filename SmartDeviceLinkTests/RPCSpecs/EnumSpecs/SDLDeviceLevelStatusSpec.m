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
        expect(SDLDeviceLevelStatusZeroLevelBars).to(equal(@"ZERO_LEVEL_BARS"));
        expect(SDLDeviceLevelStatusOneLevelBars).to(equal(@"ONE_LEVEL_BARS"));
        expect(SDLDeviceLevelStatusTwoLevelBars).to(equal(@"TWO_LEVEL_BARS"));
        expect(SDLDeviceLevelStatusThreeLevelBars).to(equal(@"THREE_LEVEL_BARS"));
        expect(SDLDeviceLevelStatusFourLevelBars).to(equal(@"FOUR_LEVEL_BARS"));
        expect(SDLDeviceLevelStatusNotProvided).to(equal(@"NOT_PROVIDED"));
    });
});

QuickSpecEnd
