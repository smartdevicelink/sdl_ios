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

@end

NS_ASSUME_NONNULL_END
