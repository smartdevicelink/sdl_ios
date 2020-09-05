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
    // setup main & additional capabilities
    const int testMaxBitrate = 100;
    const BOOL testHapticDataSupported = NO;
    const float testDiagonalScreenSize = 22.45f;
    const float testPixelPerInch = 96.122f;
    const float testScale = 2.1f;
    const int testMaxBitrate2 = 100500;
    const BOOL testHapticDataSupported2 = YES;
    const float testDiagonalScreenSize2 = 5.5f;
    const float testPixelPerInch2 = 200.0f;
    const float testScale2 = 1.5f;
    const int testMaxBitrate3 = 200300;
    const BOOL testHapticDataSupported3 = YES;
    const float testDiagonalScreenSize3 = 3.5f;
    const float testPixelPerInch3 = 350.5f;
    const float testScale3 = 3.3f;
    // setup test objects
    SDLImageResolution *testPreferredResolution = [[SDLImageResolution alloc] initWithWidth:600 height:500];

    SDLVideoStreamingFormat *format1 = [[SDLVideoStreamingFormat alloc] init];
    format1.codec = SDLVideoStreamingCodecH264;
    format1.protocol = SDLVideoStreamingProtocolRTP;

    SDLVideoStreamingFormat *format2 = [[SDLVideoStreamingFormat alloc] init];
    format2.codec = SDLVideoStreamingCodecH265;
    format2.protocol = SDLVideoStreamingProtocolRTSP;

    NSArray<SDLVideoStreamingFormat *> *testVideoStreamingFormats = @[format1, format2];

    SDLImageResolution *testPreferredResolution2 = [[SDLImageResolution alloc] initWithWidth:100 height:200];
    SDLVideoStreamingCapability *capability2 = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:testPreferredResolution2 maxBitrate:testMaxBitrate2 supportedFormats:testVideoStreamingFormats hapticDataSupported:testHapticDataSupported2 diagonalScreenSize:testDiagonalScreenSize2 pixelPerInch:testPixelPerInch2 scale:testScale2];

    SDLImageResolution *testPreferredResolution3 = [[SDLImageResolution alloc] initWithWidth:300 height:150];
    SDLVideoStreamingCapability *capability3 = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:testPreferredResolution3 maxBitrate:testMaxBitrate3 supportedFormats:testVideoStreamingFormats hapticDataSupported:testHapticDataSupported3 diagonalScreenSize:testDiagonalScreenSize3 pixelPerInch:testPixelPerInch3 scale:testScale3];

    NSArray *additionalVideoStreamingCapabilities = @[capability2, capability3];

    context(@"initWithDictionary:", ^{
        NSDictionary* dict = @{
                                SDLRPCParameterNamePreferredResolution: testPreferredResolution,
                                SDLRPCParameterNameMaxBitrate: @(testMaxBitrate),
                                SDLRPCParameterNameSupportedFormats: testVideoStreamingFormats,
                                SDLRPCParameterNameHapticSpatialDataSupported: @(testHapticDataSupported),
                                SDLRPCParameterNameDiagonalScreenSize: @(testDiagonalScreenSize),
                                SDLRPCParameterNamePixelPerInch: @(testPixelPerInch),
                                SDLRPCParameterNameScale: @(testScale)
        };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLVideoStreamingCapability* testStruct = [[SDLVideoStreamingCapability alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.preferredResolution).to(equal(testPreferredResolution));
            expect(testStruct.maxBitrate).to(equal(testMaxBitrate));
            expect(testStruct.supportedFormats).to(equal(testVideoStreamingFormats));
            expect(testStruct.hapticSpatialDataSupported).to(equal(testHapticDataSupported));
            expect(testStruct.diagonalScreenSize).to(equal(testDiagonalScreenSize));
            expect(testStruct.pixelPerInch).to(equal(testPixelPerInch));
            expect(testStruct.scale).to(equal(testScale));
        });
    });

    context(@"init", ^{
        SDLVideoStreamingCapability* testStruct = [[SDLVideoStreamingCapability alloc] init];

        it(@"Should return nil if not set", ^{
            expect(testStruct.preferredResolution).to(beNil());
            expect(testStruct.maxBitrate).to(beNil());
            expect(testStruct.supportedFormats).to(beNil());
            expect(testStruct.hapticSpatialDataSupported).to(beNil());
            expect(testStruct.diagonalScreenSize).to(beNil());
            expect(testStruct.pixelPerInch).to(beNil());
            expect(testStruct.scale).to(beNil());
        });
    });

    context(@"init & assign", ^{
        SDLVideoStreamingCapability* testStruct = [[SDLVideoStreamingCapability alloc] init];
        testStruct.additionalVideoStreamingCapabilities = additionalVideoStreamingCapabilities;
        testStruct.preferredResolution = testPreferredResolution;
        testStruct.maxBitrate = @(testMaxBitrate);
        testStruct.supportedFormats = testVideoStreamingFormats;
        testStruct.hapticSpatialDataSupported = @(testHapticDataSupported);
        testStruct.diagonalScreenSize = @(testDiagonalScreenSize);
        testStruct.pixelPerInch = @(testPixelPerInch);
        testStruct.scale = @(testScale);

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.preferredResolution).to(equal(testPreferredResolution));
            expect(testStruct.maxBitrate).to(equal(testMaxBitrate));
            expect(testStruct.supportedFormats).to(equal(testVideoStreamingFormats));
            expect(testStruct.hapticSpatialDataSupported).to(equal(testHapticDataSupported));
            expect(testStruct.diagonalScreenSize).to(equal(testDiagonalScreenSize));
            expect(testStruct.pixelPerInch).to(equal(testPixelPerInch));
            expect(testStruct.scale).to(equal(testScale));
            expect(testStruct.additionalVideoStreamingCapabilities).to(haveCount(2));
            expect(testStruct.additionalVideoStreamingCapabilities).to(equal(additionalVideoStreamingCapabilities));
        });
    });

    context(@"initWithPreferredResolution:maxBitrate:supportedFormats:hapticDataSupported:diagonalScreenSize:pixelPerInch:scale", ^{
        SDLVideoStreamingCapability* testStruct = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:testPreferredResolution maxBitrate:testMaxBitrate supportedFormats:testVideoStreamingFormats hapticDataSupported:testHapticDataSupported diagonalScreenSize:testDiagonalScreenSize pixelPerInch:testPixelPerInch scale:testScale];
        testStruct.additionalVideoStreamingCapabilities = additionalVideoStreamingCapabilities;

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.preferredResolution).to(equal(testPreferredResolution));
            expect(testStruct.maxBitrate).to(equal(testMaxBitrate));
            expect(testStruct.supportedFormats).to(equal(testVideoStreamingFormats));
            expect(testStruct.hapticSpatialDataSupported).to(equal(testHapticDataSupported));
            expect(testStruct.diagonalScreenSize).to(equal(testDiagonalScreenSize));
            expect(testStruct.pixelPerInch).to(equal(testPixelPerInch));
            expect(testStruct.scale).to(equal(testScale));
            expect(testStruct.additionalVideoStreamingCapabilities).to(haveCount(2));
            expect(testStruct.additionalVideoStreamingCapabilities).to(equal(additionalVideoStreamingCapabilities));
        });
    });

    context(@"initWithPreferredResolution:maxBitrate:supportedFormats:hapticDataSupported:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLVideoStreamingCapability *testStruct = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:testPreferredResolution maxBitrate:testMaxBitrate supportedFormats:testVideoStreamingFormats hapticDataSupported:testHapticDataSupported];
#pragma clang diagnostic pop

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.preferredResolution).to(equal(testPreferredResolution));
            expect(testStruct.maxBitrate).to(equal(testMaxBitrate));
            expect(testStruct.supportedFormats).to(equal(testVideoStreamingFormats));
            expect(testStruct.hapticSpatialDataSupported).to(equal(testHapticDataSupported));
            expect(testStruct.diagonalScreenSize).to(beNil());
            expect(testStruct.pixelPerInch).to(beNil());
            expect(testStruct.scale).to(beNil());
        });
    });
});

QuickSpecEnd
