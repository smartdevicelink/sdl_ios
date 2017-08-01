//
//  SDLVideoStreamingProtocolSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/31/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVideoStreamingProtocol.h"

QuickSpecBegin(SDLVideoStreamingProtocolSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLVideoStreamingProtocolRTP).to(equal(@"RTP"));
        expect(SDLVideoStreamingProtocolRAW).to(equal(@"RAW"));
        expect(SDLVideoStreamingProtocolRTMP).to(equal(@"RTMP"));
        expect(SDLVideoStreamingProtocolRTSP).to(equal(@"RTSP"));
        expect(SDLVideoStreamingProtocolWebM).to(equal(@"WEBM"));
    });
});

QuickSpecEnd
