//
//  UIWindow+SDLExtensions.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/2/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "UIWindow+SDLExtensions.h"

@implementation UIWindow (SDLExtensions)

- (UIViewController *)sdl_topMostController {
    UIViewController *topController = self.rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}

@end
