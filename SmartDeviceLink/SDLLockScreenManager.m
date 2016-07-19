//
//  SDLLockScreenManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/8/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLLockScreenManager.h"

#import "SDLDebugTool.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLLockScreenViewController.h"
#import "SDLLockScreenStatus.h"
#import "SDLOnLockScreenStatus.h"
#import "SDLNotificationConstants.h"
#import "SDLViewControllerPresentable.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenManager ()

@property (copy, nonatomic, readwrite) SDLLockScreenConfiguration *config;
@property (strong, nonatomic) id<SDLViewControllerPresentable> presenter;

@property (assign, nonatomic) BOOL canPresent;

@end


@implementation SDLLockScreenManager

- (instancetype)initWithConfiguration:(SDLLockScreenConfiguration *)config notificationDispatcher:(nullable id)dispatcher presenter:(id<SDLViewControllerPresentable>)presenter {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _canPresent = NO;
    _config = config; // TODO: Don't want to copy this, it could have View Controllers or images, and could be kind large
    _presenter = presenter;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenStatusDidChange:) name:SDLDidChangeLockScreenStatusNotification object:dispatcher];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_lockScreenIconReceived:) name:SDLDidReceiveLockScreenIcon object:dispatcher];
    
    return self;
}

- (void)start {
    self.canPresent = NO;
    
    // Create and initialize the lock screen controller depending on the configuration
    if (!self.config.enableAutomaticLockScreen) {
        self.presenter.viewController = nil;
        return;
    } else if (self.config.customViewController != nil) {
        self.presenter.viewController = self.config.customViewController;
    } else {
        NSBundle *sdlBundle = [NSBundle bundleForClass:[self class]];
//        NSBundle *sdlBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SmartDeviceLink" ofType:@"bundle"]; TODO: Remove if no longer needed. Tests pass, but need real world usage.
        
        SDLLockScreenViewController *lockScreenVC = nil;
        @try {
            lockScreenVC = [[UIStoryboard storyboardWithName:@"SDLLockScreen" bundle:sdlBundle] instantiateInitialViewController];
        } @catch (NSException *exception) {
            [SDLDebugTool logInfo:@"SDL Error: Attempted to instantiate the default SDL Lock Screen and could not find the storyboard. Be sure the 'SmartDeviceLink' bundle is within your main bundle. We're just going to return without instantiating the lock screen."];
            return;
        }
        
        lockScreenVC.appIcon = self.config.appIcon;
        lockScreenVC.backgroundColor = self.config.backgroundColor;
        self.presenter.viewController = lockScreenVC;
    }
    
    self.canPresent = YES;
}

- (void)stop {
    self.canPresent = NO;
    
    // Remove the lock screen if presented, don't allow it to present again until we start
    [self.presenter dismiss];
}

- (nullable UIViewController *)lockScreenViewController {
    return self.presenter.viewController;
}


#pragma mark - Notification Selectors

- (void)sdl_lockScreenStatusDidChange:(NSNotification *)notification {
    if (self.lockScreenViewController == nil) {
        return;
    }
    
    SDLOnLockScreenStatus *onLockScreenNotification = notification.userInfo[SDLNotificationUserInfoObject];
    
    // Present the VC depending on the lock screen status
    if ([onLockScreenNotification.lockScreenStatus isEqualToEnum:[SDLLockScreenStatus REQUIRED]]) {
        if (!self.presenter.presented && self.canPresent) {
            [self.presenter present];
        }
    } else if ([onLockScreenNotification.lockScreenStatus isEqualToEnum:[SDLLockScreenStatus OPTIONAL]]) {
        if (self.config.showInOptional && !self.presenter.presented && self.canPresent) {
            [self.presenter present];
        } else if (self.presenter.presented) {
            [self.presenter dismiss];
        }
    } else if ([onLockScreenNotification.lockScreenStatus isEqualToEnum:[SDLLockScreenStatus OFF]]) {
        if (self.presenter.presented) {
            [self.presenter dismiss];
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
