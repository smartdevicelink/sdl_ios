//
//  SDLHapticManager.h
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLFocusableItemLocatorType.h"
#import "SDLFocusableItemHitTester.h"

@class SDLStreamingVideoScaleManager;

NS_ASSUME_NONNULL_BEGIN

@interface SDLFocusableItemLocator : NSObject <SDLFocusableItemLocatorType, SDLFocusableItemHitTester>

@property (nonatomic, assign) BOOL enableHapticDataRequests;

/**
 The projection view controller associated with the Haptic Manager
 */
@property (nonatomic, strong) UIViewController *viewController;

@property (nonatomic, strong) SDLStreamingVideoScaleManager *videoScaleManager;

@end

NS_ASSUME_NONNULL_END
