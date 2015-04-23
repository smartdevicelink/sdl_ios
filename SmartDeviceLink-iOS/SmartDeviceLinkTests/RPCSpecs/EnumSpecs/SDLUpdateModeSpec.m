//
//  SDLUpdateModeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLUpdateMode.h"

QuickSpecBegin(SDLUpdateModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLUpdateMode COUNTUP].value).to(equal(@"COUNTUP"));
        expect([SDLUpdateMode COUNTDOWN].value).to(equal(@"COUNTDOWN"));
        expect([SDLUpdateMode PAUSE].value).to(equal(@"PAUSE"));
        expect([SDLUpdateMode RESUME].value).to(equal(@"RESUME"));
        expect([SDLUpdateMode CLEAR].value).to(equal(@"CLEAR"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLUpdateMode valueOf:@"COUNTUP"]).to(equal([SDLUpdateMode COUNTUP]));
        expect([SDLUpdateMode valueOf:@"COUNTDOWN"]).to(equal([SDLUpdateMode COUNTDOWN]));
        expect([SDLUpdateMode valueOf:@"PAUSE"]).to(equal([SDLUpdateMode PAUSE]));
        expect([SDLUpdateMode valueOf:@"RESUME"]).to(equal([SDLUpdateMode RESUME]));
        expect([SDLUpdateMode valueOf:@"CLEAR"]).to(equal([SDLUpdateMode CLEAR]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLUpdateMode valueOf:nil]).to(beNil());
        expect([SDLUpdateMode valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLUpdateMode values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLUpdateMode COUNTUP],
                        [SDLUpdateMode COUNTDOWN],
                        [SDLUpdateMode PAUSE],
                        [SDLUpdateMode RESUME],
                        [SDLUpdateMode CLEAR]] copy];
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