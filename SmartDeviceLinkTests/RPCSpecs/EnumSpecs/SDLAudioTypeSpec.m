//
//  SDLAudioTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLAudioType.h"

QuickSpecBegin(SDLAudioTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLAudioTypePCM).to(equal(@"PCM"));
    });
});

QuickSpecEnd
