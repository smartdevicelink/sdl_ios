//
//  SDLVideoStreamingCodecSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/31/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVideoStreamingCodec.h"

QuickSpecBegin(SDLVideoStreamingCodecSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLVideoStreamingCodecH264).to(equal(@"H264"));
        expect(SDLVideoStreamingCodecH265).to(equal(@"H265"));
        expect(SDLVideoStreamingCodecTheora).to(equal(@"THEORA"));
        expect(SDLVideoStreamingCodecVP8).to(equal(@"VP8"));
        expect(SDLVideoStreamingCodecVP9).to(equal(@"VP9"));
    });
});

QuickSpecEnd
