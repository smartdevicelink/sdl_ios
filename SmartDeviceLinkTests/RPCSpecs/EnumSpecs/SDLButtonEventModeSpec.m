//
//  SDLButtonEventModeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLButtonEventMode.h"

QuickSpecBegin(SDLButtonEventModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLButtonEventMode BUTTONUP].value).to(equal(@"BUTTONUP"));
        expect([SDLButtonEventMode BUTTONDOWN].value).to(equal(@"BUTTONDOWN"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLButtonEventMode valueOf:@"BUTTONUP"]).to(equal([SDLButtonEventMode BUTTONUP]));
        expect([SDLButtonEventMode valueOf:@"BUTTONDOWN"]).to(equal([SDLButtonEventMode BUTTONDOWN]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLButtonEventMode valueOf:nil]).to(beNil());
        expect([SDLButtonEventMode valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLButtonEventMode values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLButtonEventMode BUTTONUP],
                        [SDLButtonEventMode BUTTONDOWN]] copy];
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