//
//  SDLSoftButtonTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSoftButtonType.h"

QuickSpecBegin(SDLSoftButtonTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLSoftButtonTypeText).to(equal(@"TEXT"));
        expect(SDLSoftButtonTypeImage).to(equal(@"IMAGE"));
        expect(SDLSoftButtonTypeBoth).to(equal(@"BOTH"));
    });
});

QuickSpecEnd
