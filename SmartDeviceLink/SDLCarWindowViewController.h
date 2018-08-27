//
//  SDLCarWindowViewController.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 12/12/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Note that if this is embedded in a UINavigationController and UITabBarController, it will not lock orientation. You must lock your container controller to a specific orientation.
 */
@interface SDLCarWindowViewController : UIViewController

/**
 The supported interface orientation you wish to use. Defaults to MaskPortrait.
 */
@property (nonatomic, assign) UIInterfaceOrientation supportedOrientation;

@end
