//
//  SDLFakeViewControllerPresenter.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/18/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLFakeViewControllerPresenter.h"


@interface SDLFakeViewControllerPresenter ()

@property (assign, nonatomic) BOOL showLockScreen;

@end


@implementation SDLFakeViewControllerPresenter

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _showLockScreen = NO;

    return self;
}

- (void)stop {
    if (!self.lockViewController) { return; }

    _showLockScreen = NO;
}

- (void)updateLockScreenToShow:(BOOL)show {
    _showLockScreen = show;
}


@end
