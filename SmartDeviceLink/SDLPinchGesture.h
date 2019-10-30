//
//  SDLPinchGesture.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLTouch.h"

NS_ASSUME_NONNULL_BEGIN

/// Pinch Gesture information
@interface SDLPinchGesture : NSObject

/**
 *  @abstract
 *      Initializes a pinch gesture.
 *  @param firstTouch
 *      First touch of the gesture
 *  @param secondTouch
 *      Second touch of the gesture
 *  @return SDLPinchGesture
 *      Instance of SDLPinchGesture.
 */
- (instancetype)initWithFirstTouch:(SDLTouch *)firstTouch secondTouch:(SDLTouch *)secondTouch;

/**
 *  @abstract
 *      First touch of a pinch gesture.
 */
@property (nonatomic, strong) SDLTouch *firstTouch;

/**
 *  @abstract
 *      Second touch of a pinch gesture.
 */
@property (nonatomic, strong) SDLTouch *secondTouch;

/**
 *  @abstract
 *      Distance between first and second touches.
 */
@property (nonatomic, assign, readonly) CGFloat distance;

/**
 *  @abstract
 *      Center point between first and second touches.
 */
@property (nonatomic, assign, readonly) CGPoint center;

/**
 *  @abstract
 *      Returns whether or not the pinch gesture is valid. This is true if both touches
 *      are non null.
 */
@property (nonatomic, assign, readonly) BOOL isValid;

@end

NS_ASSUME_NONNULL_END
