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
        expect(SDLKeyboardLayoutQwerty).to(equal(@"QWERTY"));
        expect(SDLKeyboardLayoutQwertz).to(equal(@"QWERTZ"));
        expect(SDLKeyboardLayoutAzerty).to(equal(@"AZERTY"));
    });
});

QuickSpecEnd
