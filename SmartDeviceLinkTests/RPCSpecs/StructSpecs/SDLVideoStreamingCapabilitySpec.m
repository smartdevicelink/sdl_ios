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
     __block SDLImageResolution *testPreferredResolution = nil;
     __block int testMaxBitrate = 100;
     __block NSArray<SDLVideoStreamingFormat *> *testVideoStreamingFormats = nil;
     __block BOOL testHapticDataSupported = false;
     __block float testDiagonalScreenSize = 22.45;
     __block float testPixelPerInch = 96.122;
     __block float testScale = 2.1;
     __block int testPreferredFPS = 15;

    beforeEach(^{
        testPreferredResolution = [[SDLImageResolution alloc] initWithWidth:600 height:500];

        SDLVideoStreamingFormat *format1 = [[SDLVideoStreamingFormat alloc] init];
        format1.codec = SDLVideoStreamingCodecH264;
        format1.protocol = SDLVideoStreamingProtocolRTP;

        SDLVideoStreamingFormat *format2 = [[SDLVideoStreamingFormat alloc] init];
        format2.codec = SDLVideoStreamingCodecH265;
        format2.protocol = SDLVideoStreamingProtocolRTSP;

        testVideoStreamingFormats = @[format1, format2];
    });

    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSDictionary* dict = @{SDLRPCParameterNamePreferredResolution: testPreferredResolution,
                               SDLRPCParameterNameMaxBitrate: @(testMaxBitrate),
                               SDLRPCParameterNameSupportedFormats: testVideoStreamingFormats,
                               SDLRPCParameterNameHapticSpatialDataSupported: @(testHapticDataSupported),
                               SDLRPCParameterNameDiagonalScreenSize: @(testDiagonalScreenSize),
                               SDLRPCParameterNamePixelPerInch: @(testPixelPerInch),
                               SDLRPCParameterNameScale: @(testScale),
                               SDLRPCParameterNamePreferredFPS: @(testPreferredFPS)};

        SDLVideoStreamingCapability* testStruct = [[SDLVideoStreamingCapability alloc] initWithDictionary:dict];

        expect(testStruct.preferredResolution).to(equal(testPreferredResolution));
        expect(testStruct.maxBitrate).to(equal(testMaxBitrate));
        expect(testStruct.supportedFormats).to(equal(testVideoStreamingFormats));
        expect(testStruct.hapticSpatialDataSupported).to(equal(testHapticDataSupported));
        expect(testStruct.diagonalScreenSize).to(equal(testDiagonalScreenSize));
        expect(testStruct.pixelPerInch).to(equal(testPixelPerInch));
        expect(testStruct.scale).to(equal(testScale));
        expect(testStruct.preferredFPS).to(equal(testPreferredFPS));
    });

    it(@"Should return nil if not set", ^ {
        SDLVideoStreamingCapability* testStruct = [[SDLVideoStreamingCapability alloc] init];

        expect(testStruct.preferredResolution).to(beNil());
        expect(testStruct.maxBitrate).to(beNil());
        expect(testStruct.supportedFormats).to(beNil());
        expect(testStruct.hapticSpatialDataSupported).to(beNil());
        expect(testStruct.diagonalScreenSize).to(beNil());
        expect(testStruct.pixelPerInch).to(beNil());
        expect(testStruct.scale).to(beNil());
        expect(testStruct.preferredFPS).to(beNil());
    });

    it(@"Should initialize correctly with initWithPreferredResolution:maxBitrate:supportedFormats:hapticDataSupported:diagonalScreenSize:pixelPerInch:scale", ^ {
        SDLVideoStreamingCapability *testStruct = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:testPreferredResolution maxBitrate:testMaxBitrate supportedFormats:testVideoStreamingFormats hapticDataSupported:testHapticDataSupported diagonalScreenSize:testDiagonalScreenSize pixelPerInch:testPixelPerInch scale:testScale];

        expect(testStruct.preferredResolution).to(equal(testPreferredResolution));
        expect(testStruct.maxBitrate).to(equal(testMaxBitrate));
        expect(testStruct.supportedFormats).to(equal(testVideoStreamingFormats));
        expect(testStruct.hapticSpatialDataSupported).to(equal(testHapticDataSupported));
        expect(testStruct.diagonalScreenSize).to(equal(testDiagonalScreenSize));
        expect(testStruct.pixelPerInch).to(equal(testPixelPerInch));
        expect(testStruct.scale).to(equal(testScale));
        expect(testStruct.preferredFPS).to(equal(testPreferredFPS));
    });
});

QuickSpecEnd
