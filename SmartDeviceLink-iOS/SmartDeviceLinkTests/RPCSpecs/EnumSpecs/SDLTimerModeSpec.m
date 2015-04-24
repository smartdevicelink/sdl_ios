//
//  SDLTimerModeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTimerMode.h"

QuickSpecBegin(SDLTimerModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLTimerMode UP].value).to(equal(@"UP"));
        expect([SDLTimerMode DOWN].value).to(equal(@"DOWN"));
        expect([SDLTimerMode NONE].value).to(equal(@"NONE"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLTimerMode valueOf:@"UP"]).to(equal([SDLTimerMode UP]));
        expect([SDLTimerMode valueOf:@"DOWN"]).to(equal([SDLTimerMode DOWN]));
        expect([SDLTimerMode valueOf:@"NONE"]).to(equal([SDLTimerMode NONE]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLTimerMode valueOf:nil]).to(beNil());
        expect([SDLTimerMode valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLTimerMode values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLTimerMode UP],
                        [SDLTimerMode DOWN],
                        [SDLTimerMode NONE]] copy];
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