//
//  ConnectionTabBarController.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Joel Fischer on 9/23/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "ConnectionTabBarController.h"

#import "Preferences.h"

@interface ConnectionTabBarController () <UITabBarControllerDelegate>

@end

@implementation ConnectionTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    Preferences.sharedPreferences.lastUsedSegment = [tabBar.items indexOfObject:item];
}

@end
