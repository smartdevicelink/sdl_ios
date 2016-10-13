//
//  SDLGlobalPropertySpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGlobalProperty.h"

QuickSpecBegin(SDLGlobalPropertySpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLGlobalPropertyHelpPrompt).to(equal(@"HELPPROMPT"));
        expect(SDLGlobalPropertyTimeoutPrompt).to(equal(@"TIMEOUTPROMPT"));
        expect(SDLGlobalPropertyVRHelpTitle).to(equal(@"VRHELPTITLE"));
        expect(SDLGlobalPropertyVRHelpItems).to(equal(@"VRHELPITEMS"));
        expect(SDLGlobalPropertyMenuName).to(equal(@"MENUNAME"));
        expect(SDLGlobalPropertyMenuIcon).to(equal(@"MENUICON"));
        expect(SDLGlobalPropertyKeyboard).to(equal(@"KEYBOARDPROPERTIES"));
    });
});

QuickSpecEnd
