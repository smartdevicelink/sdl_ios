//
//  SDLLockScreenPresenter.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/15/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLLockScreenPresenter.h"

#import "SDLLogMacros.h"
#import "SDLStreamingMediaManagerConstants.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenPresenter ()

@property (strong, nonatomic) UIWindow *lockWindow;

@end


@implementation SDLLockScreenPresenter

#pragma mark - Present Lock Window

- (void)present {
    SDLLogD(@"Trying to present lock screen");
	__weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
		[weakSelf sdl_presentLockscreen];
    });
}

- (void)sdl_presentLockscreen {
	if (!self.lockWindow) {
		self.lockWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
		self.lockWindow.backgroundColor = UIColor.clearColor;
		self.lockWindow.rootViewController = [UIViewController new];
	}

    // Let ourselves know that the lockscreen will present so we can pause video streaming for a few milliseconds - otherwise the animation to show the lock screen will be very janky.
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerWillPresentLockScreenViewController object:nil];

    SDLLogD(@"Presenting the lock screen window");
    [self.lockWindow makeKeyAndVisible];
    [self.lockWindow.rootViewController presentViewController:self.lockViewController animated:YES completion:^{
        // Tell ourselves we are done so video streaming can resume
        [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerDidPresentLockScreenViewController object:nil];
    }];
}

#pragma mark - Dismiss Lock Window

- (void)dismiss {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
		[weakSelf sdl_dismissLockscreen];
	});
}

- (void)sdl_dismissLockscreen {
	if (self.lockViewController == nil) {
        SDLLogW(@"Attempted to dismiss lock screen, but lockViewController is not set");
        return;
    }

	// Let ourselves know that the lockscreen will dismiss so we can pause video streaming for a few milliseconds - otherwise the animation to dismiss the lock screen will be very janky.
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLLockScreenManagerWillDismissLockScreenViewController object:nil];

    SDLLogD(@"Hiding the lock screen window");
    [self.lockViewController dismissViewControllerAnimated:YES completion:^{
		[self.lockWindow setHidden:YES];

        // Tell ourselves we are done so video streaming can resume
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

