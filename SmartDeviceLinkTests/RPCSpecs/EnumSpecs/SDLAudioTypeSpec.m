//
//  SDLAudioTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAudioType.h"

QuickSpecBegin(SDLAudioTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLAudioTypePCM).to(equal(@"PCM"));
    });
});

QuickSpecEnd
