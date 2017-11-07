//
//  SDLLockScreenPresenter.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/15/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLLockScreenPresenter.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenPresenter ()

@end


@implementation SDLLockScreenPresenter

- (void)present {
    if (!self.viewController) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [[self.class sdl_getCurrentViewController] presentViewController:self.viewController animated:YES completion:nil];
    });
}

- (void)dismiss {
    if (!self.viewController) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    });
}

- (BOOL)presented {
    if (!self.viewController) {
        return NO;
    }

    __block BOOL presented = NO;
    dispatch_sync(dispatch_get_main_queue(), ^{
        presented = (self.viewController.isViewLoaded && (self.viewController.view.window || self.viewController.isBeingPresented));
    });

    return presented;
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
