//
//  SDLLockScreenStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLockScreenStatus.h"

QuickSpecBegin(SDLLockScreenStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(SDLLockScreenStatusOff).to(equal(@"OFF"));
        expect(SDLLockScreenStatusOptional).to(equal(@"OPTIONAL"));
        expect(SDLLockScreenStatusRequired).to(equal(@"REQUIRED"));
#pragma clang diagnostic pop
    });
});

QuickSpecEnd
