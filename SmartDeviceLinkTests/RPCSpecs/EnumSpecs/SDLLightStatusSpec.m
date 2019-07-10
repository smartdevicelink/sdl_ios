//
//  SDLLightStatusSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLightStatus.h"

QuickSpecBegin(SDLLightStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLLightStatusOn).to(equal(@"ON"));
        expect(SDLLightStatusOFF).to(equal(@"OFF"));

    });
});

QuickSpecEnd
