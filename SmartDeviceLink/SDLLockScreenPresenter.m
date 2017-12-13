//
//  SDLLockScreenPresenter.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/15/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLLockScreenPresenter.h"

#import "SDLLogMacros.h"
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
    UIWindow* appWindow = windows.firstObject;

    if (self.lockWindow.isKeyWindow || appWindow == self.lockWindow) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        // We let ourselves know that the lockscreen will present, because we have to pause streaming video for that 0.3 seconds or else it will be very janky.
        [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerWillPresentLockScreenViewController object:nil];

        CGRect firstFrame = appWindow.frame;
        firstFrame.origin.x = CGRectGetWidth(firstFrame);
        appWindow.frame = firstFrame;

        // We then move the lockWindow to the original appWindow location.
        self.lockWindow.frame = appWindow.bounds;
        [self.lockWindow makeKeyAndVisible];

        // And present the lock screen.
        SDLLogD(@"Present lock screen window");
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

    dispatch_async(dispatch_get_main_queue(), ^{
        // Let us know we are about to dismiss.
        [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerWillDismissLockScreenViewController object:nil];

        // Dismiss the lockscreen
        SDLLogD(@"Dismiss lock screen window");
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

@end

NS_ASSUME_NONNULL_END
