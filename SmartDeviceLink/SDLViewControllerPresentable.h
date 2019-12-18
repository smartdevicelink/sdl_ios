//
//  SDLViewControllerPresentable.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/15/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Handler for the lock screen's current presentation status
/// @param isPresented Returns true if the lock screen is presented or is in the process of being presented
/// @param isBeingDismissed Returns true if the lock screen is in the process of being dismissed
typedef void(^SDLLockScreenPresentationStatusHandler)(BOOL isPresented, BOOL isBeingDismissed);

/// A protocol used to tell a view controller to present another view controller. This makes testing of modal VCs' presentation easier.
@protocol SDLViewControllerPresentable <NSObject>

/// The view controller to be presented as a lock screen
@property (strong, nonatomic, nullable) UIViewController *lockViewController;

/// Presents the lock screen with animation
- (void)present;

/// Dismisses the lock screen with animation
- (void)dismiss;

/// Dismisses and destroys the lock screen window
- (void)stop;

/// Gets the presentation status of the lock screen. Since the view controller must be presented on the main thread, we must wait for the main thread to return the status.
/// @param handler A SDLLockScreenPresentationStatusHandler
- (void)lockScreenPresentationStatusWithHandler:(nonnull SDLLockScreenPresentationStatusHandler)handler;

- (void)updateLockscreenStatus:(BOOL)presented;

@end

NS_ASSUME_NONNULL_END
