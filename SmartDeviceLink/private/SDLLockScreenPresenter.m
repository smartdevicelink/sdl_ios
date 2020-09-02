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
@property (assign, nonatomic) BOOL shouldShowLockScreen;
@property (assign, nonatomic) BOOL isDismissing;

@end

@implementation SDLLockScreenPresenter

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _shouldShowLockScreen = NO;

    return self;
}

/// Resets the manager by dismissing and destroying the lockscreen.
- (void)stopWithCompletionHandler:(nullable SDLLockScreenDidFinishHandler)completionHandler {
    self.shouldShowLockScreen = NO;

    if (self.lockWindow == nil) {
        if (completionHandler != nil) {
            completionHandler();
        }
        return;
    }

    // Dismiss and destroy the lockscreen window
    __weak typeof(self) weakSelf = self;
    [self sdl_dismissWithCompletionHandler:^(BOOL success) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (success) {
            strongSelf.lockWindow = nil;
            strongSelf.lockViewController = nil;
        }

        if (completionHandler != nil) {
            completionHandler();
        }
    }];
}

/// Shows or hides the lockscreen with an animation. If the lockscreen is shown/dismissed in rapid succession the final state of the lockscreen may not match the expected state as the order in which the animations finish can be random. To guard against this scenario, store the expected state of the lockscreen. When the animation finishes, check the expected state to make sure that the final state of the lockscreen matches the expected state. If not, perform a final animation to the expected state.
/// @param show True if the lockscreen should be shown; false if it should be dismissed
- (void)updateLockScreenToShow:(BOOL)show withCompletionHandler:(nullable SDLLockScreenDidFinishHandler)completionHandler {
    // Store the expected state of the lockscreen
    self.shouldShowLockScreen = show;

    __weak typeof(self) weakSelf = self;
    if (show) {
        [self sdl_presentWithCompletionHandler:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.shouldShowLockScreen) {
                if (completionHandler != nil) { completionHandler(); }
                return;
            }

            SDLLogV(@"The lockscreen has been presented but needs to be dismissed");
            [strongSelf sdl_dismissWithCompletionHandler:^(BOOL success) {
                if (completionHandler != nil) { completionHandler(); }
            }];
        }];
    } else {
        [self sdl_dismissWithCompletionHandler:^(BOOL success) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf.shouldShowLockScreen) {
                if (completionHandler != nil) { completionHandler(); }
                return;
            }

            SDLLogV(@"The lockscreen has been dismissed but needs to be presented");
            [strongSelf sdl_presentWithCompletionHandler:completionHandler];
        }];
    }
}


#pragma mark - Present Lock Window

/// Checks if the lockscreen can be presented and if so presents the lockscreen on the main thread
/// @param completionHandler Called when the lockscreen has finished its animation or if the lockscreen can not be presented
- (void)sdl_presentWithCompletionHandler:(nullable SDLLockScreenDidFinishHandler)completionHandler {
    if (self.lockViewController == nil) {
        SDLLogW(@"Attempted to present a lockscreen, but lockViewController is not set");
        if (completionHandler == nil) { return; }
        return completionHandler();
    }

    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __typeof(weakself) strongself = weakself;
        if (UIApplication.sharedApplication.applicationState != UIApplicationStateActive) {
            // If the the `UIWindow` is created while the app is backgrounded and the app is using `SceneDelegate` class (iOS 13+), then the window will not be created correctly. Wait until the app is foregrounded before creating the window.
            SDLLogV(@"Application is backgrounded. The lockscreen will not be shown until the application is brought to the foreground.");
            if (completionHandler == nil) { return; }
            return completionHandler();
        }

        if (strongself.lockWindow == nil) {
            strongself.lockWindow = [self.class sdl_createUIWindow];
            strongself.lockWindow.backgroundColor = [UIColor clearColor];
            strongself.lockWindow.windowLevel = UIWindowLevelAlert + 1;
            strongself.lockWindow.rootViewController = [[SDLLockScreenRootViewController alloc] init];
        }

        SDLLogD(@"Presenting the lockscreen window");
        [strongself.lockWindow makeKeyAndVisible];

        if (strongself.isPresentedOrPresenting) {
            // Call this right before attempting to present the view controller to make sure we are not already animating, otherwise the app may crash.
            SDLLogV(@"The lockscreen is already being presented");
            if (completionHandler == nil) { return; }
            return completionHandler();
        }

        // Let ourselves know that the lockscreen will present so we can pause video streaming for a few milliseconds - otherwise the animation to show the lockscreen will be very janky.
        [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerWillPresentLockScreenViewController object:nil];

        [strongself.lockWindow.rootViewController presentViewController:strongself.lockViewController animated:YES completion:^{
            // Tell everyone we are done so video streaming can resume
            [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerDidPresentLockScreenViewController object:nil];

            if (completionHandler == nil) { return; }
            return completionHandler();
        }];
    });
}


