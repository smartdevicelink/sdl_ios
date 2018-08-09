//
//  SDLMassageCushionSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLMassageCushion.h"

QuickSpecBegin(SDLMassageCushionSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLMassageCushionTopLumbar).to(equal(@"TOP_LUMBAR"));
        expect(SDLMassageCushionMiddleLumbar).to(equal(@"MIDDLE_LUMBAR"));
        expect(SDLMassageCushionBottomLumbar).to(equal(@"BOTTOM_LUMBAR"));
        expect(SDLMassageCushionBackBolsters).to(equal(@"BACK_BOLSTERS"));
        expect(SDLMassageCushionSeatBolsters).to(equal(@"SEAT_BOLSTERS"));
    });
});

QuickSpecEnd
