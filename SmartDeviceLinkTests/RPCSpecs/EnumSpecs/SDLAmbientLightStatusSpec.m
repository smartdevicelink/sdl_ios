//
//  SDLAmbientLightStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAmbientLightStatus.h"

QuickSpecBegin(SDLAmbientLightStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLAmbientLightStatusNight).to(equal(@"NIGHT"));
        expect(SDLAmbientLightStatusTwilight1).to(equal(@"TWILIGHT_1"));
        expect(SDLAmbientLightStatusTwilight2).to(equal(@"TWILIGHT_2"));
        expect(SDLAmbientLightStatusTwilight3).to(equal(@"TWILIGHT_3"));
        expect(SDLAmbientLightStatusTwilight4).to(equal(@"TWILIGHT_4"));
        expect(SDLAmbientLightStatusDay).to(equal(@"DAY"));
        expect(SDLAmbientLightStatusUnknown).to(equal(@"UNKNOWN"));
        expect(SDLAmbientLightStatusInvalid).to(equal(@"INVALID"));
    });
});

QuickSpecEnd
