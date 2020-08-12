//
//  SDLFakeViewControllerPresenter.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/18/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLFakeViewControllerPresenter.h"


@interface SDLFakeViewControllerPresenter ()

@property (assign, nonatomic) BOOL shouldShowLockScreen;
@property (strong, nonatomic, nullable) UIViewController *lockVC;

@end


@implementation SDLFakeViewControllerPresenter

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _shouldShowLockScreen = NO;

    return self;
}

- (void)stopWithCompletionHandler:(nullable SDLLockScreenDidFinishHandler)completionHandler {
    if (!self.lockViewController) { return; }

    _shouldShowLockScreen = NO;

    if (completionHandler != nil) {
        completionHandler();
    }
}

- (void)updateLockScreenToShow:(BOOL)show withCompletionHandler:(nullable SDLLockScreenDidFinishHandler)completionHandler {
    _shouldShowLockScreen = show;

    if (completionHandler != nil) {
        completionHandler();
    }
}

- (void)setLockViewController:(UIViewController *)lockViewController {
    self.lockVC = lockViewController;
}

- (UIViewController *)lockViewController {
    return self.lockVC;
}

@end
