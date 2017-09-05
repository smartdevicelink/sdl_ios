//
//  SDLVideoEncoderSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 2/7/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLH264VideoEncoder.h"
#import "SDLVideoStreamingProtocol.h"

QuickSpecBegin(SDLH264VideoEncoderSpec)

describe(@"a video encoder", ^{
    __block SDLH264VideoEncoder *testVideoEncoder = nil;
    __block CGSize testSize = CGSizeMake(100, 200);
    __block id videoEncoderDelegateMock = OCMProtocolMock(@protocol(SDLVideoEncoderDelegate));
    __block NSError *testError = nil;
    __block SDLVideoStreamingProtocol testProtocol = SDLVideoStreamingProtocolRAW;
    
    context(@"if using default video encoder settings", ^{
        beforeEach(^{
            testVideoEncoder = [[SDLH264VideoEncoder alloc] initWithProtocol:testProtocol dimensions:testSize properties:SDLH264VideoEncoder.defaultVideoEncoderSettings delegate:videoEncoderDelegateMock error:&testError];
        });
        
        it(@"should initialize properties", ^{
            expect(testVideoEncoder).toNot(beNil());
            expect(testVideoEncoder.videoEncoderSettings).to(equal(SDLH264VideoEncoder.defaultVideoEncoderSettings));
            expect(@(testVideoEncoder.pixelBufferPool == NULL)).to(equal(@NO));
            expect(testError).to(beNil());
            
            NSDictionary *pixelBufferProperties = (__bridge NSDictionary*)CVPixelBufferPoolGetPixelBufferAttributes(testVideoEncoder.pixelBufferPool);
            expect(pixelBufferProperties[(__bridge NSString*)kCVPixelBufferWidthKey]).to(equal(@100));
            expect(pixelBufferProperties[(__bridge NSString*)kCVPixelBufferHeightKey]).to(equal(@200));
        });
        
        context(@"when stopping", ^{
            beforeEach(^{
                [testVideoEncoder stop];
            });
            
            it(@"should have a nil pixel buffer pool", ^{
                expect(@(testVideoEncoder.pixelBufferPool == NULL)).to(equal(@YES));
            });
        });
    });
    
    context(@"is using custom video encoder settings", ^{
        __block NSDictionary *testSettings = nil;
        
        context(@"that is a valid setting", ^{
            beforeEach(^{
                testSettings = @{
                                 (__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate : @1
                                 };

                testVideoEncoder = [[SDLH264VideoEncoder alloc] initWithProtocol:testProtocol dimensions:testSize properties:SDLH264VideoEncoder.defaultVideoEncoderSettings delegate:videoEncoderDelegateMock error:&testError];
            });
            
            it(@"should initialize properties", ^{
                expect(testVideoEncoder).toNot(beNil());
                expect(testVideoEncoder.videoEncoderSettings).to(equal(testSettings));
                expect(@(testVideoEncoder.pixelBufferPool == NULL)).to(equal(@NO));
                expect(testError).to(beNil());
                
                NSDictionary *pixelBufferProperties = (__bridge NSDictionary*)CVPixelBufferPoolGetPixelBufferAttributes(testVideoEncoder.pixelBufferPool);
                expect(pixelBufferProperties[(__bridge NSString*)kCVPixelBufferWidthKey]).to(equal(@100));
                expect(pixelBufferProperties[(__bridge NSString*)kCVPixelBufferHeightKey]).to(equal(@200));
            });
        });
        
        context(@"that is not a valid setting", ^{
            beforeEach(^{
                testSettings = @{
                                 @"Bad" : @"Property"
                                 };
                testVideoEncoder = [[SDLH264VideoEncoder alloc] initWithProtocol:testProtocol dimensions:testSize properties:SDLH264VideoEncoder.defaultVideoEncoderSettings delegate:videoEncoderDelegateMock error:&testError];
            });
            
            it(@"should not be initialized", ^{
                expect(testVideoEncoder).to(beNil());
                expect(testVideoEncoder.videoEncoderSettings).to(beNil());
                expect(@(testVideoEncoder.pixelBufferPool == NULL)).to(equal(@YES));
                expect(testError).to(equal([NSError errorWithDomain:SDLErrorDomainVideoEncoder code:SDLVideoEncoderErrorConfigurationCompressionSessionSetPropertyFailure userInfo:@{ NSLocalizedDescriptionKey : @"\"Bad\" is not a supported key." }]));
            });
        });
    });
});

QuickSpecEnd
