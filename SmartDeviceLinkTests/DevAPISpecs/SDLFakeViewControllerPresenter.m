//
//  SDLFakeViewControllerPresenter.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/18/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLFakeViewControllerPresenter.h"


@interface SDLFakeViewControllerPresenter ()

@property (assign, nonatomic, readwrite) BOOL presented;
@property (assign, nonatomic, readwrite) BOOL dismissed;

@end


@implementation SDLFakeViewControllerPresenter

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _presented = NO;
    _dismissed = NO;

    return self;
}

- (void)present {
    if (!self.lockViewController) { return; }
    
    _presented = YES;
    _dismissed = NO;
}

- (void)dismiss {
    if (!self.lockViewController) { return; }
    
    _presented = NO;
    _dismissed = YES;
}

- (void)stop {
    if (!self.lockViewController) { return; }

    _presented = NO;
    _dismissed = YES;
}

- (void)lockScreenPresentationStatusWithHandler:(nonnull SDLLockScreenPresentationStatusHandler)handler {
    return handler(_presented, _dismissed);
}

@end
