//
//  SDLAudioStreamingIndicatorSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioStreamingIndicator.h"

QuickSpecBegin(SDLAudioStreamingIndicatorStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLAudioStreamingIndicatorPlayPause).to(equal(@"PLAY_PAUSE"));
        expect(SDLAudioStreamingIndicatorPlay).to(equal(@"PLAY"));
        expect(SDLAudioStreamingIndicatorPause).to(equal(@"PAUSE"));
        expect(SDLAudioStreamingIndicatorStop).to(equal(@"STOP"));
    });
});

QuickSpecEnd
