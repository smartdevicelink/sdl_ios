//
//  SDLLockScreenWindowViewController.m
//  SmartDeviceLink
//
//  Created by Nicole on 12/12/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLLockScreenWindowViewController.h"

@interface SDLLockScreenWindowViewController ()

@end

@implementation SDLLockScreenWindowViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}

// HAX: https://github.com/smartdevicelink/sdl_ios/issues/1250
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	UIViewController *viewController = [self sdl_topMostControllerForWindow:[UIApplication sharedApplication].windows[0]];

	if (viewController != nil) {
		return viewController.supportedInterfaceOrientations;
	}

	return super.supportedInterfaceOrientations;
}

// HAX: https://github.com/smartdevicelink/sdl_ios/issues/1250
- (BOOL)shouldAutorotate {
	UIViewController *viewController = [self sdl_topMostControllerForWindow:[UIApplication sharedApplication].windows[0]];

	if (viewController != nil) {
		return viewController.shouldAutorotate;
	}

	return super.shouldAutorotate;
}

- (UIViewController *)sdl_topMostControllerForWindow:(UIWindow *)window {
	UIViewController *topController = window.rootViewController;

	while (topController.presentedViewController) {
		topController = topController.presentedViewController;
	}

	return topController;
}

@end
