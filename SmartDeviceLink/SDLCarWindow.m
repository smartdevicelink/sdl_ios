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
#import "SDLCarWindowViewControllerProtocol.h"
#import "SDLVideoStreamingCapability.h"
#import "SDLDisplaySizeParams.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLCarWindow ()

@property (weak, nonatomic, nullable) SDLStreamingVideoLifecycleManager *streamManager;

@property (assign, nonatomic) SDLCarWindowRenderingType renderingType;
@property (assign, nonatomic) BOOL allowMultipleOrientations;

@property (assign, nonatomic, getter=isLockScreenPresenting) BOOL lockScreenPresenting;
@property (assign, nonatomic, getter=isLockScreenDismissing) BOOL lockScreenBeingDismissed;

@property (assign, nonatomic, getter=isVideoStreamStarted) BOOL videoStreamStarted;

@property (strong, nonatomic, nullable) SDLDisplaySizeParams *displaySizeParams;

@end

@implementation SDLCarWindow

- (instancetype)initWithStreamManager:(SDLStreamingVideoLifecycleManager *)streamManager configuration:(SDLStreamingMediaConfiguration *)configuration {
    self = [super init];
    if (!self) { return nil; }

    _streamManager = streamManager;
    _renderingType = configuration.carWindowRenderingType;
    _allowMultipleOrientations = configuration.allowMultipleViewControllerOrientations;

    //Note: the notification center can or should be local, not default
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(sdl_didReceiveVideoStreamStarted:) name:SDLVideoStreamDidStartNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(sdl_didReceiveVideoStreamStopped:) name:SDLVideoStreamDidStopNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(sdl_didReceiveVideoStreamSuspended:) name:SDLVideoStreamSuspendedNotification object:nil];


    [notificationCenter addObserver:self selector:@selector(sdl_willPresentLockScreenViewController:) name:SDLLockScreenManagerWillPresentLockScreenViewController object:nil];
    [notificationCenter addObserver:self selector:@selector(sdl_willDismissLockScreenViewController:) name:SDLLockScreenManagerWillDismissLockScreenViewController object:nil];
    [notificationCenter addObserver:self selector:@selector(sdl_didPresentLockScreenViewController:) name:SDLLockScreenManagerDidPresentLockScreenViewController object:nil];
    [notificationCenter addObserver:self selector:@selector(sdl_didDismissLockScreenViewController:) name:SDLLockScreenManagerDidDismissLockScreenViewController object:nil];

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

    if (!self.displaySizeParams) {
        NSLog(@"CarWindow: Invalid display params");
        return;
    }

    UIImage *screenshot = nil;
    if ([self.rootViewController conformsToProtocol:@protocol(SDLCarWindowViewControllerProtocol)]) {
        id<SDLCarWindowViewControllerProtocol> sdlViewController = (id<SDLCarWindowViewControllerProtocol>)self.rootViewController;
        screenshot = sdlViewController.snapshot;
    } else {
        const CGRect bounds = [self.displaySizeParams makeDisplayRect];
        UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 1);
        CGContextRef context = UIGraphicsGetCurrentContext();
        const CGFloat scale = self.displaySizeParams.scale;
        CGContextScaleCTM(context, scale, scale);
        switch (self.renderingType) {
            case SDLCarWindowRenderingTypeLayer: {
                [self.rootViewController.view.layer renderInContext:context];
            } break;
            case SDLCarWindowRenderingTypeViewAfterScreenUpdates: {
                [self.rootViewController.view drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
            } break;
            case SDLCarWindowRenderingTypeViewBeforeScreenUpdates: {
                [self.rootViewController.view drawViewHierarchyInRect:bounds afterScreenUpdates:NO];
            } break;
        }

        screenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    CGImageRef imageRef = screenshot.CGImage;
    CVPixelBufferRef pixelBuffer = imageRef ? [self.class sdl_createPixelBufferForImageRef:imageRef usingPool:self.streamManager.pixelBufferPool] : nil;
    if (pixelBuffer != nil) {
        const BOOL success = [self.streamManager sendVideoData:pixelBuffer];
        if (!success) {
            SDLLogE(@"Video frame will not be sent because the video frame encoding failed");
        }
        CVPixelBufferRelease(pixelBuffer);
    } else {
        SDLLogE(@"Video frame will not be sent because the pixelBuffer is nil");
    }
}

