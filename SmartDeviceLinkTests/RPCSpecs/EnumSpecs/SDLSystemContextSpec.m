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
        expect(SDLSystemContextVrSession).to(equal(@"VRSESSION"));
        expect(SDLSystemContextMenu).to(equal(@"MENU"));
        expect(SDLSystemContextHmiObscured).to(equal(@"HMI_OBSCURED"));
        expect(SDLSystemContextAlert).to(equal(@"ALERT"));
    });
});

QuickSpecEnd
