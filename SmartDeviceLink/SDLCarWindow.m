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
#import "SDLNavigationLockScreenManager.h"
#import "SDLNotificationConstants.h"
#import "SDLStreamingMediaManager.h"
#import "SDLStreamingMediaConfiguration.h"
#import "SDLStreamingMediaManagerConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLCarWindow ()

@property (strong, nonatomic, nullable) CADisplayLink *displayLink;
@property (strong, nonatomic, nullable) NSString *previousMd5Hash;
@property (assign, nonatomic) CFTimeInterval lastMd5HashTimestamp;
@property (assign, nonatomic) NSUInteger sameFrameCounter;
@property (assign, nonatomic) NSUInteger targetFramerate;

@property (weak, nonatomic, nullable) SDLStreamingMediaManager *streamManager;
@property (strong, nonatomic) SDLNavigationLockScreenManager *lockScreenManager;

@property (assign, nonatomic, getter=isLockScreenMoving) BOOL lockScreenMoving;

@end

@implementation SDLCarWindow

- (instancetype)initWithStreamManager:(SDLStreamingMediaManager *)streamManager framesPerSecond:(NSUInteger)framesPerSecond {
    self = [super init];
    if (!self) { return nil; }

    _streamManager = streamManager;
    _targetFramerate = framesPerSecond;
    _lockScreenManager = [[SDLNavigationLockScreenManager alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_transportDidDisconnect:) name:SDLTransportDidDisconnect object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didReceiveVideoStreamStarted:) name:SDLVideoStreamDidStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didReceiveVideoStreamStopped:) name:SDLVideoStreamDidStopNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenMoving:) name:SDLLockScreenManagerWillPresentLockScreenViewController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenMoving:) name:SDLLockScreenManagerWillDismissLockScreenViewController object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenStoppedMoving:) name:SDLLockScreenManagerDidPresentLockScreenViewController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenStoppedMoving:) name:SDLLockScreenManagerDidDismissLockScreenViewController object:nil];

    return self;
}

- (void)sdl_transportDidDisconnect:(NSNotification *)notification {
    // Dismiss the lockscreen.
    [self.lockScreenManager dismiss];
}

- (void)sdl_sendFrame:(CADisplayLink *)displayLink {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.streamManager.isVideoConnected || self.streamManager.isVideoStreamingPaused) {
            return;
        }
        
        if (self.sameFrameCounter == 30 && ((displayLink.timestamp - self.lastMd5HashTimestamp) <= 0.1)) {
            return;
        }

        if (self.isLockScreenMoving) {
            return;
        }
        
        self.lastMd5HashTimestamp = displayLink.timestamp;
        SDLLogD(@"Send Carwindow frame");
        
        CGRect bounds = self.rootViewController.view.bounds;
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 1.0f);
        [self.rootViewController.view drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
        UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGImageRef imageRef = screenshot.CGImage;
        
        // We use MD5 Hashes to determine if we are sending the same frame over and over. If so, we will only send 30.
        NSString *currentMd5Hash = [self.class sdl_md5HashForImageRef:imageRef];
        if ([currentMd5Hash isEqualToString:self.previousMd5Hash]) {
            if (self.sameFrameCounter == 30) {
                return;
            }
            self.sameFrameCounter++;
        } else {
            self.sameFrameCounter = 0;
        }

        self.previousMd5Hash = currentMd5Hash;

        CVPixelBufferRef pixelBuffer = [self.class sdl_pixelBufferForImageRef:imageRef usingPool:self.streamManager.pixelBufferPool];
        [self.streamManager sendVideoData:pixelBuffer];
        CVPixelBufferRelease(pixelBuffer);
    });
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
        
        // And reset the frame counter (incase we are coming from a disconnect).
        self.sameFrameCounter = 0;
        
        // And start up the displayLink
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(sdl_sendFrame:)];
        if (SDL_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10")) {
            self.displayLink.preferredFramesPerSecond = self.targetFramerate;
        } else {
            self.displayLink.frameInterval = 60/self.targetFramerate;
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
        SDLLogW(@"Setting the view back: %@", NSStringFromCGRect(self.rootViewController.view.frame));
        // If the stream stops, we pause and invalidate the displayLink (do we really need to do this? can we just pause it).
        self.displayLink.paused = YES;
        [self.displayLink invalidate];
    });
}

#pragma mark - Private Helpers
+ (CVPixelBufferRef)sdl_pixelBufferForImageRef:(CGImageRef)imageRef usingPool:(CVPixelBufferPoolRef)pool {
    CGFloat imageWidth = CGImageGetWidth(imageRef);
    CGFloat imageHeight = CGImageGetHeight(imageRef);

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

+ (NSString *)sdl_md5HashForImageRef:(CGImageRef)imageRef {
    CFMutableDataRef imageData = CFDataCreateMutable(NULL, 0);
    CGImageDestinationRef destination = CGImageDestinationCreateWithData(imageData, kUTTypePNG, 1, NULL);
    CGImageDestinationAddImage(destination, imageRef, nil);
    if (!CGImageDestinationFinalize(destination)) {
        return nil;
    }

    CFRelease(destination);

    NSData *data = (__bridge NSData *)imageData;

    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (unsigned int)data.length, result);

    CFRelease(imageData);

    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }

    return [ret copy];
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
    CGContextRelease(context);

    return image;
}

+ (UIFont*)sdl_fontFittingSize:(CGSize)size forText:(NSString*)text {
    CGFloat fontSize = 100;
    while (fontSize > 0.0) {
        CGSize size = [text boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize]}
                                         context:nil].size;

        if (size.height <= size.height) break;

        fontSize -= 10.0;
    }

    return [UIFont boldSystemFontOfSize:fontSize];
}

@end

NS_ASSUME_NONNULL_END
