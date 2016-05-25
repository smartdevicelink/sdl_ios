//
//  SDLKeyboardLayoutSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLKeyboardLayout.h"

QuickSpecBegin(SDLKeyboardLayoutSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLKeyboardLayout QWERTY].value).to(equal(@"QWERTY"));
        expect([SDLKeyboardLayout QWERTZ].value).to(equal(@"QWERTZ"));
        expect([SDLKeyboardLayout AZERTY].value).to(equal(@"AZERTY"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLKeyboardLayout valueOf:@"QWERTY"]).to(equal([SDLKeyboardLayout QWERTY]));
        expect([SDLKeyboardLayout valueOf:@"QWERTZ"]).to(equal([SDLKeyboardLayout QWERTZ]));
        expect([SDLKeyboardLayout valueOf:@"AZERTY"]).to(equal([SDLKeyboardLayout AZERTY]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLKeyboardLayout valueOf:nil]).to(beNil());
        expect([SDLKeyboardLayout valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLKeyboardLayout values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLKeyboardLayout QWERTY],
                        [SDLKeyboardLayout QWERTZ],
                        [SDLKeyboardLayout AZERTY]] copy];
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