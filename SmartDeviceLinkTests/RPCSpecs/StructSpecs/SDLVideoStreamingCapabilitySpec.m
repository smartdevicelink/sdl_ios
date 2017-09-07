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
        NSNumber *hapticDataSupported = @NO;

        SDLVideoStreamingFormat *format1 = [[SDLVideoStreamingFormat alloc] init];
        format1.codec = SDLVideoStreamingCodecH264;
        format1.protocol = SDLVideoStreamingProtocolRTP;

        SDLVideoStreamingFormat *format2 = [[SDLVideoStreamingFormat alloc] init];
        format2.codec = SDLVideoStreamingCodecH265;
        format2.protocol = SDLVideoStreamingProtocolRTSP;

        NSArray<SDLVideoStreamingFormat *> *formatArray = @[format1, format2];

        NSMutableDictionary* dict = [@{SDLNamePreferredResolution: resolution,
                                       SDLNameMaxBitrate: maxBitrate,
                                       SDLNameSupportedFormats: formatArray,
                                       SDLNameHapticSpatialDataSupported: hapticDataSupported} mutableCopy];

        SDLVideoStreamingCapability* testStruct = [[SDLVideoStreamingCapability alloc] initWithDictionary:dict];

        expect(testStruct.preferredResolution).to(equal(resolution));
        expect(testStruct.maxBitrate).to(equal(maxBitrate));
        expect(testStruct.supportedFormats).to(equal(formatArray));
        expect(testStruct.hapticSpatialDataSupported).to(equal(hapticDataSupported));
    });

    it(@"Should return nil if not set", ^ {
        SDLVideoStreamingCapability* testStruct = [[SDLVideoStreamingCapability alloc] init];

        expect(testStruct.preferredResolution).to(beNil());
        expect(testStruct.maxBitrate).to(beNil());
        expect(testStruct.supportedFormats).to(beNil());
    });

    it(@"Should initialize correctly with initWithVideoStreaming:maxBitrate:suportedFormats", ^ {
        SDLImageResolution* resolution = [[SDLImageResolution alloc] init];
        resolution.resolutionWidth = @600;
        resolution.resolutionHeight = @500;

        int32_t maxBitrate = 100;
        NSNumber *hapticDataSupported = @YES;

        SDLVideoStreamingFormat *format1 = [[SDLVideoStreamingFormat alloc] init];
        format1.codec = SDLVideoStreamingCodecH264;
        format1.protocol = SDLVideoStreamingProtocolRTP;

        SDLVideoStreamingFormat *format2 = [[SDLVideoStreamingFormat alloc] init];
        format2.codec = SDLVideoStreamingCodecH265;
        format2.protocol = SDLVideoStreamingProtocolRTSP;

        NSArray<SDLVideoStreamingFormat *> *formatArray = @[format1, format2];

        SDLVideoStreamingCapability *testStruct = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:resolution maxBitrate:maxBitrate supportedFormats:formatArray hapticDataSupported:hapticDataSupported];

        expect(testStruct.preferredResolution).to(equal(resolution));
        expect(testStruct.maxBitrate).to(equal(maxBitrate));
        expect(testStruct.supportedFormats).to(equal(formatArray));
        expect(testStruct.hapticSpatialDataSupported).to(equal(hapticDataSupported));
    });
    
});

QuickSpecEnd