#pragma mark - Dismiss Lock Window

/// Checks if the lockscreen can be dismissed and if so dismisses the lockscreen on the main thread.
/// @param completionHandler Called when the lockscreen has finished its animation or if the lockscreen can not be dismissed
- (void)sdl_dismissWithCompletionHandler:(void (^ _Nullable)(BOOL success))completionHandler {
    if (self.lockViewController == nil) {
        SDLLogW(@"Attempted to dismiss lockscreen, but lockViewController is not set");
        if (completionHandler == nil) { return; }
        return completionHandler(NO);
    }

    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (UIApplication.sharedApplication.applicationState != UIApplicationStateActive) {
            SDLLogV(@"Application is backgrounded. The lockscreen will not be dismissed until the app is brought to the foreground.");
            if (completionHandler == nil) { return; }
            return completionHandler(NO);
        }
        [weakSelf sdl_dismissLockscreenWithCompletionHandler:completionHandler];
    });
}

/// Handles the dismissal of the lockscreen with animation.
/// @param completionHandler Called when the lockscreen is dismissed successfully or if it is already in the process of being dismissed
- (void)sdl_dismissLockscreenWithCompletionHandler:(void (^ _Nullable)(BOOL success))completionHandler {
    if (self.isDismissing || !self.isPresentedOrPresenting) {
        // Make sure we are not already animating, otherwise the app may crash
        SDLLogV(@"The lockscreen is already being dismissed");
        if (completionHandler == nil) { return; }
        return completionHandler(NO);
    }
    
    if (self.lockViewController.presentingViewController == nil) {
        SDLLogW(@"Attempted to dismiss lockscreen, but lockViewController is not presented");
        if (completionHandler == nil) { return; }
        return completionHandler(NO);
    }

    // Let ourselves know that the lockscreen will dismiss so we can pause video streaming for a few milliseconds - otherwise the animation to dismiss the lockscreen will be very janky.
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerWillDismissLockScreenViewController object:nil];

    SDLLogD(@"Dismissing the lockscreen window");
    _isDismissing = YES;
    __weak typeof(self) weakSelf = self;
    [self.lockViewController dismissViewControllerAnimated:YES completion:^{
        SDLLogD(@"Lockscreen window dismissed");
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf->_isDismissing = NO;
        [strongSelf.lockWindow setHidden:YES];

        // Tell everyone we are done so video streaming can resume
        [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerDidDismissLockScreenViewController object:nil];

        if (completionHandler == nil) { return; }
        return completionHandler(YES);
    }];
}

#pragma mark - Custom Presented / Dismissed Getters

/// Returns whether or not the lockViewController is currently presented or currently animating the presentation of the lockscreen
- (BOOL)isPresentedOrPresenting {
    return (self.lockViewController.isViewLoaded && (self.lockViewController.view.window || self.lockViewController.isBeingPresented) && self.lockWindow.isKeyWindow);
}

/// Returns whether or not the lockViewController is currently animating the dismissal of the lockscreen
- (BOOL)isDismissing {
    return (_isDismissing || self.lockViewController.isBeingDismissed || self.lockViewController.isMovingFromParentViewController);
}

#pragma mark - Window Helpers

/// If the app is using `SceneDelegate` class (iOS 13+), then the `UIWindow` must be initalized using the active `UIWindowScene`. Otherwise, the newly created window will not appear on the screen even though it is added to the `UIApplication`'s `windows` stack (This seems to be a bug as no official documentation says that a `UIWindow` must be created this way if using the `SceneDelegate` class)
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
