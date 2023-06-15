//
//  SDLTurnSignalSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 7/19/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLTurnSignal.h"

QuickSpecBegin(SDLTurnSignalSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLTurnSignalOff).to(equal(@"OFF"));
        expect(SDLTurnSignalLeft).to(equal(@"LEFT"));
        expect(SDLTurnSignalRight).to(equal(@"RIGHT"));
        expect(SDLTurnSignalBoth).to(equal(@"BOTH"));
    });
});

QuickSpecEnd
