//
//  SDLInteractionModeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLInteractionMode.h"

QuickSpecBegin(SDLInteractionModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLInteractionModeManualOnly).to(equal(@"MANUAL_ONLY"));
        expect(SDLInteractionModeVoiceRecognitionOnly).to(equal(@"VR_ONLY"));
        expect(SDLInteractionModeBoth).to(equal(@"BOTH"));
    });
});

QuickSpecEnd
