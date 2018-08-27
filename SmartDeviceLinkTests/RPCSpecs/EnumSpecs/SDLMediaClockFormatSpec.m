//
//  SDLMediaClockFormatSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLMediaClockFormat.h"

QuickSpecBegin(SDLMediaClockFormatSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLMediaClockFormatClock1).to(equal(@"CLOCK1"));
        expect(SDLMediaClockFormatClock2).to(equal(@"CLOCK2"));
        expect(SDLMediaClockFormatClock3).to(equal(@"CLOCK3"));
        expect(SDLMediaClockFormatClockText1).to(equal(@"CLOCKTEXT1"));
        expect(SDLMediaClockFormatClockText2).to(equal(@"CLOCKTEXT2"));
        expect(SDLMediaClockFormatClockText3).to(equal(@"CLOCKTEXT3"));
        expect(SDLMediaClockFormatClockText4).to(equal(@"CLOCKTEXT4"));
    });
});

QuickSpecEnd
