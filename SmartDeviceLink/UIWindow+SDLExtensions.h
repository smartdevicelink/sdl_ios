//
//  UIWindow+SDLExtensions.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/2/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (SDLExtensions)

@property (strong, nonatomic, readonly) UIViewController *sdl_topMostController;

@end

NS_ASSUME_NONNULL_END
