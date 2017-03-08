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

@interface SDLLockScreenManager : NSObject

/**
 *  Whether or not the lock screen is currently presented
 */
@property (assign, nonatomic, readonly) BOOL lockScreenPresented;

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
