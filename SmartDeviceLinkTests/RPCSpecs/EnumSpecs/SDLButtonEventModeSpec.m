//
//  SDLButtonEventModeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLButtonEventMode.h"

QuickSpecBegin(SDLButtonEventModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLButtonEventModeButtonUp).to(equal(@"BUTTONUP"));
        expect(SDLButtonEventModeButtonDown).to(equal(@"BUTTONDOWN"));
    });
});

QuickSpecEnd
