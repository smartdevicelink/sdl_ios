//
//  SDLVideoStreamingProtocolSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVideoStreamingProtocol.h"

QuickSpecBegin(SDLVideoStreamingProtocolSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLVideoStreamingProtocol RAW].value).to(equal(@"RAW"));
        expect([SDLVideoStreamingProtocol RTP].value).to(equal(@"RTP"));
        expect([SDLVideoStreamingProtocol RTSP].value).to(equal(@"RTSP"));
        expect([SDLVideoStreamingProtocol RTMP].value).to(equal(@"RTMP"));
        expect([SDLVideoStreamingProtocol WEBM].value).to(equal(@"WEBM"));
    });
});

describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLVideoStreamingProtocol valueOf:@"RAW"]).to(equal([SDLVideoStreamingProtocol RAW]));
        expect([SDLVideoStreamingProtocol valueOf:@"RTP"]).to(equal([SDLVideoStreamingProtocol RTP]));
        expect([SDLVideoStreamingProtocol valueOf:@"RTSP"]).to(equal([SDLVideoStreamingProtocol RTSP]));
        expect([SDLVideoStreamingProtocol valueOf:@"RTMP"]).to(equal([SDLVideoStreamingProtocol RTMP]));
        expect([SDLVideoStreamingProtocol valueOf:@"WEBM"]).to(equal([SDLVideoStreamingProtocol WEBM]));
    });

    it(@"Should return nil when invalid", ^ {
        expect([SDLVideoStreamingProtocol valueOf:nil]).to(beNil());
        expect([SDLVideoStreamingProtocol valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});

describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLVideoStreamingProtocol values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLVideoStreamingProtocol RAW],
                           [SDLVideoStreamingProtocol RTP],
                           [SDLVideoStreamingProtocol RTSP],
                           [SDLVideoStreamingProtocol RTMP],
                           [SDLVideoStreamingProtocol WEBM]] copy];
    });

    it(@"Should contain all defined enum values", ^ {
        for (int i = 0; i < definedValues.count; i++) {
            expect(storedValues).to(contain(definedValues[i]));
        }
    });

    it(@"Should contain only defined enum values", ^ {
        for (int i = 0; i < storedValues.count; i++) {
            expect(definedValues).to(contain(storedValues[i]));
        }
    });
});

QuickSpecEnd
