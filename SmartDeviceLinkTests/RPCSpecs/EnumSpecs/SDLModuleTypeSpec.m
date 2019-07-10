//
//  SDLModuleTypeSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

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
