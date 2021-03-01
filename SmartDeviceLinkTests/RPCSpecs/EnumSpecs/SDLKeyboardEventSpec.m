//
//  SDLKeyboardEventSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLKeyboardEvent.h"

QuickSpecBegin(SDLKeyboardEventSpec)

describe(@"individual enum value tests", ^{
    it(@"should match internal values", ^{
        expect(SDLKeyboardEventKeypress).to(equal(@"KEYPRESS"));
        expect(SDLKeyboardEventSubmitted).to(equal(@"ENTRY_SUBMITTED"));
        expect(SDLKeyboardEventCancelled).to(equal(@"ENTRY_CANCELLED"));
        expect(SDLKeyboardEventAborted).to(equal(@"ENTRY_ABORTED"));
        expect(SDLKeyboardEventVoice).to(equal(@"ENTRY_VOICE"));
        expect(SDLKeyboardEventInputKeyMaskEnabled).to(equal(@"INPUT_KEY_MASK_ENABLED"));
        expect(SDLKeyboardEventInputKeyMaskDisabled).to(equal(@"INPUT_KEY_MASK_DISABLED"));
    });
});

QuickSpecEnd
