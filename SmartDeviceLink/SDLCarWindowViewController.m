//
//  SDLCarWindowViewController.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 12/12/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLCarWindowViewController.h"

@implementation SDLCarWindowViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) { return nil; }

    [self commonInit];

    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (!self) { return nil; }

    [self commonInit];

    return self;
}

- (void)commonInit {
    _supportedOrientation = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.supportedOrientation == 0) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return (1 << self.supportedOrientation);
    }
}

@end
