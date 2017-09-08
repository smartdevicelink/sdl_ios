//
//  SDLTableViewController.m
//  SmartDeviceLink-iOS
//
//  Created by EBUser on 9/7/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLTableViewController.h"
#import "SDLNotificationConstants.h"

@implementation SDLTableViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLProjectionViewUpdate object:nil];
}

@end
