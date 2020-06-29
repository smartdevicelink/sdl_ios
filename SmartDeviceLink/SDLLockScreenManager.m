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
#import "SDLLockScreenStatusManager.h"
#import "SDLLockScreenStatus.h"
#import "SDLLockScreenViewController.h"
#import "SDLNotificationConstants.h"
#import "SDLNotificationDispatcher.h"
#import "SDLOnLockScreenStatus.h"
#import "SDLOnDriverDistraction.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLViewControllerPresentable.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenManager ()

@property (assign, nonatomic) BOOL canPresent;
@property (strong, nonatomic, readwrite) SDLLockScreenConfiguration *config;
@property (strong, nonatomic) id<SDLViewControllerPresentable> presenter;
@property (strong, nonatomic) SDLLockScreenStatusManager *statusManager;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (strong, nonatomic, nullable) SDLOnLockScreenStatus *lastLockNotification;
#pragma clang diagnostic pop

@property (strong, nonatomic, nullable) SDLOnDriverDistraction *lastDriverDistractionNotification;
@property (assign, nonatomic, readwrite, getter=isLockScreenDismissable) BOOL lockScreenDismissable;
@property (assign, nonatomic) BOOL lockScreenDismissedByUser;

@end


@implementation SDLLockScreenManager

- (instancetype)initWithConfiguration:(SDLLockScreenConfiguration *)config notificationDispatcher:(SDLNotificationDispatcher *)dispatcher presenter:(id<SDLViewControllerPresentable>)presenter {
    self = [super init];
    if (!self) {
        return nil;
    }

    _canPresent = NO;
    _lockScreenDismissable = NO;
    _config = config;
    _presenter = presenter;
    _lockScreenDismissedByUser = NO;
    _statusManager = [[SDLLockScreenStatusManager alloc] initWithNotificationDispatcher:dispatcher];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenStatusDidChange:) name:SDLDidChangeLockScreenStatusNotification object:_statusManager];
#pragma clang diagnostic pop
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenIconReceived:) name:SDLDidReceiveLockScreenIcon object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_driverDistractionStateDidChange:) name:SDLDidChangeDriverDistractionStateNotification object:dispatcher];

    return self;
}

- (void)start {
    self.canPresent = NO;

    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (UIApplication.sharedApplication.applicationState != UIApplicationStateActive) {
            SDLLogW(@"Attempted to start lock screen manager, but we are in the background. We will attempt to start again when we are in the foreground.");
            return;
        }

        // This usually means that we disconnected and connected with the device in the background. We will need to check and dismiss the view controller if it's presented before setting up a new one.
        if (strongSelf.presenter.lockViewController != nil) {
            [strongSelf.presenter stopWithCompletionHandler:^{
                __strong typeof(weakSelf) strongSelf2 = weakSelf;
                [strongSelf2 sdl_start];
            }];
        } else {
            [strongSelf sdl_start];
        }
    });
}

- (void)sdl_start {
    // Create and initialize the lock screen controller depending on the configuration
    if (self.config.displayMode == SDLLockScreenConfigurationDisplayModeNever) {
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

    [self sdl_checkLockScreen];
}

- (void)stop {
    // Don't allow the lockscreen to present again until we start
    self.canPresent = NO;
    self.lastLockNotification = nil;
    self.lastDriverDistractionNotification = nil;
    [self.presenter stopWithCompletionHandler:nil];
}

- (nullable UIViewController *)lockScreenViewController {
    return self.presenter.lockViewController;
}

#pragma mark - Notification Selectors

- (void)sdl_lockScreenStatusDidChange:(SDLRPCNotificationNotification *)notification {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (![notification isNotificationMemberOfClass:[SDLOnLockScreenStatus class]]) {
#pragma clang diagnostic pop
        return;
    }

    self.lastLockNotification = notification.notification;

    [self sdl_checkLockScreen];
}

- (void)sdl_lockScreenIconReceived:(NSNotification *)notification {
    if (![notification.userInfo[SDLNotificationUserInfoObject] isKindOfClass:[UIImage class]]) {
        return;
    }

    UIImage *icon = notification.userInfo[SDLNotificationUserInfoObject];

    // If the VC is our special type, then add the vehicle icon. If they passed in a custom VC, there's no current way to show the vehicle icon. If they're managing it themselves, they can grab the notification themselves.
    if ([self.lockScreenViewController isKindOfClass:[SDLLockScreenViewController class]] && self.config.showDeviceLogo) {
        ((SDLLockScreenViewController *)self.lockScreenViewController).vehicleIcon = icon;
    }
}

- (void)sdl_appDidBecomeActive:(NSNotification *)notification {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // Restart, and potentially dismiss the lock screen if the app was disconnected in the background
        if (!strongSelf.canPresent) {
            [strongSelf start];
        }

        [strongSelf sdl_checkLockScreen];
    });
}

