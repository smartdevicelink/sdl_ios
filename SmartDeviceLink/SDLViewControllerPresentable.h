//
//  SDLViewControllerPresentable.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/15/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// A protocol used to tell a view controller to present another view controller. This makes testing of modal VCs' presentation easier.
@protocol SDLViewControllerPresentable <NSObject>

/// The view controller to be presented as a lock screen
@property (strong, nonatomic, nullable) UIViewController *lockViewController;

/// Dismisses and destroys the lock screen window
- (void)stop;

/// Shows or hides the lock screen with animation
/// @param show True if the lock screen should be presented; false if dismissed.
- (void)updateLockScreenToShow:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
