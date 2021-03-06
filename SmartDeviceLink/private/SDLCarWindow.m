//
//  SDLCarWindow.m
//  Projection
//
//  Originally created by Muller, Alexander (A.) on 10/6/16.
//  Copyright © 2016 Ford Motor Company. All rights reserved.
//
//  Updated by Joel Fischer, Livio Inc., on 11/27/17.

#import <CommonCrypto/CommonDigest.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "SDLCarWindow.h"
#import "SDLGlobals.h"
#import "SDLImageResolution.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLError.h"
#import "SDLStateMachine.h"
#import "SDLStreamingMediaConfiguration.h"
#import "SDLStreamingVideoLifecycleManager.h"
#import "SDLStreamingVideoScaleManager.h"
#import "SDLStreamingMediaManagerConstants.h"
#import "SDLVideoStreamingCapability.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLCarWindow ()

@property (weak, nonatomic, nullable) SDLStreamingVideoLifecycleManager *streamManager;

@property (assign, nonatomic) SDLCarWindowRenderingType renderingType;
@property (assign, nonatomic) BOOL allowMultipleOrientations;

@property (assign, nonatomic, getter=isLockScreenPresenting) BOOL lockScreenPresenting;
@property (assign, nonatomic, getter=isLockScreenDismissing) BOOL lockScreenBeingDismissed;

@property (assign, nonatomic, getter=isVideoStreamStarted) BOOL videoStreamStarted;

@end

@implementation SDLCarWindow

- (instancetype)initWithStreamManager:(SDLStreamingVideoLifecycleManager *)streamManager configuration:(SDLStreamingMediaConfiguration *)configuration {
    self = [super init];
    if (!self) { return nil; }

    _streamManager = streamManager;
    _renderingType = configuration.carWindowRenderingType;
    _allowMultipleOrientations = configuration.allowMultipleViewControllerOrientations;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didReceiveVideoStreamStarted:) name:SDLVideoStreamDidStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didReceiveVideoStreamStopped:) name:SDLVideoStreamDidStopNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_willPresentLockScreenViewController:) name:SDLLockScreenManagerWillPresentLockScreenViewController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_willDismissLockScreenViewController:) name:SDLLockScreenManagerWillDismissLockScreenViewController object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didPresentLockScreenViewController:) name:SDLLockScreenManagerDidPresentLockScreenViewController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didDismissLockScreenViewController:) name:SDLLockScreenManagerDidDismissLockScreenViewController object:nil];

    return self;
}

