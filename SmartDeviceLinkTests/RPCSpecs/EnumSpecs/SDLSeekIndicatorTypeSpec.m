//
//  SDLSeekIndicatorTypeSpec.m
//  SmartDeviceLinkTests
//
//  Created by Frank Elias on 12/4/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSeekIndicatorType.h"

QuickSpecBegin(SDLSeekIndicatorTypeSpec)

describe(@"Individual Enum Value Tests", ^{
    it(@"Should match internal values", ^{
        expect(SDLSeekIndicatorTypeTrack).to(equal(@"TRACK"));
        expect(SDLSeekIndicatorTypeTime).to(equal(@"TIME"));
    });
});

QuickSpecEnd
