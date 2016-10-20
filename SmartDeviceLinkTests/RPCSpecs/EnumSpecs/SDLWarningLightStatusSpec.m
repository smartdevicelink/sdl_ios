//
//  SDLWarningLightStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLWarningLightStatus.h"

QuickSpecBegin(SDLWarningLightStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLWarningLightStatusOff).to(equal(@"OFF"));
        expect(SDLWarningLightStatusOn).to(equal(@"ON"));
        expect(SDLWarningLightStatusFlash).to(equal(@"FLASH"));
        expect(SDLWarningLightStatusNotUsed).to(equal(@"NOT_USED"));
    });
});

QuickSpecEnd
