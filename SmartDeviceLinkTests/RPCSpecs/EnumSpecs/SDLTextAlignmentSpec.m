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
        expect(SDLTextAlignmentLeftAligned).to(equal(@"LEFT_ALIGNED"));
        expect(SDLTextAlignmentRightAligned).to(equal(@"RIGHT_ALIGNED"));
        expect(SDLTextAlignmentCentered).to(equal(@"CENTERED"));
    });
});

QuickSpecEnd
