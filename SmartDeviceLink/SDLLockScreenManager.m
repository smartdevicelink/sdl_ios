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
@property (strong, nonatomic, nullable) SDLHMILevel previousHMILevel;

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
    _previousHMILevel = nil;

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
    if (self.presenter.lockViewController != nil) {
        [self.presenter dismiss];
    }
}

- (nullable UIViewController *)lockScreenViewController {
    return self.presenter.lockViewController;
}


#pragma mark - Notification Selectors

- (void)sdl_lockScreenStatusDidChange:(SDLRPCNotificationNotification *)notification {
    if (![notification isNotificationMemberOfClass:[SDLOnLockScreenStatus class]]) {
        return;
    }

    self.previousHMILevel = self.lastLockNotification.hmiLevel;
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
        } else if (self.presenter.presented && [self.class sdl_canDismissLockScreenWithLockScreenStatus:self.lastLockNotification previousHMILevel:self.previousHMILevel showInOptionalState:self.config.showInOptionalState]) {
            [self.presenter dismiss];
        } else {
            NSLog(@"boo");
        }
    } else if ([self.lastLockNotification.lockScreenStatus isEqualToEnum:SDLLockScreenStatusOff]) {
        if (self.presenter.presented) {
            [self.presenter dismiss];
        }
    }
}

/**
 * Checks if the lock screen can be dismissed. If the the app is currently in the "lock screen optional" state and the `showInOptionalState` has been set to true, then the lock screen should not be dismissed.
 *
 *  @param lockScreenStatus    The most recent lock screen status received from SDL Core
 *  @param previousHMILevel    The previous `hmiLevel`
 *  @param showInOptionalState Whether or not the lock screen should be shown in the "lock screen optional" state
 *  @return                    True if the lock screen can be dismissed; false if not
 */
+ (BOOL)sdl_canDismissLockScreenWithLockScreenStatus:(nullable SDLOnLockScreenStatus *)lockScreenStatus previousHMILevel:(nullable SDLHMILevel)previousHMILevel showInOptionalState:(BOOL)showInOptionalState {
    BOOL currentlyInShowInOptionalState = [self sdl_inLockScreenOptionalStateForLockScreenStatus:lockScreenStatus previousHMILevel:previousHMILevel];

    if (currentlyInShowInOptionalState && showInOptionalState) {
        return false;
    }

    return true;
}

/**
 *  Checks if the app is currently in the "lock screen optional" state.
 *
 *  @discussion In order for the "lock screen optional" state to occur, the following must be true:
 *  1. The app should have received at least 1 driver distraction notification (i.e. a `OnDriverDistraction` notification) from SDL Core. Older versions of Core did not send a notification immediately on connection.
 *  2. The driver is not distracted (i.e. the last `OnDriverDistraction` notification received was for a driver distraction state off).
 *  3. The `hmiLevel` can not be `NONE`.
 *  4. If the `hmiLevel` is currently `BACKGROUND` then the previous `hmiLevel` should have been `FULL` or `LIMITED` (i.e. the user should have interacted with app before it was backgrounded).
 *
 *  @param lockScreenStatus The most recent lock screen status received from SDL Core
 *  @param previousHMILevel The previous `hmiLevel`
 *  @return                 True if currently if the "lock screen optional" state; false if not
 */
+ (BOOL)sdl_inLockScreenOptionalStateForLockScreenStatus:(nullable SDLOnLockScreenStatus *)lockScreenStatus previousHMILevel:(nullable SDLHMILevel)previousHMILevel {
    if (lockScreenStatus == nil ||
        lockScreenStatus.driverDistractionStatus.boolValue ||
        [lockScreenStatus.hmiLevel isEqualToEnum:SDLHMILevelNone]) {
        return false;
    }

    if ([lockScreenStatus.hmiLevel isEqualToEnum:SDLHMILevelFull] || [lockScreenStatus.hmiLevel isEqualToEnum:SDLHMILevelLimited]) {
        return true;
    } else if ([lockScreenStatus.hmiLevel isEqualToEnum:SDLHMILevelBackground] && ([previousHMILevel isEqualToEnum:SDLHMILevelLimited] || [previousHMILevel isEqualToEnum:SDLHMILevelFull])) {
        return true;
    }

    return false;
}

@end

NS_ASSUME_NONNULL_END
