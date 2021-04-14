//
//  SDLSDLCarWindowSpec.m
//  SmartDeviceLinkTests
//

#import <AVFoundation/AVFoundation.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLCarWindow.h"
#import "SDLStreamingVideoLifecycleManager.h"
#import "SDLStreamingMediaConfiguration.h"
#import "SDLVideoStreamingCapability.h"
#import "SDLStreamingVideoScaleManager.h"
#import "TestSmartConnectionManager.h"
#import "SDLStateMachine.h"

@interface SDLCarWindow (discover_internals)
+ (nullable CVPixelBufferRef)sdl_createPixelBufferForImageRef:(CGImageRef)imageRef usingPool:(CVPixelBufferPoolRef)pool;
@end

@interface SDLStreamingVideoLifecycleManager(discover_internals)
@property (strong, nonatomic, readonly) SDLStateMachine *videoStreamStateMachine;
- (void)sdl_applyVideoCapability:(SDLVideoStreamingCapability *)capability;
@end

@interface SDLStreamingVideoLifecycleExtendedTestManager : SDLStreamingVideoLifecycleManager
@property (assign) BOOL isVideoConnectedTest;
@property (assign) BOOL isVideoStreamingPausedTest;
@property (assign) BOOL sendVideoDataDidCall;
@end


@implementation SDLStreamingVideoLifecycleExtendedTestManager {
    VTCompressionSessionRef session;
    CVPixelBufferPoolRef pool;
}

- (BOOL)isVideoConnected {
    return self.isVideoConnectedTest;
}

- (BOOL)isVideoStreamingPaused {
    return self.isVideoStreamingPausedTest;
}

- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer {
    self.sendVideoDataDidCall = YES;
    return YES;
}

- (CVPixelBufferPoolRef)pixelBufferPool {
    if (pool) {
        return pool;
    }
    OSStatus status = VTCompressionSessionCreate(NULL, 64, 64, kCMVideoCodecType_H264, NULL, NULL, NULL, NULL, NULL, &session);
    if (0 != status) {
        NSLog(@"Cannot create compression session");
        return NULL;
    }
    pool = VTCompressionSessionGetPixelBufferPool(session);
    return pool;
}

@end

QuickSpecBegin(SDLCarWindowSpec)

