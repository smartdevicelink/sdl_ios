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

#import "SDLRPCParameterNames.h"
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
        NSNumber *diagonalScreenSize = @22;
        NSNumber *pixelPerInch = @96;
        NSNumber *scale = @1;

        SDLVideoStreamingFormat *format1 = [[SDLVideoStreamingFormat alloc] init];
        format1.codec = SDLVideoStreamingCodecH264;
        format1.protocol = SDLVideoStreamingProtocolRTP;

        SDLVideoStreamingFormat *format2 = [[SDLVideoStreamingFormat alloc] init];
        format2.codec = SDLVideoStreamingCodecH265;
        format2.protocol = SDLVideoStreamingProtocolRTSP;

        NSArray<SDLVideoStreamingFormat *> *formatArray = @[format1, format2];

        NSMutableDictionary* dict = [@{SDLRPCParameterNamePreferredResolution: resolution,
                                       SDLRPCParameterNameMaxBitrate: maxBitrate,
                                       SDLRPCParameterNameSupportedFormats: formatArray,
                                       SDLRPCParameterNameHapticSpatialDataSupported: hapticDataSupported,
                                       SDLRPCParameterNameDiagonalScreenSize: diagonalScreenSize,
                                       SDLRPCParameterNamePixelPerInch: pixelPerInch,
                                       SDLRPCParameterNameScale: scale} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLVideoStreamingCapability* testStruct = [[SDLVideoStreamingCapability alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

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
        expect(testStruct.diagonalScreenSize).to(beNil());
        expect(testStruct.pixelPerInch).to(beNil());
        expect(testStruct.scale).to(equal(1));
    });

    it(@"Should initialize correctly with initWithVideoStreaming:maxBitrate:suportedFormats", ^ {
        SDLImageResolution* resolution = [[SDLImageResolution alloc] init];
        resolution.resolutionWidth = @600;
        resolution.resolutionHeight = @500;

        int32_t maxBitrate = 100;
        NSNumber *hapticDataSupported = @YES;
        float diagonalScreenSize = 22.0;
        float pixelPerInch = 96.0;
        float scale = 1.0;

        SDLVideoStreamingFormat *format1 = [[SDLVideoStreamingFormat alloc] init];
        format1.codec = SDLVideoStreamingCodecH264;
        format1.protocol = SDLVideoStreamingProtocolRTP;

        SDLVideoStreamingFormat *format2 = [[SDLVideoStreamingFormat alloc] init];
        format2.codec = SDLVideoStreamingCodecH265;
        format2.protocol = SDLVideoStreamingProtocolRTSP;

        NSArray<SDLVideoStreamingFormat *> *formatArray = @[format1, format2];

        SDLVideoStreamingCapability *testStruct = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:resolution maxBitrate:maxBitrate supportedFormats:formatArray hapticDataSupported:hapticDataSupported diagonalScreenSize:diagonalScreenSize pixelPerInch:pixelPerInch scale:scale];

        expect(testStruct.preferredResolution).to(equal(resolution));
        expect(testStruct.maxBitrate).to(equal(maxBitrate));
        expect(testStruct.supportedFormats).to(equal(formatArray));
        expect(testStruct.hapticSpatialDataSupported).to(equal(hapticDataSupported));
        expect(testStruct.diagonalScreenSize).to(equal(diagonalScreenSize));
        expect(testStruct.pixelPerInch).to(equal(pixelPerInch));
        expect(testStruct.scale).to(equal(scale));
    });
    
});

QuickSpecEnd
