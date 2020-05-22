//
//  VideoTestViewController.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Leonid Lokhmatov on 5/19/20.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import "VideoTestViewController.h"
#import "SDLStreamingMediaManagerConstants.h"

@interface VideoTestViewController ()
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
@end


@implementation VideoTestViewController
{
    CGRect _viewportFrame;
}
@dynamic viewportFrame;

+ (VideoTestViewController*)createViewController {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"VideoWindow" bundle:nil];
    VideoTestViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"idVideoWindow"];
    [vc subscribeForNotifications];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.animeColorViews = @[self.subview1, self.subview2, self.subview3, self.subview4];
    self.animeIndex = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startAnime];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self stopAnime];
}

- (void)startAnime {
    [self animateView:self.subview1];
    [self animateView:self.subview2];
    [self animateView:self.subview3];
    [self animateView:self.subview4];
    [self.spinner startAnimating];

    // note: CA animation does not work offscreen that is why the timer
    [self.animeTimer invalidate];
    self.animeTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(animeTickTimer:) userInfo:nil repeats:YES];
}

- (void)stopAnime {
    [self stopAnimateView:self.subview1];
    [self stopAnimateView:self.subview2];
    [self stopAnimateView:self.subview3];
    [self stopAnimateView:self.subview4];
    [self.spinner stopAnimating];

    [self.animeTimer invalidate];
    self.animeTimer = nil;
}

- (void)animateView:(UIView*)view {
    CATransform3D myRotationTransform = CATransform3DMakeRotation(M_PI * 2.0, 0, 0, 1);
    view.layer.transform = myRotationTransform;
    CABasicAnimation *myAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    myAnimation.duration = 1.0;
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

- (void)subscribeForNotifications {
    if (!self.subscribedForVideoNotifications) {
        self.subscribedForVideoNotifications = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_videoStreamDidStartNotification:) name:SDLVideoStreamDidStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_videoStreamDidStopNotification:) name:SDLVideoStreamDidStopNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_videoStreamSuspendedNotification:) name:SDLVideoStreamSuspendedNotification object:nil];
    }
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

- (void)setViewportFrame:(CGRect)frame {
    NSLog(@"setViewportFrame: %@", NSStringFromCGSize(frame.size));
    _viewportFrame = frame;
    frame.origin = CGPointZero; // just in case

    self.displayConstraintX.constant = frame.origin.x;
    self.displayConstraintY.constant = frame.origin.y;
    self.displayConstraintW.constant = frame.size.width;
    self.displayConstraintH.constant = frame.size.height;
    // note: constraints do not work offscreen
    [self.view layoutSubviews];
//    self.displayView.frame = frame;
}

- (CGRect)viewportFrame {
    // note: one can inherit it from constraints, no need to duplicate
    return _viewportFrame;
}

- (void)resetViewportFrame {
    [self setViewportFrame:self.view.bounds];
}

@end
