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
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.lockWindow.isKeyWindow) {
            SDLLogW(@"Attempted to present lock window when it is already presented");
            return;
        }

        NSArray* windows = [[UIApplication sharedApplication] windows];
        UIWindow *appWindow = nil;
        for (UIWindow *window in windows) {
            if (window != self.lockWindow) {
                appWindow = window;
                break;
            }
        }

        if (appWindow == nil) {
            SDLLogE(@"Unable to find the app's window");
            return;
        }

        // We let ourselves know that the lockscreen will present, because we have to pause streaming video for that 0.3 seconds or else it will be very janky.
        [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerWillPresentLockScreenViewController object:nil];

        CGRect firstFrame = appWindow.frame;
        firstFrame.origin.x = CGRectGetWidth(firstFrame);
        appWindow.frame = firstFrame;

        // We then move the lockWindow to the original appWindow location.
        self.lockWindow.frame = appWindow.bounds;
        [self.screenshotViewController loadScreenshotOfWindow:appWindow];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray* windows = [[UIApplication sharedApplication] windows];
        UIWindow *appWindow = nil;
        for (UIWindow *window in windows) {
            if (window != self.lockWindow) {
                appWindow = window;
                break;
            }
        }

        if (appWindow == nil) {
            SDLLogE(@"Unable to find the app's window");
            return;
        } else if (appWindow.isKeyWindow) {
            SDLLogW(@"Attempted to dismiss lock screen, but it is already dismissed");
            return;
        }

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
    __block BOOL isPresented = NO;
    if ([NSThread isMainThread]) {
        isPresented = [self sdl_presented];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            isPresented = [self sdl_presented];
        });
    }

    return isPresented;
}

- (BOOL)sdl_presented {
    return (self.lockViewController.isViewLoaded && (self.lockViewController.view.window || self.lockViewController.isBeingPresented) && self.lockWindow.isKeyWindow);
}

@end

NS_ASSUME_NONNULL_END

