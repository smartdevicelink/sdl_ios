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
        expect(SDLWiperStatusAutoOff).to(equal(@"AUTO_OFF"));
        expect(SDLWiperStatusOffMoving).to(equal(@"OFF_MOVING"));
        expect(SDLWiperStatusManIntOff).to(equal(@"MAN_INT_OFF"));
        expect(SDLWiperStatusManIntOn).to(equal(@"MAN_INT_ON"));
        expect(SDLWiperStatusManLow).to(equal(@"MAN_LOW"));
        expect(SDLWiperStatusManHigh).to(equal(@"MAN_HIGH"));
        expect(SDLWiperStatusManFlick).to(equal(@"MAN_FLICK"));
        expect(SDLWiperStatusWash).to(equal(@"WASH"));
        expect(SDLWiperStatusAutoLow).to(equal(@"AUTO_LOW"));
        expect(SDLWiperStatusAutoHigh).to(equal(@"AUTO_HIGH"));
        expect(SDLWiperStatusCourtesyWipe).to(equal(@"COURTESYWIPE"));
        expect(SDLWiperStatusAutoAdjust).to(equal(@"AUTO_ADJUST"));
        expect(SDLWiperStatusStalled).to(equal(@"STALLED"));
        expect(SDLWiperStatusNoDataExists).to(equal(@"NO_DATA_EXISTS"));
    });
});

QuickSpecEnd
