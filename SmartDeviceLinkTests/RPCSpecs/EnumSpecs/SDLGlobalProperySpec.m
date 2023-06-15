//
//  SDLGlobalPropertySpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLGlobalProperty.h"

QuickSpecBegin(SDLGlobalPropertySpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLGlobalPropertyHelpPrompt).to(equal(@"HELPPROMPT"));
        expect(SDLGlobalPropertyTimeoutPrompt).to(equal(@"TIMEOUTPROMPT"));
        expect(SDLGlobalPropertyVoiceRecognitionHelpTitle).to(equal(@"VRHELPTITLE"));
        expect(SDLGlobalPropertyVoiceRecognitionHelpItems).to(equal(@"VRHELPITEMS"));
        expect(SDLGlobalPropertyMenuName).to(equal(@"MENUNAME"));
        expect(SDLGlobalPropertyMenuIcon).to(equal(@"MENUICON"));
        expect(SDLGlobalPropertyKeyboard).to(equal(@"KEYBOARDPROPERTIES"));
        expect(SDLGlobalPropertyUserLocation).to(equal(@"USER_LOCATION"));
    });
});

QuickSpecEnd
