//
//  SDLViewControllerPresentable.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/15/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SDLLockScreenDidFinishHandler)(void);

/// A protocol used to tell a view controller to present another view controller. This makes testing of modal VCs' presentation easier.
@protocol SDLViewControllerPresentable <NSObject>

/// The view controller to be presented as a lockscreen
@property (strong, nonatomic, nullable) UIViewController *lockViewController;

/// Whether or not the lockscreen should be presented
@property (assign, nonatomic, readonly) BOOL shouldShowLockScreen;

/// Dismisses and destroys the lock screen window
- (void)stopWithCompletionHandler:(nullable SDLLockScreenDidFinishHandler)completionHandler;

/// Shows or hides the lock screen with animation
/// @param show True if the lock screen should be presented; false if dismissed.
- (void)updateLockScreenToShow:(BOOL)show withCompletionHandler:(nullable SDLLockScreenDidFinishHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
