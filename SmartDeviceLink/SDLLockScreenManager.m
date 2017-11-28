//
//  SDLLockScreenManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/8/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLLockScreenManager.h"

#import "NSBundle+SDLBundle.h"
#import "SDLLogMacros.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLLockScreenStatus.h"
#import "SDLLockScreenViewController.h"
#import "SDLNotificationConstants.h"
#import "SDLOnLockScreenStatus.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLScreenshotViewController.h"
#import "SDLViewControllerPresentable.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenManager ()

@property (assign, nonatomic) BOOL canPresent;
@property (strong, nonatomic, readwrite) SDLLockScreenConfiguration *config;
@property (strong, nonatomic) id<SDLViewControllerPresentable> presenter;
@property (strong, nonatomic, nullable) SDLOnLockScreenStatus *lastLockNotification;

@end


@implementation SDLLockScreenManager

- (instancetype)initWithConfiguration:(SDLLockScreenConfiguration *)config notificationDispatcher:(nullable id)dispatcher presenter:(id<SDLViewControllerPresentable>)presenter {
    self = [super init];
    if (!self) {
        return nil;
    }

    _canPresent = NO;
    _config = config;
    _presenter = presenter;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenStatusDidChange:) name:SDLDidChangeLockScreenStatusNotification object:dispatcher];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenIconReceived:) name:SDLDidReceiveLockScreenIcon object:dispatcher];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

    return self;
}

- (void)start {
    self.canPresent = NO;

    // Create and initialize the lock screen controller depending on the configuration
    if (!self.config.enableAutomaticLockScreen) {
        self.presenter.lockViewController = nil;
        return;
    } else if (self.config.customViewController != nil) {
        self.presenter.lockViewController = self.config.customViewController;
    } else {
        SDLLockScreenViewController *viewController = nil;

        @try {
            viewController = [[UIStoryboard storyboardWithName:@"SDLLockScreen" bundle:[NSBundle sdlBundle]] instantiateInitialViewController];
        } @catch (NSException *exception) {
            SDLLogE(@"Attempted to instantiate the default SDL Lock Screen and could not find the storyboard. Be sure the 'SmartDeviceLink' bundle is within your main bundle. We're just going to return without instantiating the lock screen");
            return;
        }

        viewController.appIcon = self.config.appIcon;
        viewController.backgroundColor = self.config.backgroundColor;
        self.presenter.lockViewController = viewController;
    }

    self.canPresent = YES;
}

- (void)stop {
    self.canPresent = NO;

    // Remove the lock screen if presented, don't allow it to present again until we start
    [self.presenter dismiss];
}

- (nullable UIViewController *)lockScreenViewController {
    return self.presenter.lockViewController;
}


#pragma mark - Notification Selectors

- (void)sdl_lockScreenStatusDidChange:(SDLRPCNotificationNotification *)notification {
    if (![notification isNotificationMemberOfClass:[SDLOnLockScreenStatus class]]) {
        return;
    }

    self.lastLockNotification = notification.notification;
    [self sdl_checkLockScreen];
}

- (void)sdl_lockScreenIconReceived:(NSNotification *)notification {
    NSAssert([notification.userInfo[SDLNotificationUserInfoObject] isKindOfClass:[UIImage class]], @"A notification was sent with an unanticipated object");
    if (![notification.userInfo[SDLNotificationUserInfoObject] isKindOfClass:[UIImage class]]) {
        return;
    }

    UIImage *icon = notification.userInfo[SDLNotificationUserInfoObject];

    // If the VC is our special type, then add the vehicle icon. If they passed in a custom VC, there's no current way to show the vehicle icon. If they're managing it themselves, they can grab the notification themselves.
    if ([self.lockScreenViewController isKindOfClass:[SDLLockScreenViewController class]]) {
        ((SDLLockScreenViewController *)self.lockScreenViewController).vehicleIcon = icon;
    }
}

- (void)sdl_appDidBecomeActive:(NSNotification *)notification {
    [self sdl_checkLockScreen];
}


#pragma mark - Private Helpers

- (void)sdl_checkLockScreen {
    if (self.lockScreenViewController == nil || self.lastLockNotification == nil) {
        return;
    }

    // Present the VC depending on the lock screen status
    if ([self.lastLockNotification.lockScreenStatus isEqualToEnum:SDLLockScreenStatusRequired]) {
        if (!self.presenter.presented && self.canPresent) {
            [self.presenter present];
        }
    } else if ([self.lastLockNotification.lockScreenStatus isEqualToEnum:SDLLockScreenStatusOptional]) {
        if (self.config.showInOptionalState && !self.presenter.presented && self.canPresent) {
            [self.presenter present];
        } else if (self.presenter.presented) {
            [self.presenter dismiss];
        }
    } else if ([self.lastLockNotification.lockScreenStatus isEqualToEnum:SDLLockScreenStatusOff]) {
        if (self.presenter.presented) {
            [self.presenter dismiss];
        }
    }
}

@end

NS_ASSUME_NONNULL_END
