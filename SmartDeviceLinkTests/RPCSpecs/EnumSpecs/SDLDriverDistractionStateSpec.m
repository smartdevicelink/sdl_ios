//
//  SDLDriverDistractionStateSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDriverDistractionState.h"

QuickSpecBegin(SDLDriverDistractionStateSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLDriverDistractionStateOff).to(equal(@"DD_OFF"));
        expect(SDLDriverDistractionStateOn).to(equal(@"DD_ON"));
    });
});

QuickSpecEnd
