//
//  SDLPowerModeStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPowerModeStatus.h"

QuickSpecBegin(SDLPowerModeStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLPowerModeStatus KEY_OUT].value).to(equal(@"KEY_OUT"));
        expect([SDLPowerModeStatus KEY_RECENTLY_OUT].value).to(equal(@"KEY_RECENTLY_OUT"));
        expect([SDLPowerModeStatus KEY_APPROVED_0].value).to(equal(@"KEY_APPROVED_0"));
        expect([SDLPowerModeStatus POST_ACCESORY_0].value).to(equal(@"POST_ACCESORY_0"));
        expect([SDLPowerModeStatus ACCESORY_1].value).to(equal(@"ACCESORY_1"));
        expect([SDLPowerModeStatus POST_IGNITION_1].value).to(equal(@"POST_IGNITION_1"));
        expect([SDLPowerModeStatus IGNITION_ON_2].value).to(equal(@"IGNITION_ON_2"));
        expect([SDLPowerModeStatus RUNNING_2].value).to(equal(@"RUNNING_2"));
        expect([SDLPowerModeStatus CRANK_3].value).to(equal(@"CRANK_3"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLPowerModeStatus valueOf:@"KEY_OUT"]).to(equal([SDLPowerModeStatus KEY_OUT]));
        expect([SDLPowerModeStatus valueOf:@"KEY_RECENTLY_OUT"]).to(equal([SDLPowerModeStatus KEY_RECENTLY_OUT]));
        expect([SDLPowerModeStatus valueOf:@"KEY_APPROVED_0"]).to(equal([SDLPowerModeStatus KEY_APPROVED_0]));
        expect([SDLPowerModeStatus valueOf:@"POST_ACCESORY_0"]).to(equal([SDLPowerModeStatus POST_ACCESORY_0]));
        expect([SDLPowerModeStatus valueOf:@"ACCESORY_1"]).to(equal([SDLPowerModeStatus ACCESORY_1]));
        expect([SDLPowerModeStatus valueOf:@"POST_IGNITION_1"]).to(equal([SDLPowerModeStatus POST_IGNITION_1]));
        expect([SDLPowerModeStatus valueOf:@"IGNITION_ON_2"]).to(equal([SDLPowerModeStatus IGNITION_ON_2]));
        expect([SDLPowerModeStatus valueOf:@"RUNNING_2"]).to(equal([SDLPowerModeStatus RUNNING_2]));
        expect([SDLPowerModeStatus valueOf:@"CRANK_3"]).to(equal([SDLPowerModeStatus CRANK_3]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLPowerModeStatus valueOf:nil]).to(beNil());
        expect([SDLPowerModeStatus valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLPowerModeStatus values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLPowerModeStatus KEY_OUT],
                        [SDLPowerModeStatus KEY_RECENTLY_OUT],
                        [SDLPowerModeStatus KEY_APPROVED_0],
                        [SDLPowerModeStatus POST_ACCESORY_0],
                        [SDLPowerModeStatus ACCESORY_1],
                        [SDLPowerModeStatus POST_IGNITION_1],
                        [SDLPowerModeStatus IGNITION_ON_2],
                        [SDLPowerModeStatus RUNNING_2],
                        [SDLPowerModeStatus CRANK_3]] copy];
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