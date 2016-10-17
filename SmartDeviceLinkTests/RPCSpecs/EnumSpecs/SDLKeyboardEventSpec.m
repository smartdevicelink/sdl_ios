//
//  SDLKeyboardEventSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLKeyboardEvent.h"

QuickSpecBegin(SDLKeyboardEventSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLKeyboardEventKeypress).to(equal(@"KEYPRESS"));
        expect(SDLKeyboardEventSubmitted).to(equal(@"ENTRY_SUBMITTED"));
        expect(SDLKeyboardEventCancelled).to(equal(@"ENTRY_CANCELLED"));
        expect(SDLKeyboardEventAborted).to(equal(@"ENTRY_ABORTED"));
        expect(SDLKeyboardEventVoice).to(equal(@"ENTRY_VOICE"));
    });
});

QuickSpecEnd
