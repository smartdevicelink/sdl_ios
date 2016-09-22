//
//  SDLPowerModeQualificationStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPowerModeQualificationStatus.h"

QuickSpecBegin(SDLPowerModeQualificationStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLPowerModeQualificationStatusPowerModeUndefined).to(equal(@"POWER_MODE_UNDEFINED"));
        expect(SDLPowerModeQualificationStatusPowerModeEvaluationInProgress).to(equal(@"POWER_MODE_EVALUATION_IN_PROGRESS"));
        expect(SDLPowerModeQualificationStatusNotDefined).to(equal(@"NOT_DEFINED"));
        expect(SDLPowerModeQualificationStatusPowerModeOk).to(equal(@"POWER_MODE_OK"));
    });
});

QuickSpecEnd
