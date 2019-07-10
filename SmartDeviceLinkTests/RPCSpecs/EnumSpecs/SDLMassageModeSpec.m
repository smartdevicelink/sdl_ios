//
//  SDLMassageModeSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLMassageMode.h"

QuickSpecBegin(SDLMassageModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLMassageModeOff).to(equal(@"OFF"));
        expect(SDLMassageModeLow).to(equal(@"LOW"));
        expect(SDLMassageModeHigh).to(equal(@"HIGH"));
    });
});

QuickSpecEnd
