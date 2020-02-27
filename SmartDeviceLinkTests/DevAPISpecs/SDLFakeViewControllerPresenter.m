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

@end


@implementation SDLFakeViewControllerPresenter

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _shouldShowLockScreen = NO;

    return self;
}

- (void)stop {
    if (!self.lockViewController) { return; }

    _shouldShowLockScreen = NO;
}

- (void)updateLockScreenToShow:(BOOL)show withCompletionHandler:(nullable SDLLockScreenDidFinishHandler)completionHandler {
    _shouldShowLockScreen = show;

    if (completionHandler != nil) {
        completionHandler();
    }
}


@end
