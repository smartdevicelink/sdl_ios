//
//  SDLIgnitionStableStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLIgnitionStableStatus.h"

QuickSpecBegin(SDLIgnitionStableStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLIgnitionStableStatus IGNITION_SWITCH_NOT_STABLE].value).to(equal(@"IGNITION_SWITCH_NOT_STABLE"));
        expect([SDLIgnitionStableStatus IGNITION_SWITCH_STABLE].value).to(equal(@"IGNITION_SWITCH_STABLE"));
        expect([SDLIgnitionStableStatus MISSING_FROM_TRANSMITTER].value).to(equal(@"MISSING_FROM_TRANSMITTER"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLIgnitionStableStatus valueOf:@"IGNITION_SWITCH_NOT_STABLE"]).to(equal([SDLIgnitionStableStatus IGNITION_SWITCH_NOT_STABLE]));
        expect([SDLIgnitionStableStatus valueOf:@"IGNITION_SWITCH_STABLE"]).to(equal([SDLIgnitionStableStatus IGNITION_SWITCH_STABLE]));
        expect([SDLIgnitionStableStatus valueOf:@"MISSING_FROM_TRANSMITTER"]).to(equal([SDLIgnitionStableStatus MISSING_FROM_TRANSMITTER]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLIgnitionStableStatus valueOf:nil]).to(beNil());
        expect([SDLIgnitionStableStatus valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLIgnitionStableStatus values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLIgnitionStableStatus IGNITION_SWITCH_NOT_STABLE],
                        [SDLIgnitionStableStatus IGNITION_SWITCH_STABLE],
                        [SDLIgnitionStableStatus MISSING_FROM_TRANSMITTER]] copy];
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
