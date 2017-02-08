//
//  SDLVideoEncoderSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 2/7/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLVideoEncoder.h"
#import <AVFoundation/AVFoundation.h>

QuickSpecBegin(SDLVideoEncoderSpec)

describe(@"a video encoder", ^{
    __block SDLVideoEncoder *testVideoEncoder = nil;
    __block CGSize testSize = CGSizeMake(100, 200);
    __block id videoEncoderDelegateMock = OCMProtocolMock(@protocol(SDLVideoEncoderDelegate));
    __block NSError *testError = nil;
    
    context(@"if using default video encoder settings", ^{
        
        beforeEach(^{
            testVideoEncoder = [[SDLVideoEncoder alloc] initWithDimensions:testSize delegate:videoEncoderDelegateMock error:&testError];
        });
        
        it(@"should initialize properties", ^{
            expect(testVideoEncoder).toNot(beNil());
            expect(testVideoEncoder.videoEncoderSettings).to(equal(testVideoEncoder.defaultVideoEncoderSettings));
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
                testVideoEncoder = [[SDLVideoEncoder alloc] initWithDimensions:testSize properties:testSettings delegate:videoEncoderDelegateMock error:&testError];
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
                testVideoEncoder = [[SDLVideoEncoder alloc] initWithDimensions:testSize properties:testSettings delegate:videoEncoderDelegateMock error:&testError];
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
