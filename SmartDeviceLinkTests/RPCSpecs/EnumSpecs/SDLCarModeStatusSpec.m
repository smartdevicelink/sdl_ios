//
//  SDLCarModeStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCarModeStatus.h"

QuickSpecBegin(SDLCarModeStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLCarModeStatusNormal).to(equal(@"NORMAL"));
        expect(SDLCarModeStatusFactory).to(equal(@"FACTORY"));
        expect(SDLCarModeStatusTransport).to(equal(@"TRANSPORT"));
        expect(SDLCarModeStatusCrash).to(equal(@"CRASH"));
    });
});

QuickSpecEnd

