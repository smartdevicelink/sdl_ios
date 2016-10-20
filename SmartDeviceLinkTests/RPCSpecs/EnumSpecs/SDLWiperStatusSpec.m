//
//  SDLWiperStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLWiperStatus.h"

QuickSpecBegin(SDLWiperStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLWiperStatusOff).to(equal(@"OFF"));
        expect(SDLWiperStatusAutomaticOff).to(equal(@"AUTO_OFF"));
        expect(SDLWiperStatusOffMoving).to(equal(@"OFF_MOVING"));
        expect(SDLWiperStatusManualIntervalOff).to(equal(@"MAN_INT_OFF"));
        expect(SDLWiperStatusManualIntervalOn).to(equal(@"MAN_INT_ON"));
        expect(SDLWiperStatusManualLow).to(equal(@"MAN_LOW"));
        expect(SDLWiperStatusManualHigh).to(equal(@"MAN_HIGH"));
        expect(SDLWiperStatusManualFlick).to(equal(@"MAN_FLICK"));
        expect(SDLWiperStatusWash).to(equal(@"WASH"));
        expect(SDLWiperStatusAutomaticLow).to(equal(@"AUTO_LOW"));
        expect(SDLWiperStatusAutomaticHigh).to(equal(@"AUTO_HIGH"));
        expect(SDLWiperStatusCourtesyWipe).to(equal(@"COURTESYWIPE"));
        expect(SDLWiperStatusAutomaticAdjust).to(equal(@"AUTO_ADJUST"));
        expect(SDLWiperStatusStalled).to(equal(@"STALLED"));
        expect(SDLWiperStatusNoDataExists).to(equal(@"NO_DATA_EXISTS"));
    });
});

QuickSpecEnd
