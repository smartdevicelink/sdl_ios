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

/**
 Whether or not this will attempt to send haptic RPCs.

 @note Defaults to NO.
 */
@property (nonatomic, assign) BOOL enableHapticDataRequests;

/**
 The projection view controller associated with the Haptic Manager
 */
@property (nonatomic, strong) UIViewController *viewController;

@end

NS_ASSUME_NONNULL_END
