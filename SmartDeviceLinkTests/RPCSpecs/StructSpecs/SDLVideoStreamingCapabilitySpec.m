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
const uint testPreferredFPS = 15;
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
SDLVideoStreamingCapability *capability2 = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:testPreferredResolution2 maxBitrate:@(testMaxBitrate2) supportedFormats:testVideoStreamingFormats hapticSpatialDataSupported:@(testHapticDataSupported2) diagonalScreenSize:@(testDiagonalScreenSize2) pixelPerInch:@(testPixelPerInch2) scale:@(testScale2) preferredFPS:@(testPreferredFPS)];
                                            //initWithPreferredResolution:testPreferredResolution2 maxBitrate:testMaxBitrate2 supportedFormats:testVideoStreamingFormats hapticDataSupported:testHapticDataSupported2 diagonalScreenSize:testDiagonalScreenSize2 pixelPerInch:testPixelPerInch2 scale:testScale2];

SDLImageResolution *testPreferredResolution3 = [[SDLImageResolution alloc] initWithWidth:300 height:150];
SDLVideoStreamingCapability *capability3 = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:testPreferredResolution3 maxBitrate:@(testMaxBitrate3) supportedFormats:testVideoStreamingFormats hapticSpatialDataSupported:@(testHapticDataSupported3) diagonalScreenSize:@(testDiagonalScreenSize3) pixelPerInch:@(testPixelPerInch3) scale:@(testScale3) preferredFPS:@(testPreferredFPS)];
                                            //initWithPreferredResolution:testPreferredResolution3 maxBitrate:testMaxBitrate3 supportedFormats:testVideoStreamingFormats hapticDataSupported:testHapticDataSupported3 diagonalScreenSize:testDiagonalScreenSize3 pixelPerInch:testPixelPerInch3 scale:testScale3];

NSArray *additionalVideoStreamingCapabilities = @[capability2, capability3];

