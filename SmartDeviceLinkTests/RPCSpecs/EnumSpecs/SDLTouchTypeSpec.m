//
//  SDLTouchTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTouchType.h"

QuickSpecBegin(SDLTouchTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLTouchTypeBegin).to(equal(@"BEGIN"));
        expect(SDLTouchTypeMove).to(equal(@"MOVE"));
        expect(SDLTouchTypeEnd).to(equal(@"END"));
        expect(SDLTouchTypeCancel).to(equal(@"CANCEL"));
    });
});

QuickSpecEnd
