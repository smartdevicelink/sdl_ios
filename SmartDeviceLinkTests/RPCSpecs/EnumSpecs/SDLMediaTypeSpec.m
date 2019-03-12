//
//  SDLMediaTypeSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/8/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLMediaType.h"

QuickSpecBegin(SDLMediaTypeSpec)

describe(@"Individual Enum Value Tests", ^{
    it(@"Should match internal values", ^{
        expect(SDLMediaTypeMusic).to(equal(@"MUSIC"));
        expect(SDLMediaTypePodcast).to(equal(@"PODCAST"));
        expect(SDLMediaTypeAudiobook).to(equal(@"AUDIOBOOK"));
        expect(SDLMediaTypeOther).to(equal(@"OTHER"));
    });
});

QuickSpecEnd
