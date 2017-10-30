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
        expect(SDLKeyboardLayoutQWERTY).to(equal(@"QWERTY"));
        expect(SDLKeyboardLayoutQWERTZ).to(equal(@"QWERTZ"));
        expect(SDLKeyboardLayoutAZERTY).to(equal(@"AZERTY"));
    });
});

QuickSpecEnd
