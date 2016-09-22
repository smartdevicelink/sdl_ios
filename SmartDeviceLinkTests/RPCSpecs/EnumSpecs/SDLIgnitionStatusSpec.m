//
//  SDLIgnitionStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLIgnitionStatus.h"

QuickSpecBegin(SDLIgnitionStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLIgnitionStatusUnknown).to(equal(@"UNKNOWN"));
        expect(SDLIgnitionStatusOff).to(equal(@"OFF"));
        expect(SDLIgnitionStatusAccessory).to(equal(@"ACCESSORY"));
        expect(SDLIgnitionStatusRun).to(equal(@"RUN"));
        expect(SDLIgnitionStatusStart).to(equal(@"START"));
        expect(SDLIgnitionStatusInvalid).to(equal(@"INVALID"));
    });
});

QuickSpecEnd