- (void)updateVdeoStreamingCapability:(SDLVideoStreamingCapability *)videoStreamingCapability {
    [self sdl_applyDisplayDimensionsToViewController:self.rootViewController];
}

- (void)dealloc {
    [self unsubscribeFromNotifications];
}

#pragma mark - Notifications

- (void)unsubscribeFromNotifications {
    //Note: use a proper center
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        [self sdl_applyDisplayDimensionsToViewController:self.rootViewController];
    });
}

- (void)sdl_didReceiveVideoStreamStopped:(NSNotification *)notification {
    self.videoStreamStarted = false;

    dispatch_async(dispatch_get_main_queue(), ^{
        // And also reset the streamingViewController's frame, because we are about to show it.
        self.displaySizeParams = [SDLDisplaySizeParams displaySizeParamsWithSize:[UIScreen mainScreen].bounds.size scale:1];

        UIViewController *viewController = self.rootViewController;
        if ([viewController conformsToProtocol:@protocol(SDLCarWindowViewControllerProtocol)]) {
            id<SDLCarWindowViewControllerProtocol> sdlViewController = (id<SDLCarWindowViewControllerProtocol>) viewController;
            sdlViewController.displaySizeParams = nil;
        } else {
            const CGRect frame = [self.displaySizeParams makeDisplayRect];
            viewController.view.frame = frame;
            viewController.view.bounds = frame;
        }

        SDLLogD(@"Video stream ended, setting view controller frame back: %@", NSStringFromCGRect(self.rootViewController.view.frame));
    });
}

- (void)sdl_didReceiveVideoStreamSuspended:(NSNotification *)notification {
    NSLog(@"#VIDEO: suspended");
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

        [self sdl_applyDisplayDimensionsToViewController:rootViewController];
        self->_rootViewController = rootViewController;
    });
}

#pragma mark - Private Helpers
// memory management 'create': release the result object when done
+ (nullable CVPixelBufferRef)sdl_createPixelBufferForImageRef:(CGImageRef)imageRef usingPool:(CVPixelBufferPoolRef)pool {
    size_t imageWidth = CGImageGetWidth(imageRef);
    size_t imageHeight = CGImageGetHeight(imageRef);
//    NSLog(@"RENDER:[%dx%d]", (int)imageWidth, (int)imageHeight);

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
 Sets the viewController frame to the display viewport dimensions.

 @param viewController (aka rootViewController) The view controller to resize
 */
- (void)sdl_applyDisplayDimensionsToViewController:(UIViewController *)viewController {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    const CGSize displSize = self.streamManager.videoScaleManager.displayViewportResolution;
    const CGRect appFrame = self.streamManager.videoScaleManager.appViewportFrame;
    if (1 > CGRectGetWidth(appFrame)) {
        // The dimensions of the display screen is unknown because the connected head unit did not provide a screen resolution in the `RegisterAppInterfaceResponse` or in the video start service ACK.
        SDLLogW(@"The the display screen dimensions are unknown. The CarWindow will not resize.");
        self.displaySizeParams = nil;
        return;
    }

    self.displaySizeParams = [SDLDisplaySizeParams displaySizeParamsWithSize:displSize scale:self.streamManager.videoScaleManager.scale];
    if ([viewController conformsToProtocol:@protocol(SDLCarWindowViewControllerProtocol)]) {
        UIViewController<SDLCarWindowViewControllerProtocol>* sdlViewController = (UIViewController<SDLCarWindowViewControllerProtocol>*)viewController;
        sdlViewController.displaySizeParams = self.displaySizeParams;
    } else {
        viewController.view.frame = appFrame;
        viewController.view.bounds = appFrame;
    }

    SDLLogD(@"Setting CarWindow frame to: %@ (display size: %@)", NSStringFromCGSize(appFrame.size), NSStringFromCGSize(displSize));
}

@end

NS_ASSUME_NONNULL_END
