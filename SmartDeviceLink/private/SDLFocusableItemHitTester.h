//
//  SDLFocusableItemHitTester.h
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDLTouch;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLFocusableItemHitTester <NSObject>

/**
 Determines which view was selected based on SDLTouch object. If no view gets matched null value will be returned.

 @param point Point to check for a view
 @return point UIView object or nil
 */
- (nullable UIView *)viewForPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
