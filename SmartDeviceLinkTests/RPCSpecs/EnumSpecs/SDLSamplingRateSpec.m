//
//  SDLSamplingRateSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSamplingRate.h"

QuickSpecBegin(SDLSamplingRateSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLSamplingRate8KHZ).to(equal(@"8KHZ"));
        expect(SDLSamplingRate16KHZ).to(equal(@"16KHZ"));
        expect(SDLSamplingRate22KHZ).to(equal(@"22KHZ"));
        expect(SDLSamplingRate44KHZ).to(equal(@"44KHZ"));
    });
});

QuickSpecEnd