- (void)sdl_driverDistractionStateDidChange:(SDLRPCNotificationNotification *)notification {
    if (![notification isNotificationMemberOfClass:[SDLOnDriverDistraction class]]) {
        return;
    }

    self.lastDriverDistractionNotification = notification.notification;
    [self sdl_updateLockScreenDismissable];
}

#pragma mark - Private Helpers

- (void)sdl_checkLockScreen {
    if (self.lockScreenViewController == nil || self.lastLockNotification == nil) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf sdl_updatePresentation];
    });
}

- (void)sdl_updatePresentation {
    if (self.config.displayMode == SDLLockScreenConfigurationDisplayModeAlways) {
        if (self.canPresent) {
            [self.presenter updateLockScreenToShow:YES withCompletionHandler:nil];
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    } else if ([self.lastLockNotification.lockScreenStatus isEqualToEnum:SDLLockScreenStatusRequired]) {
#pragma clang diagnostic pop
        if (self.canPresent && !self.lockScreenDismissedByUser) {
            [self.presenter updateLockScreenToShow:YES withCompletionHandler:nil];
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    } else if ([self.lastLockNotification.lockScreenStatus isEqualToEnum:SDLLockScreenStatusOptional]) {
#pragma clang diagnostic pop
        if (self.config.displayMode == SDLLockScreenConfigurationDisplayModeOptionalOrRequired && self.canPresent && !self.lockScreenDismissedByUser) {
            [self.presenter updateLockScreenToShow:YES withCompletionHandler:nil];
        } else if (self.config.displayMode != SDLLockScreenConfigurationDisplayModeOptionalOrRequired) {
            [self.presenter updateLockScreenToShow:NO withCompletionHandler:nil];
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    } else if ([self.lastLockNotification.lockScreenStatus isEqualToEnum:SDLLockScreenStatusOff]) {
#pragma clang diagnostic pop
        [self.presenter updateLockScreenToShow:NO withCompletionHandler:nil];
    }
}

- (void)sdl_updateLockScreenDismissable {
    if (self.lastDriverDistractionNotification == nil ||
        self.lastDriverDistractionNotification.lockScreenDismissalEnabled == nil ||
        !self.lastDriverDistractionNotification.lockScreenDismissalEnabled.boolValue ||
        !self.config.enableDismissGesture) {
        self.lockScreenDismissable = NO;
    } else {
        self.lockScreenDismissable = YES;
    }
    
    if (self.lockScreenDismissedByUser &&
        [self.lastDriverDistractionNotification.state isEqualToEnum:SDLDriverDistractionStateOn] &&
        !self.lockScreenDismissable) {
        self.lockScreenDismissedByUser = NO;
    }

    if (!self.lockScreenDismissedByUser) {
        [self sdl_updateLockscreenViewControllerWithDismissableState:self.lockScreenDismissable];
    }
}

- (void)sdl_updateLockscreenViewControllerWithDismissableState:(BOOL)enabled {
    if (![self.lockScreenViewController isKindOfClass:[SDLLockScreenViewController class]]) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        SDLLockScreenViewController *lockscreenViewController = (SDLLockScreenViewController *)strongSelf.lockScreenViewController;
        if (enabled) {
            [lockscreenViewController addDismissGestureWithCallback:^{
                [strongSelf.presenter updateLockScreenToShow:NO withCompletionHandler:nil];
                strongSelf.lockScreenDismissedByUser = YES;
            }];
            lockscreenViewController.lockedLabelText = strongSelf.lastDriverDistractionNotification.lockScreenDismissalWarning;
        } else {
            [lockscreenViewController removeDismissGesture];
            lockscreenViewController.lockedLabelText = nil;
        }
    });
}

@end

NS_ASSUME_NONNULL_END
