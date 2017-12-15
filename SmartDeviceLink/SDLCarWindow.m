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
#import "SDLStreamingMediaConfiguration.h"
#import "SDLStreamingMediaLifecycleManager.h"
#import "SDLStreamingMediaManagerConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLCarWindow ()

@property (strong, nonatomic, nullable) CADisplayLink *displayLink;
@property (assign, nonatomic) NSUInteger targetFramerate;

@property (weak, nonatomic, nullable) SDLStreamingMediaLifecycleManager *streamManager;

@property (assign, nonatomic, getter=isLockScreenMoving) BOOL lockScreenMoving;

@end

@implementation SDLCarWindow

- (instancetype)initWithStreamManager:(SDLStreamingMediaLifecycleManager *)streamManager targetFramerate:(NSUInteger)framesPerSecond {
    self = [super init];
    if (!self) { return nil; }

    SDLLogD(@"Initializing Car Window automatic streaming with framerate: %lu", (unsigned long)framesPerSecond);

    _streamManager = streamManager;
    _targetFramerate = framesPerSecond;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didReceiveVideoStreamStarted:) name:SDLVideoStreamDidStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didReceiveVideoStreamStopped:) name:SDLVideoStreamDidStopNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenMoving:) name:SDLLockScreenManagerWillPresentLockScreenViewController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenMoving:) name:SDLLockScreenManagerWillDismissLockScreenViewController object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenStoppedMoving:) name:SDLLockScreenManagerDidPresentLockScreenViewController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenStoppedMoving:) name:SDLLockScreenManagerDidDismissLockScreenViewController object:nil];

    return self;
}

- (void)sdl_sendFrame:(CADisplayLink *)displayLink {
    if (!self.streamManager.isVideoConnected || self.streamManager.isVideoStreamingPaused) {
        return;
    }

    if (self.isLockScreenMoving) {
        SDLLogD(@"Paused CarWindow, lock screen moving");
        return;
    }

    CGRect bounds = self.rootViewController.view.bounds;

    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 1.0f);
    [self.rootViewController.view drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGImageRef imageRef = screenshot.CGImage;
    CVPixelBufferRef pixelBuffer = [self.class sdl_pixelBufferForImageRef:imageRef usingPool:self.streamManager.pixelBufferPool];
    [self.streamManager sendVideoData:pixelBuffer];
    CVPixelBufferRelease(pixelBuffer);
}

#pragma mark - SDLNavigationLockScreenManager Notifications
- (void)sdl_lockScreenMoving:(NSNotification *)notification {
    self.lockScreenMoving = YES;
}

- (void)sdl_lockScreenStoppedMoving:(NSNotification *)notification {
    self.lockScreenMoving = NO;
}

#pragma mark - SDLNavigationLifecycleManager Notifications
- (void)sdl_didReceiveVideoStreamStarted:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        // If the video stream has started, we want to resize the streamingViewController to the size from the RegisterAppInterface
        self.rootViewController.view.frame = CGRectMake(0, 0, self.streamManager.screenSize.width, self.streamManager.screenSize.height);
        self.rootViewController.view.bounds = self.rootViewController.view.frame;

        SDLLogD(@"Video stream started, setting CarWindow frame to: %@", NSStringFromCGRect(self.rootViewController.view.bounds));
        
        // And start up the displayLink
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(sdl_sendFrame:)];
        if (SDL_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10")) {
            self.displayLink.preferredFramesPerSecond = (NSInteger)self.targetFramerate;
        } else {
            self.displayLink.frameInterval = (60 / self.targetFramerate);
        }
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    });
}

- (void)sdl_didReceiveVideoStreamStopped:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        // If the video stream has stopped, we want to resize the streamingViewController to the ordinary size
        self.displayLink.paused = YES;
        [self.displayLink invalidate];

        // And also reset the streamingViewController's frame, because we are about to show it.
        self.rootViewController.view.frame = [UIScreen mainScreen].bounds;
        SDLLogD(@"Video stream ended, setting view controller frame back: %@", NSStringFromCGRect(self.rootViewController.view.frame));
    });
}

#pragma mark - Custom Accessors
- (void)setRootViewController:(nullable UIViewController *)rootViewController {
    _rootViewController = rootViewController;

    if (rootViewController == nil) {
        return;
    }
    NSAssert((rootViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskPortrait ||
              rootViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscapeLeft ||
              rootViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscapeRight), @"SDLCarWindow rootViewController must support only a single interface orientation");
}

#pragma mark - Private Helpers
+ (CVPixelBufferRef)sdl_pixelBufferForImageRef:(CGImageRef)imageRef usingPool:(CVPixelBufferPoolRef)pool {
    size_t imageWidth = CGImageGetWidth(imageRef);
    size_t imageHeight = CGImageGetHeight(imageRef);

    CVPixelBufferRef pixelBuffer;
    CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pool,&pixelBuffer);

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

#pragma mark Backgrounded Screen / Text

+ (UIImage*)sdl_imageWithText:(NSString*)text size:(CGSize)size {
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, frame);
    CGContextSaveGState(context);

    NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentCenter;

    NSDictionary* textAttributes = @{
                                     NSFontAttributeName: [self sdl_fontFittingSize:frame.size forText:text],
                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                     NSParagraphStyleAttributeName: textStyle
                                     };
    CGRect textFrame = [text boundingRectWithSize:size
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:textAttributes
                                          context:nil];

    CGRect textInset = CGRectMake(0,
                                  (frame.size.height - CGRectGetHeight(textFrame)) / 2.0,
                                  frame.size.width,
                                  frame.size.height);

    [text drawInRect:textInset
      withAttributes:textAttributes];

    CGContextRestoreGState(context);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();

    return image;
}

+ (UIFont*)sdl_fontFittingSize:(CGSize)size forText:(NSString*)text {
    CGFloat fontSize = 100;
    while (fontSize > 0.0) {
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize]}
                                             context:nil].size;

        if (textSize.height <= size.height) { break; }

        fontSize -= 10.0;
    }

    return [UIFont boldSystemFontOfSize:fontSize];
}

@end

NS_ASSUME_NONNULL_END
