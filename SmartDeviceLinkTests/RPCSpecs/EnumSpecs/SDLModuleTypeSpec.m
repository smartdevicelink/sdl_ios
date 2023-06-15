//
//  SDLModuleTypeSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLModuleType.h"

QuickSpecBegin(SDLModuleTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLModuleTypeRadio).to(equal(@"RADIO"));
        expect(SDLModuleTypeClimate).to(equal(@"CLIMATE"));
        expect(SDLModuleTypeSeat).to(equal(@"SEAT"));
    });
});

QuickSpecEnd
