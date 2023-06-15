//
//  SDLDirectionSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/22/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;

#import "SDLDirection.h"

QuickSpecBegin(SDLDirectionSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLDirectionLeft).to(equal(@"LEFT"));
        expect(SDLDirectionRight).to(equal(@"RIGHT"));
    });
});

QuickSpecEnd
