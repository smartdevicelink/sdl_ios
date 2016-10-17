//
//  SDLSystemContextSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSystemContext.h"

QuickSpecBegin(SDLSystemContextSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLSystemContextMain).to(equal(@"MAIN"));
        expect(SDLSystemContextVoiceRecognitionSession).to(equal(@"VRSESSION"));
        expect(SDLSystemContextMenu).to(equal(@"MENU"));
        expect(SDLSystemContextHMIObscured).to(equal(@"HMI_OBSCURED"));
        expect(SDLSystemContextAlert).to(equal(@"ALERT"));
    });
});

QuickSpecEnd
