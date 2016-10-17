//
//  SDLTriggerSourceSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTriggerSource.h"

QuickSpecBegin(SDLTriggerSourceSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLTriggerSourceMenu).to(equal(@"MENU"));
        expect(SDLTriggerSourceVoiceRecognition).to(equal(@"VR"));
        expect(SDLTriggerSourceKeyboard).to(equal(@"KEYBOARD"));
    });
});

QuickSpecEnd
