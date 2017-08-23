//
//  SDLVideoStreamingCapabilitySpec.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLImageResolution.h"
#import "SDLVideoStreamingCapability.h"
#import "SDLVideoStreamingCodec.h"
#import "SDLVideoStreamingFormat.h"
#import "SDLVideoStreamingProtocol.h"

QuickSpecBegin(SDLVideoStreamingCapabilitySpec)

describe(@"Initialization tests", ^{
    it(@"Should get correctly when initialized with a dictionary", ^ {
        SDLImageResolution* resolution = [[SDLImageResolution alloc] init];
        resolution.resolutionWidth = @600;
        resolution.resolutionHeight = @500;

        NSNumber *maxBitrate = @100;
        NSNumber *hapticSpatialDataSupported = @NO;

        SDLVideoStreamingFormat *format1 = [[SDLVideoStreamingFormat alloc] init];
        format1.codec = [SDLVideoStreamingCodec H264];
        format1.protocol = [SDLVideoStreamingProtocol RTP];

        SDLVideoStreamingFormat *format2 = [[SDLVideoStreamingFormat alloc] init];
        format2.codec = [SDLVideoStreamingCodec H265];
        format2.protocol = [SDLVideoStreamingProtocol RTSP];

        NSArray<SDLVideoStreamingFormat *> *formatArray = @[format1, format2];

        NSMutableDictionary* dict = [@{NAMES_preferredResolution: resolution,
                                       NAMES_maxBitrate: maxBitrate,
                                       NAMES_supportedFormats: formatArray,
                                       NAMES_hapticSpatialDataSupported: hapticSpatialDataSupported} mutableCopy];

        SDLVideoStreamingCapability* testStruct = [[SDLVideoStreamingCapability alloc] initWithDictionary:dict];

        expect(testStruct.preferredResolution).to(equal(resolution));
        expect(testStruct.maxBitrate).to(equal(maxBitrate));
        expect(testStruct.supportedFormats).to(equal(formatArray));
        expect(testStruct.hapticSpatialDataSupported).to(equal(hapticSpatialDataSupported));
    });

    it(@"Should return nil if not set", ^ {
        SDLVideoStreamingCapability* testStruct = [[SDLVideoStreamingCapability alloc] init];

        expect(testStruct.preferredResolution).to(beNil());
        expect(testStruct.maxBitrate).to(beNil());
        expect(testStruct.supportedFormats).to(beNil());
        expect(testStruct.hapticSpatialDataSupported).to(beNil());
    });

    it(@"Should initialize correctly with initWithVideoStreaming:(SDLImageResolution *)preferredResolution (NSNumber *)maxBitrate (NSArray<SDLVideoStreamingFormat *> *)suportedFormats", ^ {
        SDLImageResolution* resolution = [[SDLImageResolution alloc] init];
        resolution.resolutionWidth = @600;
        resolution.resolutionHeight = @500;

        NSNumber *maxBitrate = @100;
        NSNumber *hapticSpatialDataSupported = @YES;

        SDLVideoStreamingFormat *format1 = [[SDLVideoStreamingFormat alloc] init];
        format1.codec = [SDLVideoStreamingCodec H264];
        format1.protocol = [SDLVideoStreamingProtocol RTP];

        SDLVideoStreamingFormat *format2 = [[SDLVideoStreamingFormat alloc] init];
        format2.codec = [SDLVideoStreamingCodec H265];
        format2.protocol = [SDLVideoStreamingProtocol RTSP];

        NSArray<SDLVideoStreamingFormat *> *formatArray = @[format1, format2];

        SDLVideoStreamingCapability *testStruct = [[SDLVideoStreamingCapability alloc] initWithVideoStreaming:resolution maxBitrate:maxBitrate supportedFormats:formatArray hapticDataSupported:hapticSpatialDataSupported];

        expect(testStruct.preferredResolution).to(equal(resolution));
        expect(testStruct.maxBitrate).to(equal(maxBitrate));
        expect(testStruct.supportedFormats).to(equal(formatArray));
        expect(testStruct.hapticSpatialDataSupported).to(equal(hapticSpatialDataSupported));
    });

});

QuickSpecEnd
