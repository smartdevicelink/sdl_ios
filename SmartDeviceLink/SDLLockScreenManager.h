//
//  SDLLockScreenManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/8/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDLLockScreenConfiguration;
@class SDLLockScreenViewController;
@protocol SDLViewControllerPresentable;


NS_ASSUME_NONNULL_BEGIN

/// Manages presenting and dismissing the lock screen based on several settings:
/// 1. The lock screen configuration set by the developer. If the set to the default configuration, the lock screen manager will show or hide the lockscreen based on the the current `hmiLevel` of the SDL app and the current driver distraction (DD) status. However, the developer can also set the lockscreen to always show or not show at all.
/// 2. Whether the passenger has dismissed the lockscreen (RPC v.6.0+). Once the passenger has dismissed the lockscreen, it will not be shown again during the same session.
///
/// | LockScreenStatus | HMILevel       | DD  |
/// |------------------|----------------|-----|
/// | OFF              | HMI_NONE       | -   |
/// | OFF              | HMI_BACKGROUND | OFF |
/// | REQUIRED         | HMI_BACKGROUND | ON  |
/// | OPTIONAL         | HMI_FULL       | OFF |
/// | REQUIRED         | HMI_FULL       | ON  |
/// | OPTIONAL         | HMI_LIMITED    | OFF |
/// | REQUIRED         | HMI_LIMITED    | ON  |
@interface SDLLockScreenManager : NSObject

/**
 *  Whether or not the lock screen is currently presented
 */
@property (assign, nonatomic, readonly) BOOL lockScreenPresented;

/**
 *  Whether or not the lock screen is currently dismissable
 */
@property (assign, nonatomic, readonly, getter=isLockScreenDismissable) BOOL lockScreenDismissable;

/**
 *  The lock screen configuration used to set up the manager
 */
@property (strong, nonatomic, readonly) SDLLockScreenConfiguration *config;

/**
 *  The view controller to be shown as a lock screen.
 */
@property (strong, nonatomic, readonly, nullable) UIViewController *lockScreenViewController;

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Create a new instance of `SDLLockScreenManager`.
 *
 *  @param config     The config to set up the manager.
 *  @param dispatcher The notification dispatcher used to watch only for SDL notifications from it.
 *  @param presenter  The presenter which will handle actually presenting the lock screen view controller.
 *
 *  @return An instance of `SDLLockScreenManager`.
 */
- (instancetype)initWithConfiguration:(SDLLockScreenConfiguration *)config notificationDispatcher:(nullable id)dispatcher presenter:(id<SDLViewControllerPresentable>)presenter;

/**
 *  Start the manager. This is used internally.
 */
- (void)start;

/**
 *  Stop the manager. This is used internally.
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
