//
//  SDLButtonPressModeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLButtonPressMode.h"

QuickSpecBegin(SDLButtonPressModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLButtonPressModeLong).to(equal(@"LONG"));
        expect(SDLButtonPressModeShort).to(equal(@"SHORT"));
    });
});

QuickSpecEnd
