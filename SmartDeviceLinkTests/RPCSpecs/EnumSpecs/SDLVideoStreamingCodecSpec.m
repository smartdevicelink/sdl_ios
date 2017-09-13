//
//  SDLVideoStreamingCodecSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVideoStreamingCodec.h"

QuickSpecBegin(SDLVideoStreamingCodecSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLVideoStreamingCodec H264].value).to(equal(@"H264"));
        expect([SDLVideoStreamingCodec H265].value).to(equal(@"H265"));
        expect([SDLVideoStreamingCodec THEORA].value).to(equal(@"THEORA"));
        expect([SDLVideoStreamingCodec VP8].value).to(equal(@"VP8"));
        expect([SDLVideoStreamingCodec VP9].value).to(equal(@"VP9"));
    });
});

describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLVideoStreamingCodec valueOf:@"H264"]).to(equal([SDLVideoStreamingCodec H264]));
        expect([SDLVideoStreamingCodec valueOf:@"H265"]).to(equal([SDLVideoStreamingCodec H265]));
        expect([SDLVideoStreamingCodec valueOf:@"THEORA"]).to(equal([SDLVideoStreamingCodec THEORA]));
        expect([SDLVideoStreamingCodec valueOf:@"VP8"]).to(equal([SDLVideoStreamingCodec VP8]));
        expect([SDLVideoStreamingCodec valueOf:@"VP9"]).to(equal([SDLVideoStreamingCodec VP9]));
    });

    it(@"Should return nil when invalid", ^ {
        expect([SDLVideoStreamingCodec valueOf:nil]).to(beNil());
        expect([SDLVideoStreamingCodec valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});

describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLVideoStreamingCodec values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLVideoStreamingCodec H264],
                           [SDLVideoStreamingCodec H265],
                           [SDLVideoStreamingCodec THEORA],
                           [SDLVideoStreamingCodec VP8],
                           [SDLVideoStreamingCodec VP9]] copy];
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
