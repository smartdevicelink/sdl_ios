//
//  SDLAppHMITypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLKeyboardInputMask.h"

QuickSpecBegin(SDLKeyboardInputMaskSpec)

describe(@"individual enum value tests", ^{
    it(@"should match internal values", ^{
        expect(SDLKeyboardInputMaskEnableInputKeyMask).to(equal(@"ENABLE_INPUT_KEY_MASK"));
        expect(SDLKeyboardInputMaskDisableInputKeyMask).to(equal(@"DISABLE_INPUT_KEY_MASK"));
        expect(SDLKeyboardInputMaskUserChoiceInputKeyMask).to(equal(@"USER_CHOICE_INPUT_KEY_MASK"));
    });
});

QuickSpecEnd
