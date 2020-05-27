//
//  TestUIAppViewController.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Leonid Lokhmatov on 5/25/20.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import "TestUIAppViewController.h"
#import "SDLStreamingMediaManagerConstants.h"
#import "SDLDisplaySizeParams.h"

@interface TestUIAppViewController ()
@property (strong, nonatomic) IBOutlet UIView *displayView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *displayConstraintX;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *displayConstraintY;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *displayConstraintW;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *displayConstraintH;

@property (strong, nonatomic) IBOutlet UIView *subview1;
@property (strong, nonatomic) IBOutlet UIView *subview2;
@property (strong, nonatomic) IBOutlet UIView *subview3;
@property (strong, nonatomic) IBOutlet UIView *subview4;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (assign, nonatomic) BOOL subscribedForVideoNotifications;
@property (strong, nonatomic) NSTimer * animeTimer;
@property (strong, nonatomic) NSArray * animeColorViews;
@property (assign, nonatomic) int animeIndex;
@property (assign, nonatomic) BOOL enableDebugFrame;
@end

@implementation TestUIAppViewController {
    SDLDisplaySizeParams *_displaySizeParams;
}

+ (TestUIAppViewController*)createViewController {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"ExampleApps" bundle:nil];
    TestUIAppViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"idTestUIAppViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.animeColorViews = @[self.subview1, self.subview2, self.subview3, self.subview4];
    self.animeIndex = 0;
    [self subscribeForNotifications];
    self.enableDebugFrame = YES;
}

#pragma mark - Notifications

- (void)subscribeForNotifications {
    if (!self.subscribedForVideoNotifications) {
        self.subscribedForVideoNotifications = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_videoStreamDidStartNotification:) name:SDLVideoStreamDidStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_videoStreamDidStopNotification:) name:SDLVideoStreamDidStopNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_videoStreamSuspendedNotification:) name:SDLVideoStreamSuspendedNotification object:nil];
    }
}

- (void)unsubscribeFromNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.subscribedForVideoNotifications = NO;
}

- (void)_videoStreamDidStartNotification:(NSNotification*)notification {
    NSLog(@"**V-START");
    dispatch_async(dispatch_get_main_queue(), ^{
            [self startAnime];
    });
}

- (void)_videoStreamDidStopNotification:(NSNotification*)notification {
    NSLog(@"**V-STOP");
    dispatch_async(dispatch_get_main_queue(), ^{
            [self stopAnime];
    });
}

- (void)_videoStreamSuspendedNotification:(NSNotification*)notification {
    NSLog(@"**V-SUSPEND");
    dispatch_async(dispatch_get_main_queue(), ^{
            [self stopAnime];
    });
}

#pragma mark - Animationd

- (void)startAnime {
    NSLog(@"%s: thread: %@", __PRETTY_FUNCTION__, [NSThread isMainThread]?@"main":@"bg thread");
    [self animateView:self.subview1 duration:1];
    [self animateView:self.subview2 duration:1.5];
    [self animateView:self.subview3 duration:2];
    [self animateView:self.subview4 duration:2.5];
    [self.spinner startAnimating];

    // note: CA animation does not work offscreen that is why the timer
    [self.animeTimer invalidate];
    self.animeTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(animeTickTimer:) userInfo:nil repeats:YES];
}

- (void)stopAnime {
    NSLog(@"%s: thread: %@", __PRETTY_FUNCTION__, [NSThread isMainThread]?@"main":@"bg thread");
    [self stopAnimateView:self.subview1];
    [self stopAnimateView:self.subview2];
    [self stopAnimateView:self.subview3];
    [self stopAnimateView:self.subview4];
    [self.spinner stopAnimating];

    [self.animeTimer invalidate];
    self.animeTimer = nil;
}

- (void)animateView:(UIView*)view duration:(float)duration {
    CATransform3D myRotationTransform = CATransform3DMakeRotation(M_PI * 2.0, 0, 0, 1);
    view.layer.transform = myRotationTransform;
    CABasicAnimation *myAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    myAnimation.duration = duration;
    myAnimation.fromValue = @0.0;
    myAnimation.toValue = @(M_PI * 2.0);
    myAnimation.repeatCount = 999;
    [view.layer addAnimation:myAnimation forKey:@"transform.rotation"];
}

- (void)stopAnimateView:(UIView*)view {
    [view.layer removeAllAnimations];
}

- (void)animeTickTimer:(NSTimer*)timer {
    const NSUInteger viewCount = self.animeColorViews.count;
    if (1 < viewCount) {
        UIView *view0 = self.animeColorViews[0];
        UIView *prevView = view0;
        UIColor * color0 = prevView.backgroundColor;
        for (int i=1; i < viewCount; ++i) {
            UIView * nextView = self.animeColorViews[i];
            prevView.backgroundColor = nextView.backgroundColor;
            prevView = nextView;
        }
        prevView.backgroundColor = color0;
    }
}

- (SDLDisplaySizeParams*)displaySizeParams {
    return _displaySizeParams;
}

- (void)setDisplaySizeParams:(SDLDisplaySizeParams*)params {
    NSLog(@"setDisplaySizeParams: %@", params);
    _displaySizeParams = params;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self applyDisplaySizeParams];
    });
}

- (UIImage *)snapshot {
    if (![NSThread isMainThread]) {
        NSLog(@"%s: must be called on the main thread", __PRETTY_FUNCTION__);
        return nil;
    }
    return self.displaySizeParams ? [self generateImageWithSize:self.displaySizeParams] : nil;
}

#pragma mark - helper functions

- (void)applyDisplaySizeParams {
        const CGRect frame = _displaySizeParams.appViewportFrame;
        self.displayConstraintX.constant = frame.origin.x;
        self.displayConstraintY.constant = frame.origin.y;
        self.displayConstraintW.constant = frame.size.width;
        self.displayConstraintH.constant = frame.size.height;
        // note: constraints do not work offscreen
        [self.view layoutSubviews];
    //    self.displayView.frame = frame;
}

- (UIImage *)generateImageWithSize:(SDLDisplaySizeParams*)sizeModel {
    const CGRect canvasRect = [sizeModel makeDisplayRect];
    UIView *targetView = self.displayView;

    UIGraphicsBeginImageContextWithOptions(canvasRect.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationDefault);
    [targetView drawViewHierarchyInRect:canvasRect afterScreenUpdates:YES];
    if (self.enableDebugFrame) {
        CGRect frect = CGRectZero;
        frect.size = canvasRect.size;
        frect = CGRectInset(frect, 2, 2);
        UIBezierPath *bezierFrame = [UIBezierPath bezierPathWithRect:frect];
        CGFloat dash[] = {2.0, 5.0};
        CGContextSetLineDash(context, 0, dash, 2);
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, UIColor.redColor.CGColor);
        CGContextAddPath(context, bezierFrame.CGPath);
        CGContextDrawPath(context, kCGPathStroke);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
