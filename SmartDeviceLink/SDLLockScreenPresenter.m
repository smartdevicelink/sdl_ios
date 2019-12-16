//
//  SDLLockScreenPresenter.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/15/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLLockScreenPresenter.h"

#import "SDLLockScreenRootViewController.h"
#import "SDLLogMacros.h"
#import "SDLStreamingMediaManagerConstants.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenPresenter ()

@property (strong, nonatomic, nullable) UIWindow *lockWindow;

@end


@implementation SDLLockScreenPresenter

- (void)stop {
    if (!self.lockWindow) {
        return;
    }

    // Remove the lock screen if presented
    [self sdl_dismissWithCompletionHandler:^{
        self.lockWindow = nil;
    }];
}

#pragma mark - Present Lock Window

- (void)present {
    SDLLogD(@"Trying to present lock screen");
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (UIApplication.sharedApplication.applicationState != UIApplicationStateActive) {
            SDLLogV(@"Application is backgrounded. The lockscreen will not be shown until the application is brought to the foreground.");
            return;
        }
        [weakSelf sdl_presentLockscreen];
    });
}

- (void)sdl_presentLockscreen {
    if (!self.lockWindow) {
        self.lockWindow = [self.class sdl_createUIWindow];
        self.lockWindow.backgroundColor = [UIColor clearColor];
        self.lockWindow.windowLevel = UIWindowLevelAlert + 1;
        self.lockWindow.rootViewController = [[SDLLockScreenRootViewController alloc] init];
    }

    // Let ourselves know that the lockscreen will present so we can pause video streaming for a few milliseconds - otherwise the animation to show the lock screen will be very janky.
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerWillPresentLockScreenViewController object:nil];

    SDLLogD(@"Presenting the lock screen window");
    [self.lockWindow makeKeyAndVisible];
    [self.lockWindow.rootViewController presentViewController:self.lockViewController animated:YES completion:^{
        // Tell everyone we are done so video streaming can resume
        [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerDidPresentLockScreenViewController object:nil];
    }];
}

#pragma mark - Dismiss Lock Window

- (void)dismiss {
    [self sdl_dismissWithCompletionHandler:nil];
}

- (void)sdl_dismissWithCompletionHandler:(void (^ _Nullable)(void))completionHandler {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (UIApplication.sharedApplication.applicationState != UIApplicationStateActive) {
            SDLLogV(@"Application is backgrounded. The lockscreen will not be dismissed until the app is brought to the foreground.");
            if (completionHandler == nil) { return; }
            return completionHandler();
        }
        [weakSelf sdl_dismissLockscreenWithCompletionHandler:completionHandler];
    });
}

- (void)sdl_dismissLockscreenWithCompletionHandler:(void (^ _Nullable)(void))completionHandler {
    if (self.lockViewController == nil) {
        SDLLogW(@"Attempted to dismiss lock screen, but lockViewController is not set");
        if (completionHandler == nil) { return; }
        return completionHandler();
    }

    if ([self sdl_dismissed]) {
        SDLLogD(@"Lock screen is already being dismissed.");
        if (completionHandler == nil) { return; }
        return completionHandler();
    }

    // Let ourselves know that the lockscreen will dismiss so we can pause video streaming for a few milliseconds - otherwise the animation to dismiss the lock screen will be very janky.
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerWillDismissLockScreenViewController object:nil];

    SDLLogD(@"Hiding the lock screen window");
    __weak typeof(self) weakSelf = self;
    [self.lockViewController dismissViewControllerAnimated:YES completion:^{
        [weakSelf.lockWindow setHidden:YES];

        // Tell everyone we are done so video streaming can resume
        [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerDidDismissLockScreenViewController object:nil];

        if (completionHandler == nil) { return; }
        return completionHandler();
    }];
}

#pragma mark - Custom Presented / Dismissed Getters

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

- (BOOL)sdl_dismissed {
    return (self.lockViewController.isBeingDismissed || self.lockViewController.isMovingFromParentViewController);
}

#pragma mark - Window Helpers

/// If the app is using `SceneDelegate` class (iOS 13+), then the `UIWindow` must be initalized using the active `UIWindowScene`. Otherwise, the newly created window will not appear on the screen even though it is added to the `UIApplication`'s `windows` stack.
+ (UIWindow *)sdl_createUIWindow {
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
             // The scene is either foreground active / inactive, background, or unattached. If the latter three, we don't want to do anything with them. Also check that the scene is for the application and not an external display or CarPlay.
            if (scene.activationState != UISceneActivationStateForegroundActive ||
                ![scene.session.role isEqualToString:UIWindowSceneSessionRoleApplication] ||
                ![scene isKindOfClass:[UIWindowScene class]]) {
                continue;
            }

            return [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
        }
    }

    return [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
}

@end

NS_ASSUME_NONNULL_END
