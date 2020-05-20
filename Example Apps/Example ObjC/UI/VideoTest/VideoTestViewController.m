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
@property (strong, nonatomic) IBOutlet UIView *subview1;
@property (strong, nonatomic) IBOutlet UIView *subview2;
@property (strong, nonatomic) IBOutlet UIView *subview3;
@property (strong, nonatomic) IBOutlet UIView *subview4;
@property (assign, nonatomic) BOOL subscribedForVideoNotifications;
@end


@implementation VideoTestViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startAnime];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopAnime];
}

- (void)startAnime {
    [self animateView:self.subview1];
    [self animateView:self.subview2];
    [self animateView:self.subview3];
    [self animateView:self.subview4];
}

- (void)stopAnime {
    [self stopAnimateView:self.subview1];
    [self stopAnimateView:self.subview2];
    [self stopAnimateView:self.subview3];
    [self stopAnimateView:self.subview4];
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


@end
