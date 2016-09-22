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
        expect(SDLPrerecordedSpeechHelpJingle).to(equal(@"HELP_JINGLE"));
        expect(SDLPrerecordedSpeechInitialJingle).to(equal(@"INITIAL_JINGLE"));
        expect(SDLPrerecordedSpeechListenJingle).to(equal(@"LISTEN_JINGLE"));
        expect(SDLPrerecordedSpeechPositiveJingle).to(equal(@"POSITIVE_JINGLE"));
        expect(SDLPrerecordedSpeechNegativeJingle).to(equal(@"NEGATIVE_JINGLE"));
    });
});

QuickSpecEnd
