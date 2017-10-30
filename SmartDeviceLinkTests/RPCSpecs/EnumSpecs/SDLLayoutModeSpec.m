//
//  SDLLayoutModeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLayoutMode.h"

QuickSpecBegin(SDLLayoutModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLLayoutModeIconOnly).to(equal(@"ICON_ONLY"));
        expect(SDLLayoutModeIconWithSearch).to(equal(@"ICON_WITH_SEARCH"));
        expect(SDLLayoutModeListOnly).to(equal(@"LIST_ONLY"));
        expect(SDLLayoutModeListWithSearch).to(equal(@"LIST_WITH_SEARCH"));
        expect(SDLLayoutModeKeyboard).to(equal(@"KEYBOARD"));
    });
});

QuickSpecEnd
