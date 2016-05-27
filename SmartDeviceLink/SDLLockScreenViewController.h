//
//  SDLLockScreenViewController.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/7/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLLockScreenViewController : UIViewController

@property (copy, nonatomic, nullable) UIImage *appIcon;
@property (copy, nonatomic, nullable) UIImage *vehicleIcon;
@property (copy, nonatomic, nullable) UIColor *backgroundColor;

@end

NS_ASSUME_NONNULL_END