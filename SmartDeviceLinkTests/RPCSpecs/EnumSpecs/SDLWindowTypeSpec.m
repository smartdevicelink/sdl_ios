//
//  SDLWindowTypeSpec.m
//  SmartDeviceLinkTests

@import Quick;
@import Nimble;
#import "SDLWindowType.h"

QuickSpecBegin(SDLWindowTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLWindowTypeMain).to(equal(@"MAIN"));
        expect(SDLWindowTypeWidget).to(equal(@"WIDGET"));
    });
});

QuickSpecEnd

