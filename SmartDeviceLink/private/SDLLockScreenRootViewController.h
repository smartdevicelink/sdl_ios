//
//  SDLLockScreenRootViewController.h
//  SmartDeviceLink
//
//  Created by Nicole on 12/12/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// This is the first `viewController` set in the lock screen's `UIWindow`. It's purpose is to fix an Apple bug where having a `UIWindow` (it does not even need to be active, simply created) can break the app's view controller based rotation. This bug lets the status/home bars rotate even if the view controller only supports one orientation.
@interface SDLLockScreenRootViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
