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
        expect([SDLPowerModeQualificationStatus POWER_MODE_UNDEFINED].value).to(equal(@"POWER_MODE_UNDEFINED"));
        expect([SDLPowerModeQualificationStatus POWER_MODE_EVALUATION_IN_PROGRESS].value).to(equal(@"POWER_MODE_EVALUATION_IN_PROGRESS"));
        expect([SDLPowerModeQualificationStatus NOT_DEFINED].value).to(equal(@"NOT_DEFINED"));
        expect([SDLPowerModeQualificationStatus POWER_MODE_OK].value).to(equal(@"POWER_MODE_OK"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLPowerModeQualificationStatus valueOf:@"POWER_MODE_UNDEFINED"]).to(equal([SDLPowerModeQualificationStatus POWER_MODE_UNDEFINED]));
        expect([SDLPowerModeQualificationStatus valueOf:@"POWER_MODE_EVALUATION_IN_PROGRESS"]).to(equal([SDLPowerModeQualificationStatus POWER_MODE_EVALUATION_IN_PROGRESS]));
        expect([SDLPowerModeQualificationStatus valueOf:@"NOT_DEFINED"]).to(equal([SDLPowerModeQualificationStatus NOT_DEFINED]));
        expect([SDLPowerModeQualificationStatus valueOf:@"POWER_MODE_OK"]).to(equal([SDLPowerModeQualificationStatus POWER_MODE_OK]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLPowerModeQualificationStatus valueOf:nil]).to(beNil());
        expect([SDLPowerModeQualificationStatus valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLPowerModeQualificationStatus values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLPowerModeQualificationStatus POWER_MODE_UNDEFINED],
                        [SDLPowerModeQualificationStatus POWER_MODE_EVALUATION_IN_PROGRESS],
                        [SDLPowerModeQualificationStatus NOT_DEFINED],
                        [SDLPowerModeQualificationStatus POWER_MODE_OK]] copy];
    });
    
    it(@"Should contain all defined enum values", ^ {
        for (int i = 0; i < definedValues.count; i++) {
            expect(storedValues).to(contain(definedValues[i]));
        }
    });
    
    it(@"Should contain only defined enum values", ^ {
        for (int i = 0; i < storedValues.count; i++) {
            expect(definedValues).to(contain(storedValues[i]));
        }
    });
});

QuickSpecEnd