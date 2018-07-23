//
//  SDLDisplayModeSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDisplayMode.h"

QuickSpecBegin(SDLDisplayModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLDisplayModeDay).to(equal(@"DAY"));
        expect(SDLDisplayModeNight).to(equal(@"NIGHT"));
        expect(SDLDisplayModeAuto).to(equal(@"AUTO"));
    });
});

QuickSpecEnd
