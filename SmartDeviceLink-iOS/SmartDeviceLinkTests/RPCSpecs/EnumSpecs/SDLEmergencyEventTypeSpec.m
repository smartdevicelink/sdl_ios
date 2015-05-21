//
//  SDLEmergencyEventTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLEmergencyEventType.h"

QuickSpecBegin(SDLEmergencyEventTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLEmergencyEventType NO_EVENT].value).to(equal(@"NO_EVENT"));
        expect([SDLEmergencyEventType FRONTAL].value).to(equal(@"FRONTAL"));
        expect([SDLEmergencyEventType SIDE].value).to(equal(@"SIDE"));
        expect([SDLEmergencyEventType REAR].value).to(equal(@"REAR"));
        expect([SDLEmergencyEventType ROLLOVER].value).to(equal(@"ROLLOVER"));
        expect([SDLEmergencyEventType NOT_SUPPORTED].value).to(equal(@"NOT_SUPPORTED"));
        expect([SDLEmergencyEventType FAULT].value).to(equal(@"FAULT"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLEmergencyEventType valueOf:@"NO_EVENT"]).to(equal([SDLEmergencyEventType NO_EVENT]));
        expect([SDLEmergencyEventType valueOf:@"FRONTAL"]).to(equal([SDLEmergencyEventType FRONTAL]));
        expect([SDLEmergencyEventType valueOf:@"SIDE"]).to(equal([SDLEmergencyEventType SIDE]));
        expect([SDLEmergencyEventType valueOf:@"REAR"]).to(equal([SDLEmergencyEventType REAR]));
        expect([SDLEmergencyEventType valueOf:@"ROLLOVER"]).to(equal([SDLEmergencyEventType ROLLOVER]));
        expect([SDLEmergencyEventType valueOf:@"NOT_SUPPORTED"]).to(equal([SDLEmergencyEventType NOT_SUPPORTED]));
        expect([SDLEmergencyEventType valueOf:@"FAULT"]).to(equal([SDLEmergencyEventType FAULT]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLEmergencyEventType valueOf:nil]).to(beNil());
        expect([SDLEmergencyEventType valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLEmergencyEventType values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLEmergencyEventType NO_EVENT],
                        [SDLEmergencyEventType FRONTAL],
                        [SDLEmergencyEventType SIDE],
                        [SDLEmergencyEventType REAR],
                        [SDLEmergencyEventType ROLLOVER],
                        [SDLEmergencyEventType NOT_SUPPORTED],
                        [SDLEmergencyEventType FAULT]] copy];
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