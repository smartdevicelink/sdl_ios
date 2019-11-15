//
//  SDLScreenShotViewController.m
//  ios
//
//  Created by Muller, Alexander (A.) on 2/6/17.
//  Copyright © 2017 Ford Motor Company. All rights reserved.
//

#import "SDLScreenshotViewController.h"

#import "SDLError.h"

@interface SDLScreenshotViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong, nullable) UIWindow *currentAppWindow;

@end

@implementation SDLScreenshotViewController

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    self.view.backgroundColor = [UIColor clearColor];

    self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.imageView];

    return self;
}

// HAX: https://github.com/smartdevicelink/sdl_ios/issues/1250
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.currentAppWindow == nil) { return UIInterfaceOrientationMaskAll; }

    UIViewController *viewController = [self sdl_topMostControllerForWindow:self.currentAppWindow];

    if (viewController == self) {
        return UIInterfaceOrientationMaskAll;
    } else if (viewController != nil) {
        return viewController.supportedInterfaceOrientations;
    }

    return UIInterfaceOrientationMaskAll;
}

// HAX: https://github.com/smartdevicelink/sdl_ios/issues/1250
- (BOOL)shouldAutorotate {
    if (self.currentAppWindow == nil) { return YES; }

    UIViewController *viewController = [self sdl_topMostControllerForWindow:self.currentAppWindow];

    if (viewController == self) {
        return YES;
    } else if (viewController != nil) {
        return viewController.shouldAutorotate;
    }

    return YES;
}

- (UIViewController *)sdl_topMostControllerForWindow:(UIWindow *)window {
    UIViewController *topController = window.rootViewController;

    while (topController.presentedViewController != nil) {
        topController = topController.presentedViewController;
    }

    return topController;
}

- (void)layoutSubviews {
    self.imageView.frame = self.view.bounds;
}

- (void)loadScreenshotOfWindow:(UIWindow *)window {
    self.currentAppWindow = window;
    if (self.currentAppWindow == nil) { return; }

    UIGraphicsBeginImageContextWithOptions(window.bounds.size, YES, 0.0f);
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];

    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.imageView.image = image;
}

@end
