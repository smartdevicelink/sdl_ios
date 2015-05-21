//
//  SDLButtonPressModeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLButtonPressMode.h"

QuickSpecBegin(SDLButtonPressModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLButtonPressMode LONG].value).to(equal(@"LONG"));
        expect([SDLButtonPressMode SHORT].value).to(equal(@"SHORT"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLButtonPressMode valueOf:@"LONG"]).to(equal([SDLButtonPressMode LONG]));
        expect([SDLButtonPressMode valueOf:@"SHORT"]).to(equal([SDLButtonPressMode SHORT]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLButtonPressMode valueOf:nil]).to(beNil());
        expect([SDLButtonPressMode valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLButtonPressMode values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLButtonPressMode LONG],
                        [SDLButtonPressMode SHORT]] copy];
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