describe(@"initialization tests", ^{
    context(@"initWithDictionary:", ^{
        __block SDLVideoStreamingCapability* testStruct = nil;
        beforeEach(^{
            NSDictionary* dict = @{
                SDLRPCParameterNamePreferredResolution: testPreferredResolution,
                SDLRPCParameterNameMaxBitrate: @(testMaxBitrate),
                SDLRPCParameterNameSupportedFormats: testVideoStreamingFormats,
                SDLRPCParameterNameHapticSpatialDataSupported: @(testHapticDataSupported),
                SDLRPCParameterNameDiagonalScreenSize: @(testDiagonalScreenSize),
                SDLRPCParameterNamePixelPerInch: @(testPixelPerInch),
                SDLRPCParameterNameScale: @(testScale),
                SDLRPCParameterNamePreferredFPS: @(testPreferredFPS),
            };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testStruct = [[SDLVideoStreamingCapability alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        });

        it(@"expect all properties to be set properly", ^{
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

    context(@"init", ^{
        __block SDLVideoStreamingCapability* testStruct = nil;
        beforeEach(^{
            testStruct = [[SDLVideoStreamingCapability alloc] init];
        });

        it(@"expect all properties to be nil", ^{
            expect(testStruct.preferredResolution).to(beNil());
            expect(testStruct.maxBitrate).to(beNil());
            expect(testStruct.supportedFormats).to(beNil());
            expect(testStruct.hapticSpatialDataSupported).to(beNil());
            expect(testStruct.diagonalScreenSize).to(beNil());
            expect(testStruct.pixelPerInch).to(beNil());
            expect(testStruct.scale).to(beNil());
            expect(testStruct.preferredFPS).to(beNil());
        });
    });

    context(@"initWithPreferredResolution:maxBitrate:supportedFormats:hapticDataSupported:diagonalScreenSize:pixelPerInch:scale", ^{
        __block SDLVideoStreamingCapability* testStruct = nil;
        beforeEach(^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testStruct = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:testPreferredResolution maxBitrate:testMaxBitrate supportedFormats:testVideoStreamingFormats hapticDataSupported:testHapticDataSupported diagonalScreenSize:testDiagonalScreenSize pixelPerInch:testPixelPerInch scale:testScale];
#pragma clang diagnostic pop
            testStruct.additionalVideoStreamingCapabilities = additionalVideoStreamingCapabilities;
        });

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.preferredResolution).to(equal(testPreferredResolution));
            expect(testStruct.maxBitrate).to(equal(testMaxBitrate));
            expect(testStruct.supportedFormats).to(equal(testVideoStreamingFormats));
            expect(testStruct.hapticSpatialDataSupported).to(equal(testHapticDataSupported));
            expect(testStruct.diagonalScreenSize).to(equal(testDiagonalScreenSize));
            expect(testStruct.pixelPerInch).to(equal(testPixelPerInch));
            expect(testStruct.scale).to(equal(testScale));
            expect(testStruct.preferredFPS).to(beNil());
            expect(testStruct.additionalVideoStreamingCapabilities).to(haveCount(2));
            expect(testStruct.additionalVideoStreamingCapabilities).to(equal(additionalVideoStreamingCapabilities));
        });
    });
});

describe(@"additional tests", ^{
    __block SDLVideoStreamingCapability* testStruct = nil;
    __block SDLVideoStreamingCapability* testStruct2 = nil;
    SDLVideoStreamingCapability* testObject = (SDLVideoStreamingCapability*)[[NSObject alloc] init];
    beforeEach(^{
        testStruct = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:testPreferredResolution maxBitrate:@(testMaxBitrate) supportedFormats:testVideoStreamingFormats hapticSpatialDataSupported:@(testHapticDataSupported) diagonalScreenSize:@(testDiagonalScreenSize) pixelPerInch:@(testPixelPerInch) scale:@(testScale) preferredFPS:@(testPreferredFPS)];
        testStruct.additionalVideoStreamingCapabilities = additionalVideoStreamingCapabilities;
        testStruct2 = [testStruct copy];
    });

    context(@"isEqual:", ^{
        it(@"expect to be equal", ^{
            expect(testStruct).to(equal(testStruct2));
        });

        // test selected properties one by one
        // note: only one property differs at a time
        it(@"expect to be not equal", ^{
            id stash = nil;
            expect(testStruct).toNot(equal(testObject));

            stash = testStruct2.preferredResolution;
            testStruct2.preferredResolution = [[SDLImageResolution alloc] init];
            expect(testStruct).toNot(equal(testStruct2));
            testStruct2.preferredResolution = stash;
            expect(testStruct).to(equal(testStruct2));

            stash = testStruct2.maxBitrate;
            testStruct2.maxBitrate = @(222);
            expect(testStruct).toNot(equal(testStruct2));
            testStruct2.maxBitrate = stash;
            expect(testStruct).to(equal(testStruct2));

            stash = testStruct2.diagonalScreenSize;
            testStruct2.diagonalScreenSize = @(999);
            expect(testStruct).toNot(equal(testStruct2));
            testStruct2.diagonalScreenSize = stash;
            expect(testStruct).to(equal(testStruct2));

            stash = testStruct2.pixelPerInch;
            testStruct2.pixelPerInch = @(999.5);
            expect(testStruct).toNot(equal(testStruct2));
            testStruct2.pixelPerInch = stash;
            expect(testStruct).to(equal(testStruct2));

            stash = testStruct2.scale;
            testStruct2.scale = @(2.8);
            expect(testStruct).toNot(equal(testStruct2));
            testStruct2.scale = stash;
            expect(testStruct).to(equal(testStruct2));
        });
    });

    context(@"allImageResolutions", ^{
        __block SDLImageResolution *imgResolution2 = nil;
        __block SDLVideoStreamingCapability* capability2 = nil;
        __block SDLImageResolution *imgResolution3 = nil;
        __block SDLVideoStreamingCapability* capability3 = nil;
        __block SDLImageResolution *imgResolution4 = nil;
        __block SDLVideoStreamingCapability* capability4 = nil;
        __block SDLVideoStreamingCapability* testStructX = nil;
        __block SDLImageResolution *imgResolution1 = nil;

        beforeEach(^{
            imgResolution2 = [[SDLImageResolution alloc] initWithWidth:200 height:500];
            capability2 = [testStruct copy];
            capability2.preferredResolution = imgResolution2;

            imgResolution3 = [[SDLImageResolution alloc] initWithWidth:300 height:500];
            capability3 = [testStruct copy];
            capability3.preferredResolution = imgResolution3;

            imgResolution4 = [[SDLImageResolution alloc] initWithWidth:400 height:500];
            capability4 = [testStruct copy];
            capability4.preferredResolution = imgResolution4;


            testStructX = [testStruct copy];
            imgResolution1 = [[SDLImageResolution alloc] initWithWidth:100 height:500];
            testStructX.preferredResolution = imgResolution1;
        });

        it(@"expect result array to contain proper objects where order matters", ^{
            testStructX.additionalVideoStreamingCapabilities = @[capability2, capability3, capability4];
            NSArray<SDLImageResolution *> *allImageResolutions1 = [testStructX allImageResolutions];
            NSArray<SDLImageResolution *> *allImageResolutions2 = @[imgResolution1, imgResolution2, imgResolution3, imgResolution4];
            expect(allImageResolutions1).to(equal(allImageResolutions2));
            // test in backward order
            testStructX.additionalVideoStreamingCapabilities = @[capability4, capability3, capability2];
            allImageResolutions1 = [testStructX allImageResolutions];
            expect(allImageResolutions1).toNot(equal(allImageResolutions2));
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

    it(@"Should initialize correctly with initWithPreferredResolution:maxBitrate:supportedFormats:hapticDataSupported:diagonalScreenSize:pixelPerInch:scale", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLVideoStreamingCapability *testStruct = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:testPreferredResolution maxBitrate:testMaxBitrate supportedFormats:testVideoStreamingFormats hapticDataSupported:testHapticDataSupported diagonalScreenSize:testDiagonalScreenSize pixelPerInch:testPixelPerInch scale:testScale];
#pragma clang diagnostic pop

        expect(testStruct.preferredResolution).to(equal(testPreferredResolution));
        expect(testStruct.maxBitrate).to(equal(testMaxBitrate));
        expect(testStruct.supportedFormats).to(equal(testVideoStreamingFormats));
        expect(testStruct.hapticSpatialDataSupported).to(equal(testHapticDataSupported));
        expect(testStruct.diagonalScreenSize).to(equal(testDiagonalScreenSize));
        expect(testStruct.pixelPerInch).to(equal(testPixelPerInch));
        expect(testStruct.scale).to(equal(testScale));
        expect(testStruct.preferredFPS).to(beNil());
    });

    it(@"Should initialize correctly with initWithPreferredResolution:maxBitrate:supportedFormats:hapticDataSupported:diagonalScreenSize:pixelPerInch:scale:preferredFPS", ^ {
        SDLVideoStreamingCapability *testStruct = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:testPreferredResolution maxBitrate:@(testMaxBitrate) supportedFormats:testVideoStreamingFormats hapticSpatialDataSupported:@(testHapticDataSupported) diagonalScreenSize:@(testDiagonalScreenSize) pixelPerInch:@(testPixelPerInch) scale:@(testScale) preferredFPS:@(testPreferredFPS)];

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
