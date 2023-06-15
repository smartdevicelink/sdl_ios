//
//  SDLKeyboardLayoutSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLKeyboardLayout.h"

QuickSpecBegin(SDLKeyboardLayoutSpec)

describe(@"individual enum value tests", ^{
    it(@"should match internal values", ^{
        expect(SDLKeyboardLayoutQWERTY).to(equal(@"QWERTY"));
        expect(SDLKeyboardLayoutQWERTZ).to(equal(@"QWERTZ"));
        expect(SDLKeyboardLayoutAZERTY).to(equal(@"AZERTY"));
        expect(SDLKeyboardLayoutNumeric).to(equal(@"NUMERIC"));
    });
});

QuickSpecEnd
