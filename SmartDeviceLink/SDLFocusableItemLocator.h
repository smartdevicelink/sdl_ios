//
//  SDLHapticManager.h
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLFocusableItemLocatorType.h"
#import "SDLFocusableItemHitTester.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLFocusableItemLocator : NSObject <SDLFocusableItemLocatorType, SDLFocusableItemHitTester>

@property (nonatomic, assign) BOOL enableHapticDataRequests;

/**
 The projection view controller associated with the Haptic Manager
 */
@property (nonatomic, strong) UIViewController *viewController;

/**
 The scale factor value to scale coordinates from one coordinate space to another.
 */
@property (assign, nonatomic) float scale;

@end

NS_ASSUME_NONNULL_END
