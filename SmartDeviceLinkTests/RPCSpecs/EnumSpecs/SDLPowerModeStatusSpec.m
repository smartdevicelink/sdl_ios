//
//  SDLPowerModeStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPowerModeStatus.h"

QuickSpecBegin(SDLPowerModeStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLPowerModeStatusKeyOut).to(equal(@"KEY_OUT"));
        expect(SDLPowerModeStatusKeyRecentlyOut).to(equal(@"KEY_RECENTLY_OUT"));
        expect(SDLPowerModeStatusKeyApproved).to(equal(@"KEY_APPROVED_0"));
        expect(SDLPowerModeStatusPostAccessory).to(equal(@"POST_ACCESORY_0"));
        expect(SDLPowerModeStatusAccessory).to(equal(@"ACCESORY_1"));
        expect(SDLPowerModeStatusPostIgnition).to(equal(@"POST_IGNITION_1"));
        expect(SDLPowerModeStatusIgnitionOn).to(equal(@"IGNITION_ON_2"));
        expect(SDLPowerModeStatusRunning).to(equal(@"RUNNING_2"));
        expect(SDLPowerModeStatusCrank).to(equal(@"CRANK_3"));
    });
});

QuickSpecEnd
