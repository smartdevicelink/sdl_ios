//
//  SDLLockScreenViewControllerSnapshotTests.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/27/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

@import UIKit;
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

#import "SDLLockScreenConfiguration.h"
#import "SDLLockScreenViewController.h"


@interface SDLLockScreenViewControllerSnapshotTests : FBSnapshotTestCase

@property (strong, nonatomic) SDLLockScreenViewController *lockScreenViewController;

@end


@implementation SDLLockScreenViewControllerSnapshotTests

- (void)setUp {
    [super setUp];
    
    self.lockScreenViewController = [[UIStoryboard storyboardWithName:@"SDLLockScreen" bundle:[NSBundle bundleForClass:[self class]]] instantiateInitialViewController];
    self.lockScreenViewController.view.frame = [[UIScreen mainScreen] bounds];
    
//    self.deviceAgnostic = YES;
//    self.recordMode = YES;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNoAppNoVehicleIcons {
    self.lockScreenViewController.appIcon = nil;
    self.lockScreenViewController.vehicleIcon = nil;
    self.lockScreenViewController.backgroundColor = [SDLLockScreenConfiguration enabledConfiguration].backgroundColor;
    
    FBSnapshotVerifyView(self.lockScreenViewController.view, nil);
}

- (void)testOnlyAppIcon {
    self.lockScreenViewController.appIcon = [UIImage imageNamed:@"TestLockScreenAppIcon" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    self.lockScreenViewController.vehicleIcon = nil;
    self.lockScreenViewController.backgroundColor = [SDLLockScreenConfiguration enabledConfiguration].backgroundColor;
    
    FBSnapshotVerifyView(self.lockScreenViewController.view, nil);
}

- (void)testOnlyVehicleIcon {
    self.lockScreenViewController.appIcon = nil;
    self.lockScreenViewController.vehicleIcon = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    self.lockScreenViewController.backgroundColor = [SDLLockScreenConfiguration enabledConfiguration].backgroundColor;
    
    FBSnapshotVerifyView(self.lockScreenViewController.view, nil);
}

- (void)testAppAndVehicleIcons {
    self.lockScreenViewController.appIcon = [UIImage imageNamed:@"TestLockScreenAppIcon" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];;
    self.lockScreenViewController.vehicleIcon = [UIImage imageNamed:@"testImagePNG" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    self.lockScreenViewController.backgroundColor = [SDLLockScreenConfiguration enabledConfiguration].backgroundColor;
    
    FBSnapshotVerifyView(self.lockScreenViewController.view, nil);
}

- (void)testLightBackgroundNoAppNoVehicleIcons {
    self.lockScreenViewController.appIcon = nil;
    self.lockScreenViewController.vehicleIcon = nil;
    self.lockScreenViewController.backgroundColor = [UIColor whiteColor];
    
    FBSnapshotVerifyView(self.lockScreenViewController.view, nil);
}

@end
