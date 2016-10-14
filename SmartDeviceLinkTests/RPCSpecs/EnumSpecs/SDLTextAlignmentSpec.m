//
//  SDLTextAlignmentSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTextAlignment.h"

QuickSpecBegin(SDLTextAlignmentSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLTextAlignmentLeft).to(equal(@"LEFT_ALIGNED"));
        expect(SDLTextAlignmentRight).to(equal(@"RIGHT_ALIGNED"));
        expect(SDLTextAlignmentCenter).to(equal(@"CENTERED"));
    });
});

QuickSpecEnd
