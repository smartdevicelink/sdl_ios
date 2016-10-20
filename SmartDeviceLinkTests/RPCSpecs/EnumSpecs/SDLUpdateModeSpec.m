//
//  SDLUpdateModeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLUpdateMode.h"

QuickSpecBegin(SDLUpdateModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLUpdateModeCountUp).to(equal(@"COUNTUP"));
        expect(SDLUpdateModeCountDown).to(equal(@"COUNTDOWN"));
        expect(SDLUpdateModePause).to(equal(@"PAUSE"));
        expect(SDLUpdateModeResume).to(equal(@"RESUME"));
        expect(SDLUpdateModeClear).to(equal(@"CLEAR"));
    });
});

QuickSpecEnd
