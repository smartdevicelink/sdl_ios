//
//  SDLHybridAppPreferenceSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/26/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHybridAppPreference.h"

QuickSpecBegin(SDLHybridAppPreferenceSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLHybridAppPreferenceMobile).to(equal(@"MOBILE"));
        expect(SDLHybridAppPreferenceCloud).to(equal(@"CLOUD"));
        expect(SDLHybridAppPreferenceBoth).to(equal(@"BOTH"));
    });
});

QuickSpecEnd
