//
//  SDLWindowTypeSpec.m
//  SmartDeviceLinkTests

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import "SDLWindowType.h"

QuickSpecBegin(SDLWindowTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLWindowTypeMain).to(equal(@"MAIN"));
        expect(SDLWindowTypeWidget).to(equal(@"WIDGET"));
    });
});

QuickSpecEnd

