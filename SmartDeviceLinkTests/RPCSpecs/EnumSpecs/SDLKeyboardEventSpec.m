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
        expect(SDLKeyboardEventEntrySubmitted).to(equal(@"ENTRY_SUBMITTED"));
        expect(SDLKeyboardEventEntryCancelled).to(equal(@"ENTRY_CANCELLED"));
        expect(SDLKeyboardEventEntryAborted).to(equal(@"ENTRY_ABORTED"));
        expect(SDLKeyboardEventEntryVoice).to(equal(@"ENTRY_VOICE"));
    });
});

QuickSpecEnd
