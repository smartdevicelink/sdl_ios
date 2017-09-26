//
//  SDLHapticHitTester.h
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDLTouch;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLHapticHitTester <NSObject>

/**
 Determines which view was selected based on SDLTouch object. If no view gets matched null value will be returned.

 @param touch SDLTouch which has touch coordinates
 @return matched UIView object or null
 */
- (nullable UIView *)viewForSDLTouch:(SDLTouch *)touch;

@end

NS_ASSUME_NONNULL_END