describe(@"test car window", ^{
    UIViewController *rootViewController = [[UIViewController alloc] init];

    context(@"init and assign", ^{
        SDLCarWindow *carWindow = [[SDLCarWindow alloc] init];
        carWindow.rootViewController = rootViewController;
        it(@"make sure object created and all set", ^{
            expect(carWindow).toNot(beNil());
            expect(carWindow.rootViewController).toEventually(equal(rootViewController));
        });
    });

    context(@"initWithStreamManager:configuration:", ^{
        SDLStreamingVideoLifecycleManager *videoManager = OCMClassMock([SDLStreamingVideoLifecycleManager class]);
        SDLStreamingMediaConfiguration *config = OCMClassMock([SDLStreamingMediaConfiguration class]);
        SDLCarWindow *carWindow = [[SDLCarWindow alloc] initWithStreamManager:videoManager configuration:config];
        carWindow.rootViewController = rootViewController;
        it(@"make sure object created and all set", ^{
            expect(carWindow).toNot(beNil());
            expect(carWindow.rootViewController).toEventually(equal(rootViewController));
        });
    });

    context(@"compression session and pixel buffer", ^{
        UInt8 pixelData[64 * 64 * 3] = {0};
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        CFDataRef rgbData = CFDataCreate(NULL, pixelData, 64 * 64 * 3);
        CGDataProviderRef provider = CGDataProviderCreateWithCFData(rgbData);
        CGImageRef rgbImageRef = CGImageCreate(64, 64, 8, 24, 64 * 3, colorspace, kCGBitmapByteOrderDefault, provider, NULL, true, kCGRenderingIntentDefault);
        CFRelease(rgbData);
        CGDataProviderRelease(provider);
        CGColorSpaceRelease(colorspace);

        VTCompressionSessionRef session;
        OSStatus status = VTCompressionSessionCreate(NULL, 64, 64, kCMVideoCodecType_H264, NULL, NULL, NULL, NULL, NULL, &session);
        CVPixelBufferPoolRef pool = VTCompressionSessionGetPixelBufferPool(session);
        CVPixelBufferRef pxBuffer = [SDLCarWindow sdl_createPixelBufferForImageRef:rgbImageRef usingPool:pool];

        it(@"expect pixel buffer to be created", ^{
            expect(status).to(equal(0));
            expect((id)CFBridgingRelease(pxBuffer)).toNot(beNil());
            CGImageRelease(rgbImageRef);
        });
    });

    context(@"initWithStreamManager:configuration:", ^{
        id<SDLConnectionManagerType> mockConnectionManager = OCMProtocolMock(@protocol(SDLConnectionManagerType));
        SDLConfiguration *configuration = [[SDLConfiguration alloc] init];
        SDLStreamingVideoLifecycleExtendedTestManager *streamingLifecycleManager = [[SDLStreamingVideoLifecycleExtendedTestManager alloc] initWithConnectionManager:mockConnectionManager configuration:configuration systemCapabilityManager:nil];
        SDLStreamingMediaConfiguration *config = [SDLStreamingMediaConfiguration autostreamingInsecureConfigurationWithInitialViewController:rootViewController];
        SDLCarWindow *carWindow = [[SDLCarWindow alloc] initWithStreamManager:streamingLifecycleManager configuration:config];
        carWindow.rootViewController = rootViewController;
        const CGRect frame = CGRectMake(0, 0, 200, 400);
        rootViewController.view.frame = frame;

        streamingLifecycleManager.videoScaleManager.displayViewportResolution = CGSizeMake(100, 200);
        SDLImageResolution *imgResolution = [[SDLImageResolution alloc] initWithWidth:200 height:300];
        const float scale = 2.0;
        SDLVideoStreamingCapability *videoStreamingCapability = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:imgResolution maxBitrate:nil supportedFormats:nil hapticSpatialDataSupported:nil diagonalScreenSize:@(2.5) pixelPerInch:@(300) scale:@(scale) preferredFPS:nil];
        [streamingLifecycleManager sdl_applyVideoCapability:videoStreamingCapability];


        it(@"make sure object created and all set", ^{
            expect(carWindow).toNot(beNil());

            SDLVideoStreamingCapability *videoStreamingCapability = nil;

            dispatch_async(dispatch_get_main_queue(), ^{
                // keep weak ref to streamingLifecycleManager alive
                expect(streamingLifecycleManager).notTo(beNil());
                expect(carWindow.rootViewController).to(equal(rootViewController));
                expect(CGSizeEqualToSize(frame.size, rootViewController.view.frame.size)).to(beTrue());
                [carWindow updateVideoStreamingCapability:videoStreamingCapability];

                const CGSize scaledSize = CGSizeMake(imgResolution.resolutionWidth.floatValue/scale, imgResolution.resolutionHeight.floatValue/scale);
                expect(CGSizeEqualToSize(scaledSize, rootViewController.view.frame.size)).to(beTrue());

                SDLImageResolution *resolution = nil;
                SDLVideoStreamingCapability *videoStreamingCapability2 = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:resolution maxBitrate:@(999) supportedFormats:nil hapticSpatialDataSupported:@YES diagonalScreenSize:@(2.2) pixelPerInch:@(100) scale:@(1) preferredFPS:nil];
                [carWindow updateVideoStreamingCapability:videoStreamingCapability2];
                // the size should not change
                expect(CGSizeEqualToSize(scaledSize, rootViewController.view.frame.size)).to(beTrue());

                // make sure pixel data gets sent (fake send is being called)
                [carWindow syncFrame];
                streamingLifecycleManager.isVideoConnectedTest = YES;
                expect(streamingLifecycleManager.sendVideoDataDidCall).to(beFalse());
                [carWindow syncFrame];
                expect(streamingLifecycleManager.sendVideoDataDidCall).to(beTrue());

                streamingLifecycleManager.sendVideoDataDidCall = NO;
                streamingLifecycleManager.videoScaleManager.displayViewportResolution = CGSizeMake(-1, -1);

                // should not get called with wrong resolution
                expect(streamingLifecycleManager.sendVideoDataDidCall).to(beFalse());
                [carWindow syncFrame];
                expect(streamingLifecycleManager.sendVideoDataDidCall).to(beFalse());
            });
        });
    });
});

QuickSpecEnd
