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

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    _lockWindow = [[UIWindow alloc] initWithFrame:screenFrame];
    _lockWindow.backgroundColor = [UIColor clearColor];
    _screenshotViewController = [[SDLScreenshotViewController alloc] init];
    _lockWindow.rootViewController = _screenshotViewController;

    return self;
}

#pragma mark - Present Lock Window

- (void)present {
    SDLLogD(@"Trying to present lock screen");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (@available(iOS 13.0, *)) {
            [self sdl_presentIOS13];
        } else {
            [self sdl_presentIOS12];
        }
    });
}

- (void)sdl_presentIOS12 {
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

    [self sdl_presentWithAppWindow:appWindow];
}

- (void)sdl_presentIOS13 {
    if (@available(iOS 13.0, *)) {
        UIWindowScene *appWindowScene = nil;
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            SDLLogV(@"Checking scene: %@", scene);
            // The scene is either foreground active / inactive, background, or unattached. If the latter three, we don't want to do anything with them. Also check that the scene is for the application and not an external display or CarPlay.
            if ((scene.activationState != UISceneActivationStateForegroundActive) ||
                (![scene.session.role isEqualToString: UIWindowSceneSessionRoleApplication])) {
                SDLLogV(@"Skipping scene due to activation state or role");
                continue;
            }

            // The scene is foreground active or inactive. Now find the windows.
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                appWindowScene = (UIWindowScene *)scene;
                break;
            } else {
                SDLLogV(@"Skipping scene due to it not being a UIWindowScene");
                continue;
            }
        }

        NSArray<UIWindow *> *windows = appWindowScene.windows;
        UIWindow *appWindow = nil;
        for (UIWindow *window in windows) {
            if (window != self.lockWindow) {
                SDLLogV(@"Found app window");
                appWindow = window;
                break;
            }
        }

        if (appWindow == nil) {
            SDLLogE(@"Unable to find the app's window");
            return;
        }

        if (![windows containsObject:self.lockWindow]) {
            self.lockWindow = [[UIWindow alloc] initWithWindowScene:appWindowScene];
            self.lockWindow.backgroundColor = [UIColor clearColor];
            self.lockWindow.rootViewController = self.screenshotViewController;
        }

        [self sdl_presentWithAppWindow:appWindow];
    }
}

- (void)sdl_presentWithAppWindow:(nullable UIWindow *)appWindow {
    if (appWindow == nil) {
        SDLLogW(@"Attempted to present lock window but app window is nil");
        return;
    }

    SDLLogD(@"Presenting lock screen window from app window: %@", appWindow);

    // We let ourselves know that the lockscreen will present, because we have to pause streaming video for that 0.3 seconds or else it will be very janky.
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerWillPresentLockScreenViewController object:nil];

    // We then move the lockWindow to the original appWindow location.
    self.lockWindow.frame = UIScreen.mainScreen.bounds;
    [self.screenshotViewController loadScreenshotOfWindow:appWindow];
    [self.lockWindow makeKeyAndVisible];

    // And present the lock screen.
    SDLLogD(@"Present lock screen window");
    [self.lockWindow.rootViewController presentViewController:self.lockViewController animated:YES completion:^{
        // Tell ourselves we are done.
        [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerDidPresentLockScreenViewController object:nil];
    }];
}

#pragma mark - Dismiss Lock Window

- (void)dismiss {
    SDLLogD(@"Trying to dismiss lock screen");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (@available(iOS 13.0, *)) {
            [self sdl_dismissIOS13];
        } else {
            [self sdl_dismissIOS12];
        }
    });
}

- (void)sdl_dismissIOS12 {
    NSArray* windows = [[UIApplication sharedApplication] windows];
    UIWindow *appWindow = nil;
    for (UIWindow *window in windows) {
        SDLLogV(@"Checking window: %@", window);
        if (window != self.lockWindow) {
            appWindow = window;
            break;
        }
    }

    [self sdl_dismissWithAppWindow:appWindow];
}

- (void)sdl_dismissIOS13 {
    if (@available(iOS 13.0, *)) {
        UIWindowScene *appWindowScene = nil;
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            SDLLogV(@"Checking scene: %@", scene);
            // The scene is either foreground active / inactive, background, or unattached. If the latter three, we don't want to do anything with them. Also check that the scene is for the application and not an external display or CarPlay.
            if ((scene.activationState != UISceneActivationStateForegroundActive) ||
                (![scene.session.role isEqualToString: UIWindowSceneSessionRoleApplication])) {
                SDLLogV(@"Skipping scene due to activation state or role");
                continue;
            }

            // The scene is foreground active or inactive. Now find the windows.
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                appWindowScene = (UIWindowScene *)scene;
                break;
            } else {
                SDLLogV(@"Skipping scene due to it not being a UIWindowScene");
                continue;
            }
        }

        NSArray<UIWindow *> *windows = appWindowScene.windows;
        UIWindow *appWindow = nil;
        for (UIWindow *window in windows) {
            SDLLogV(@"Checking window: %@", window);
            if (window != self.lockWindow) {
                appWindow = window;
                break;
            }
        }

        [self sdl_dismissWithAppWindow:appWindow];
    }
}

- (void)sdl_dismissWithAppWindow:(nullable UIWindow *)appWindow {
    if (appWindow == nil) {
        SDLLogE(@"Unable to find the app's window");
        return;
    } else if (appWindow.isKeyWindow) {
        SDLLogW(@"Attempted to dismiss lock screen, but it is already dismissed");
        return;
    } else if (self.lockViewController == nil) {
        SDLLogW(@"Attempted to dismiss lock screen, but lockViewController is not set");
        return;
    }

    // Let us know we are about to dismiss.
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerWillDismissLockScreenViewController object:nil];

    // Dismiss the lockscreen
    SDLLogD(@"Dismiss lock screen window from app window: %@", appWindow);
    [self.lockViewController dismissViewControllerAnimated:YES completion:^{
        [appWindow makeKeyAndVisible];

        // Tell ourselves we are done.
        [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerDidDismissLockScreenViewController object:nil];
    }];
}


#pragma mark - isPresented Getter

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

