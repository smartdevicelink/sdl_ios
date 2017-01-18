//
//  SDLBitsPerSampleSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLBitsPerSample.h"

QuickSpecBegin(SDLBitsPerSampleSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLBitsPerSample8Bit).to(equal(@"8_BIT"));
        expect(SDLBitsPerSample16Bit).to(equal(@"16_BIT"));
    });
});

QuickSpecEnd
