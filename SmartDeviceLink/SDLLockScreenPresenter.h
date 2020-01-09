//
//  SDLLockScreenPresenter.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/15/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLViewControllerPresentable.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  An instance of `SDLViewControllerPresentable` used in production (not testing) for presenting the SDL lockscreen.
 */
@interface SDLLockScreenPresenter : NSObject <SDLViewControllerPresentable>

/// The view controller to be presented as a lockscreen
@property (strong, nonatomic, nullable) UIViewController *lockViewController;

@end

NS_ASSUME_NONNULL_END