- (void)syncFrame {
    if (!self.streamManager.isVideoConnected || self.streamManager.isVideoStreamingPaused) {
        return;
    }

    if (self.isLockScreenPresenting || self.isLockScreenDismissing) {
        SDLLogD(@"Paused CarWindow, lock screen moving");
        return;
    }

    const CGRect bounds = self.streamManager.videoScaleManager.appViewportFrame;
    if (bounds.size.width < 1) {
        SDLLogD(@"CarWindow: Invalid viewport frame");
        return;
    }

    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 1.0f);
    switch (self.renderingType) {
        case SDLCarWindowRenderingTypeLayer: {
            [self.rootViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        } break;
        case SDLCarWindowRenderingTypeViewAfterScreenUpdates: {
            [self.rootViewController.view drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
        } break;
        case SDLCarWindowRenderingTypeViewBeforeScreenUpdates: {
            [self.rootViewController.view drawViewHierarchyInRect:bounds afterScreenUpdates:NO];
        } break;
    }

    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGImageRef imageRef = screenshot.CGImage;
    CVPixelBufferRef pixelBuffer = [self.class sdl_createPixelBufferForImageRef:imageRef usingPool:self.streamManager.pixelBufferPool];
    if (pixelBuffer != nil) {
        BOOL success = [self.streamManager sendVideoData:pixelBuffer];
        if (!success) {
            SDLLogE(@"Video frame will not be sent because the video frame encoding failed");
            return;
        }
        CVPixelBufferRelease(pixelBuffer);
    } else {
        SDLLogE(@"Video frame will not be sent because the pixelBuffer is nil");
    }
}

- (void)updateVideoStreamingCapability:(SDLVideoStreamingCapability *)videoStreamingCapability {
    [self sdl_applyDisplayDimensionsToRootViewController:self.rootViewController];
}

#pragma mark - SDLNavigationLockScreenManager Notifications
- (void)sdl_willPresentLockScreenViewController:(NSNotification *)notification {
    self.lockScreenPresenting = YES;
}

- (void)sdl_didPresentLockScreenViewController:(NSNotification *)notification {
    self.lockScreenPresenting = NO;
}

- (void)sdl_willDismissLockScreenViewController:(NSNotification *)notification {
    self.lockScreenBeingDismissed = YES;
}

- (void)sdl_didDismissLockScreenViewController:(NSNotification *)notification {
    self.lockScreenBeingDismissed = NO;
}

#pragma mark - SDLNavigationLifecycleManager Notifications
- (void)sdl_didReceiveVideoStreamStarted:(NSNotification *)notification {
    self.videoStreamStarted = true;

    SDLLogD(@"Video stream started");

    dispatch_async(dispatch_get_main_queue(), ^{
        [self sdl_applyDisplayDimensionsToRootViewController:self.rootViewController];
    });
}

- (void)sdl_didReceiveVideoStreamStopped:(NSNotification *)notification {
    self.videoStreamStarted = false;

    dispatch_async(dispatch_get_main_queue(), ^{
        // And also reset the streamingViewController's frame, because we are about to show it.
        self.rootViewController.view.frame = [UIScreen mainScreen].bounds;
        SDLLogD(@"Video stream ended, setting view controller frame back: %@", NSStringFromCGRect(self.rootViewController.view.frame));
    });
}

#pragma mark - Custom Accessors
- (void)setRootViewController:(nullable UIViewController *)rootViewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (rootViewController == nil || !self.isVideoStreamStarted) {
            self->_rootViewController = rootViewController;
            return;
        }

        if (!self.allowMultipleOrientations
            && !(rootViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskPortrait ||
                 rootViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscapeLeft ||
                 rootViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscapeRight)) {
                @throw [NSException sdl_carWindowOrientationException];
            }

        [self sdl_applyDisplayDimensionsToRootViewController:rootViewController];
        self->_rootViewController = rootViewController;
    });
}

#pragma mark - Private Helpers

+ (nullable CVPixelBufferRef)sdl_createPixelBufferForImageRef:(CGImageRef)imageRef usingPool:(CVPixelBufferPoolRef)pool {
    size_t imageWidth = CGImageGetWidth(imageRef);
    size_t imageHeight = CGImageGetHeight(imageRef);

    CVPixelBufferRef pixelBuffer;
    CVReturn result = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pool, &pixelBuffer);
    if (result != kCVReturnSuccess) {
        return nil;
    }

    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void *data = CVPixelBufferGetBaseAddress(pixelBuffer);
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data, imageWidth, imageHeight, 8, CVPixelBufferGetBytesPerRow(pixelBuffer), rgbColorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), imageRef);
    CGColorSpaceRelease(rgbColorSpace);

    CGContextRelease(context);

    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

    return pixelBuffer;
}
/**
 Sets the rootViewController's frame to the display's viewport dimensions.

 @param rootViewController The view controller to resize
 */
- (void)sdl_applyDisplayDimensionsToRootViewController:(UIViewController *)rootViewController {
    const CGSize displaySize = self.streamManager.videoScaleManager.displayViewportResolution;
    if (displaySize.width < 1) {
        // The dimensions of the display screen is unknown because the connected head unit did not provide a screen resolution in the `RegisterAppInterfaceResponse` or in the video start service ACK.
        SDLLogW(@"The display screen dimensions are unknown. The CarWindow will not resize.");
        return;
    }

    const CGRect appFrame = self.streamManager.videoScaleManager.appViewportFrame;
    rootViewController.view.frame = appFrame;
    rootViewController.view.bounds = appFrame;

    SDLLogD(@"Setting CarWindow frame to: %@ (display size: %@)", NSStringFromCGSize(appFrame.size), NSStringFromCGSize(displaySize));
}

@end

NS_ASSUME_NONNULL_END
