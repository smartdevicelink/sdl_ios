//
//  SDLMaintenanceModeStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLMaintenanceModeStatus.h"

QuickSpecBegin(SDLMaintenanceModeStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLMaintenanceModeStatusNormal).to(equal(@"NORMAL"));
        expect(SDLMaintenanceModeStatusNear).to(equal(@"NEAR"));
        expect(SDLMaintenanceModeStatusActive).to(equal(@"ACTIVE"));
        expect(SDLMaintenanceModeStatusFeatureNotPresent).to(equal(@"FEATURE_NOT_PRESENT"));
    });
});

QuickSpecEnd
