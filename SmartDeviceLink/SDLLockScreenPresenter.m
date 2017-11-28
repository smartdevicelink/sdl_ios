//
//  SDLLockScreenPresenter.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/15/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLLockScreenPresenter.h"

#import "SDLScreenshotViewController.h"
#import "SDLStreamingMediaManagerConstants.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenPresenter ()

@property (strong, nonatomic) SDLScreenshotViewController *screenshotViewController;
@property (strong, nonatomic) UIWindow *lockWindow;

@end


@implementation SDLLockScreenPresenter

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    _lockWindow = [[UIWindow alloc] initWithFrame:screenFrame];
    _screenshotViewController = [[SDLScreenshotViewController alloc] init];
    _lockWindow.rootViewController = _screenshotViewController;

    return self;
}

- (void)present {
    NSArray* windows = [[UIApplication sharedApplication] windows];
    UIWindow* mapWindow = windows.firstObject;

    if (self.lockWindow.isKeyWindow || mapWindow == self.lockWindow) {
        return;
    }

    // We let ourselves know that the lockscreen will present, because we have to pause streaming video for that 0.3 seconds or else it will be very janky.
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerWillPresentLockScreenViewController object:nil];

    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect firstFrame = mapWindow.frame;
        firstFrame.origin.x = CGRectGetWidth(firstFrame);
        mapWindow.frame = firstFrame;

        // Take a screenshot of the mapWindow.
        [(SDLScreenshotViewController*)self.lockWindow.rootViewController loadScreenshotOfWindow:mapWindow];

        // We then move the lockWindow to the original mapWindow location.
        self.lockWindow.frame = mapWindow.bounds;
        [self.lockWindow makeKeyAndVisible];

        // And present the lock screen.
        [self.lockWindow.rootViewController presentViewController:self.lockViewController animated:YES completion:^{
            // Tell ourselves we are done.
            [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerDidPresentLockScreenViewController object:nil];
        }];
    });
}

- (void)dismiss {
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *appWindow = windows.firstObject;

    if (appWindow.isKeyWindow || appWindow == self.lockWindow) {
        return;
    }

    // Let us know we are about to dismiss.
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerWillDismissLockScreenViewController object:nil];

    dispatch_async(dispatch_get_main_queue(), ^{
        // Take a screenshot of the mapWindow.
        [(SDLScreenshotViewController*)self.lockWindow.rootViewController loadScreenshotOfWindow:appWindow];

        // Dismiss the lockscreen, showing the screenshot.
        [self.lockViewController dismissViewControllerAnimated:YES completion:^{
            CGRect lockFrame = self.lockWindow.frame;
            lockFrame.origin.x = CGRectGetWidth(lockFrame);
            self.lockWindow.frame = lockFrame;

            // Quickly move the map back, and make it the key window.
            appWindow.frame = self.lockWindow.bounds;
            [appWindow makeKeyAndVisible];

            // Tell ourselves we are done.
            [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerDidDismissLockScreenViewController object:nil];
        }];
    });
}

- (BOOL)presented {
    return (self.lockViewController.isViewLoaded && (self.lockViewController.view.window || self.lockViewController.isBeingPresented) && self.lockWindow.isKeyWindow);
}

+ (UIViewController *)sdl_getCurrentViewController {
    // http://stackoverflow.com/questions/6131205/iphone-how-to-find-topmost-view-controller
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController != nil) {
        topController = topController.presentedViewController;
    }

    return topController;
}

@end

NS_ASSUME_NONNULL_END
