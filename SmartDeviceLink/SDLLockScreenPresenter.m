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
@property (assign, nonatomic) BOOL presented;

@end


@implementation SDLLockScreenPresenter

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _presented = NO;

    return self;
}

- (void)stop {
    self.presented = NO;

    if (!self.lockWindow) {
        return;
    }

    // Remove the lockscreen if presented
    [self sdl_dismissWithCompletionHandler:^{
        self.lockWindow = nil;
    }];
}

- (void)updateLockScreenToShow:(BOOL)show {
    self.presented = show;

    if (show) {
        [self sdl_presentWithCompletionHandler:^{
            if (self.presented) { return; }

            SDLLogV(@"The lockscreen has been presented but needs to be dismissed");
            [self sdl_dismissWithCompletionHandler:nil];
        }];
    } else {
        [self sdl_dismissWithCompletionHandler:^{
            if (!self.presented) { return; }

            SDLLogV(@"The lockscreen has been dismissed but needs to be presented");
            [self sdl_presentLockscreenWithCompletionHandler:nil];
        }];
    }
}


#pragma mark - Present Lock Window

- (void)sdl_presentWithCompletionHandler:(void (^ _Nullable)(void))completionHandler {
    SDLLogD(@"Trying to present lockscreen");
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (UIApplication.sharedApplication.applicationState != UIApplicationStateActive) {
            // If the the `UIWindow` is created while the app is backgrounded and the app is using `SceneDelegate` class (iOS 13+), then the window will not be created correctly. Wait until the app is foregrounded before creating the window.
            SDLLogV(@"Application is backgrounded. The lockscreen will not be shown until the application is brought to the foreground.");
            if (completionHandler == nil) { return; }
            return completionHandler();
        }
        [weakSelf sdl_presentLockscreenWithCompletionHandler:completionHandler];
    });
}

- (void)sdl_presentLockscreenWithCompletionHandler:(void (^ _Nullable)(void))completionHandler {
    if (!self.lockWindow) {
        self.lockWindow = [self.class sdl_createUIWindow];
        self.lockWindow.backgroundColor = [UIColor clearColor];
        self.lockWindow.windowLevel = UIWindowLevelAlert + 1;
        self.lockWindow.rootViewController = [[SDLLockScreenRootViewController alloc] init];
    }

    SDLLogD(@"Presenting the lockscreen window");
    [self.lockWindow makeKeyAndVisible];

    if ([self sdl_isPresented]) {
        // Call this right before attempting to present the view controller to make sure we are not already animating, otherwise the app may crash.
        SDLLogV(@"The lockscreen is already being presented");
        if (completionHandler == nil) { return; }
        return completionHandler();
    }

    // Let ourselves know that the lockscreen will present so we can pause video streaming for a few milliseconds - otherwise the animation to show the lockscreen will be very janky.
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerWillPresentLockScreenViewController object:nil];

    [self.lockWindow.rootViewController presentViewController:self.lockViewController animated:YES completion:^{
        // Tell everyone we are done so video streaming can resume
        [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerDidPresentLockScreenViewController object:nil];

        if (completionHandler == nil) { return; }
        return completionHandler();
    }];
}


#pragma mark - Dismiss Lock Window

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
        SDLLogW(@"Attempted to dismiss lockscreen, but lockViewController is not set");
        if (completionHandler == nil) { return; }
        return completionHandler();
    }

    if ([self sdl_isBeingDismissed]) {
        // Make sure we are not already animating, otherwise the app may crash
        SDLLogV(@"The lockscreen is already being dismissed");
        if (completionHandler == nil) { return; }
        return completionHandler();
    }

    // Let ourselves know that the lockscreen will dismiss so we can pause video streaming for a few milliseconds - otherwise the animation to dismiss the lockscreen will be very janky.
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerWillDismissLockScreenViewController object:nil];

    SDLLogD(@"Hiding the lockscreen window");
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

- (BOOL)sdl_isPresented {
    return (self.lockViewController.isViewLoaded && (self.lockViewController.view.window || self.lockViewController.isBeingPresented) && self.lockWindow.isKeyWindow);
}

- (BOOL)sdl_isBeingDismissed {
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
