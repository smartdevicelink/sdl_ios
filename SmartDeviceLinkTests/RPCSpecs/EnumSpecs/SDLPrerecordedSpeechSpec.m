//
//  SDLPrerecordedSpeechSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPrerecordedSpeech.h"

QuickSpecBegin(SDLPrerecordedSpeechSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLPrerecordedSpeechHelp).to(equal(@"HELP_JINGLE"));
        expect(SDLPrerecordedSpeechInitial).to(equal(@"INITIAL_JINGLE"));
        expect(SDLPrerecordedSpeechListen).to(equal(@"LISTEN_JINGLE"));
        expect(SDLPrerecordedSpeechPositive).to(equal(@"POSITIVE_JINGLE"));
        expect(SDLPrerecordedSpeechNegative).to(equal(@"NEGATIVE_JINGLE"));
    });
});

QuickSpecEnd
