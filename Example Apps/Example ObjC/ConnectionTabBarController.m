//
//  ConnectionTabBarController.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Joel Fischer on 9/23/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "ConnectionTabBarController.h"

#import "Preferences.h"

@interface ConnectionTabBarController ()

@end

@implementation ConnectionTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectedIndex = Preferences.sharedPreferences.lastUsedSegment;
}

@end
