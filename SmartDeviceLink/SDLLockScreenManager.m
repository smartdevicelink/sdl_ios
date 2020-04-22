//
//  SDLLockScreenManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/8/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLLockScreenManager.h"

#import "NSBundle+SDLBundle.h"
#import "SDLGlobals.h"
#import "SDLLogMacros.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLLockScreenStatus.h"
#import "SDLLockScreenViewController.h"
#import "SDLNotificationConstants.h"
#import "SDLOnLockScreenStatus.h"
#import "SDLOnDriverDistraction.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLViewControllerPresentable.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenManager ()

/// Concurrent queue for executing the lockscreen tasks. When updates to the lockscreen UI are performed, the current thread is blocked until the main thread finishes executing the block. This can cause deadlock if the lockscreen UI updates are preformed from a serial queue because another class can perform a blocking dispatch to the same serial queue from the main thread.
@property (copy, nonatomic) dispatch_queue_t lockscreenQueue;

@property (assign, nonatomic) BOOL canPresent;
@property (strong, nonatomic, readwrite) SDLLockScreenConfiguration *config;
@property (strong, nonatomic) id<SDLViewControllerPresentable> presenter;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (strong, nonatomic, nullable) SDLOnLockScreenStatus *lastLockNotification;
#pragma clang diagnostic pop

@property (strong, nonatomic, nullable) SDLOnDriverDistraction *lastDriverDistractionNotification;
@property (assign, nonatomic, readwrite, getter=isLockScreenDismissable) BOOL lockScreenDismissable;
@property (assign, nonatomic) BOOL lockScreenDismissedByUser;

@end


@implementation SDLLockScreenManager

- (instancetype)initWithConfiguration:(SDLLockScreenConfiguration *)config notificationDispatcher:(nullable id)dispatcher presenter:(id<SDLViewControllerPresentable>)presenter {
    self = [super init];
    if (!self) {
        return nil;
    }

    if (@available(iOS 10.0, *)) {
        _lockscreenQueue = dispatch_queue_create_with_target("com.sdl.lockscreen.manager", DISPATCH_QUEUE_CONCURRENT, [SDLGlobals sharedGlobals].sdlConcurrentQueue);
    } else {
        _lockscreenQueue = [SDLGlobals sharedGlobals].sdlConcurrentQueue;
    }

    _canPresent = NO;
    _lockScreenDismissable = NO;
    _config = config;
    _presenter = presenter;
    _lockScreenDismissedByUser = NO;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenStatusDidChange:) name:SDLDidChangeLockScreenStatusNotification object:dispatcher];
#pragma clang diagnostic pop
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenIconReceived:) name:SDLDidReceiveLockScreenIcon object:dispatcher];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_driverDistractionStateDidChange:) name:SDLDidChangeDriverDistractionStateNotification object:dispatcher];

    return self;
}

- (void)start {
    self.canPresent = NO;

    __weak typeof(self) weakSelf = self;
   [self sdl_runAsyncOnConcurrentQueue:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;

        // This usually means that we disconnected and connected with the device in the background. We will need to check and dismiss the view controller if it's presented before setting up a new one.
        if (strongSelf.presenter.lockViewController != nil) {
            [strongSelf.presenter stopWithCompletionHandler:^{
                __strong typeof(weakSelf) strongSelf2 = weakSelf;
                [strongSelf2 sdl_start];
            }];
        } else {
            [strongSelf sdl_start];
        }
    }];
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
    self.canPresent = NO;

    // Don't allow the lockscreen to present again until we start
    __weak typeof(self) weakSelf = self;
    [self sdl_runAsyncOnConcurrentQueue:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.lastLockNotification = nil;
        strongSelf.lastDriverDistractionNotification = nil;
        [strongSelf.presenter stopWithCompletionHandler:nil];
    }];
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

    // Don't allow the lockscreen to present again until we start
    __weak typeof(self) weakSelf = self;
    [self sdl_runAsyncOnConcurrentQueue:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf sdl_checkLockScreen];
    }];
}

- (void)sdl_lockScreenIconReceived:(NSNotification *)notification {
    NSAssert([notification.userInfo[SDLNotificationUserInfoObject] isKindOfClass:[UIImage class]], @"A notification was sent with an unanticipated object");
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
    // Restart, and potentially dismiss the lock screen if the app was disconnected in the background
    if (!self.canPresent) {
        [self start];
    }

    // Notifications are always sent on the main thread so we do not need to dispatch tasks to the concurrent queue.
    [self sdl_checkLockScreen];
}

- (void)sdl_driverDistractionStateDidChange:(SDLRPCNotificationNotification *)notification {
    if (![notification isNotificationMemberOfClass:[SDLOnDriverDistraction class]]) {
        return;
    }

    self.lastDriverDistractionNotification = notification.notification;

    __weak typeof(self) weakSelf = self;
    [self sdl_runAsyncOnConcurrentQueue:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf sdl_updateLockScreenDismissable];
    }];
}

#pragma mark - Private Helpers

- (void)sdl_checkLockScreen {
    if (self.lockScreenViewController == nil || self.lastLockNotification == nil) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    [self sdl_runOnMainQueue:^{
        [weakSelf sdl_updatePresentation];
    }];
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
    [self sdl_runOnMainQueue:^{
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
    }];
}

#pragma mark - Threading Utilities

/// Checks if we are already on the main queue. If so, the block is added to the queue; if not, the block is dispatched to the main queue.
/// @discussion Used to ensure that updates to the lock screen UI are done on the main thread.
/// @param block The block to be executed.
- (void)sdl_runOnMainQueue:(void (^)(void))block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

/// Checks if we are already on a concurrent queue. If so, the block is added to the queue; if not, the block is dispatched to the concurrent `processing` queue.
/// @discussion Used to ensure that the lock screen updates are not done on a serial queue (other than the main queue). Otherwise deadlock may occur if another class tries to  `dispatch_sync` to a serial queue from the main thread while this class attempts to `dispatch_sync` to the main queue from the same serial queue.
/// @param block The block to be executed.
- (void)sdl_runAsyncOnConcurrentQueue:(void (^)(void))block {
    if (dispatch_get_specific(SDLConcurrentQueueName) != nil) {
        block();
    } else {
        dispatch_async(self.lockscreenQueue, block);
    }
}

@end

NS_ASSUME_NONNULL_END
