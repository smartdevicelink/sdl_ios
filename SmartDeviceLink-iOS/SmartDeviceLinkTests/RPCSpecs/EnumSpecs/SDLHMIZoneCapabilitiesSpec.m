//
//  SDLHMIZoneCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHMIZoneCapabilities.h"

QuickSpecBegin(SDLHmiZoneCapabilitiesSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLHMIZoneCapabilities FRONT].value).to(equal(@"FRONT"));
        expect([SDLHMIZoneCapabilities BACK].value).to(equal(@"BACK"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLHMIZoneCapabilities valueOf:@"FRONT"]).to(equal([SDLHMIZoneCapabilities FRONT]));
        expect([SDLHMIZoneCapabilities valueOf:@"BACK"]).to(equal([SDLHMIZoneCapabilities BACK]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLHMIZoneCapabilities valueOf:nil]).to(beNil());
        expect([SDLHMIZoneCapabilities valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLHMIZoneCapabilities values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLHMIZoneCapabilities FRONT],
                        [SDLHMIZoneCapabilities BACK]] copy];
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