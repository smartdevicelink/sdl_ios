//
//  SDLFakeViewControllerPresenter.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/18/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLFakeViewControllerPresenter.h"

@implementation SDLFakeViewControllerPresenter

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }
    
    _presented = NO;
    
    return self;
}

- (void)presentViewController:(UIViewController *)viewController {
    _presented = YES;
}

- (void)dismissViewController:(UIViewController *)viewController {
    _presented = NO;
}

@end
