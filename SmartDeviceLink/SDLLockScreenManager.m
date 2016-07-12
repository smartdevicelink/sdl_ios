//
//  SDLLockScreenManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/8/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLLockScreenManager.h"

#import "SDLLockScreenConfiguration.h"
#import "SDLLockScreenViewController.h"
#import "SDLLockScreenStatus.h"
#import "SDLOnLockScreenStatus.h"
#import "SDLNotificationConstants.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenManager ()

@property (assign, nonatomic, readwrite) BOOL lockScreenPresented;

@property (copy, nonatomic) SDLLockScreenConfiguration *config;

@property (assign, nonatomic) BOOL canPresent;
@property (strong, nonatomic, nullable) UIViewController *lockScreenViewController;

@end


@implementation SDLLockScreenManager

- (instancetype)initWithConfiguration:(SDLLockScreenConfiguration *)config notificationDispatcher:(nullable id)dispatcher {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _lockScreenPresented = NO;
    _canPresent = NO;
    _config = config; // TODO: Don't want to copy this, it could have View Controllers or images, and could be kind large
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenStatusDidChange:) name:SDLDidChangeLockScreenStatusNotification object:dispatcher];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenIconReceived:) name:SDLDidReceiveVehicleIconNotification object:dispatcher];
    
    return self;
}

- (void)start {
    self.canPresent = NO;
    
    // Create and initialize the lock screen controller depending on the configuration
    if (!self.config.enableAutomaticLockScreen) {
        self.lockScreenViewController = nil;
        return;
    } else if (self.config.customViewController != nil) {
        self.lockScreenViewController = self.config.customViewController;
    } else {
        NSBundle *sdlBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SmartDeviceLink" ofType:@"bundle"]];
        SDLLockScreenViewController *lockScreenVC = [[UIStoryboard storyboardWithName:@"SDLLockScreen" bundle:sdlBundle] instantiateInitialViewController];
        lockScreenVC.appIcon = self.config.appIcon;
        lockScreenVC.backgroundColor = self.config.backgroundColor;
        self.lockScreenViewController = lockScreenVC;
    }
    
    self.canPresent = YES;
}

- (void)stop {
    self.canPresent = NO;
    
    // Remove the lock screen if presented, don't allow it to present again until we start
    [self.lockScreenViewController dismissViewControllerAnimated:YES completion:nil];
}

- (UIViewController *)sdl_getCurrentViewController {
    // http://stackoverflow.com/questions/6131205/iphone-how-to-find-topmost-view-controller
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController != nil) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}


#pragma mark - Notification Selectors

- (void)sdl_lockScreenStatusDidChange:(NSNotification *)notification {
    if (self.lockScreenViewController == nil) {
        return;
    }
    
    SDLOnLockScreenStatus *onLockScreenNotification = notification.userInfo[SDLNotificationUserInfoObject];
    
    // Present the VC depending on the lock screen status
    if ([onLockScreenNotification.lockScreenStatus isEqualToEnum:[SDLLockScreenStatus REQUIRED]]) {
        if (!self.lockScreenPresented && self.canPresent) {
            [[self sdl_getCurrentViewController] presentViewController:self.lockScreenViewController animated:YES completion:nil];
            self.lockScreenPresented = YES;
        }
    } else if ([onLockScreenNotification.lockScreenStatus isEqualToEnum:[SDLLockScreenStatus OPTIONAL]]) {
        if (self.config.showInOptional && !self.lockScreenPresented && self.canPresent) {
            [[self sdl_getCurrentViewController] presentViewController:self.lockScreenViewController animated:YES completion:nil];
            self.lockScreenPresented = YES;
        } else if (self.lockScreenPresented) {
            [self.lockScreenViewController dismissViewControllerAnimated:YES completion:nil];
            self.lockScreenPresented = NO;
        }
    } else if ([onLockScreenNotification.lockScreenStatus isEqualToEnum:[SDLLockScreenStatus OFF]]) {
        if (self.lockScreenPresented) {
            [self.lockScreenViewController dismissViewControllerAnimated:YES completion:nil];
            self.lockScreenPresented = NO;
        }
    }
}

- (void)sdl_lockScreenIconReceived:(NSNotification *)notification {
    UIImage *icon = notification.userInfo[SDLNotificationUserInfoObject];
    
    // If the VC is our special type, then add the vehicle icon. If they passed in a custom VC, there's no current way to show the vehicle icon. If they're managing it themselves, they can grab the notification themselves.
    if ([self.lockScreenViewController isKindOfClass:[SDLLockScreenViewController class]]) {
        ((SDLLockScreenViewController *)self.lockScreenViewController).vehicleIcon = icon;
    }
}

@end

NS_ASSUME_NONNULL_END
