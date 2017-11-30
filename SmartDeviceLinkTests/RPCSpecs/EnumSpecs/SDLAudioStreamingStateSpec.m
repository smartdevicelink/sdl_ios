//
//  SDLAudioStreamingStateSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioStreamingState.h"

QuickSpecBegin(SDLAudioStreamingStateSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLAudioStreamingStateAudible).to(equal(@"AUDIBLE"));
        expect(SDLAudioStreamingStateAttenuated).to(equal(@"ATTENUATED"));
        expect(SDLAudioStreamingStateNotAudible).to(equal(@"NOT_AUDIBLE"));
    });
});

QuickSpecEnd
