//
//  SDLTouchManager.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLTouchManagerDelegate.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLTouchManager : NSObject

@property (nonatomic, weak, nullable) id<SDLTouchManagerDelegate> touchEventDelegate;

/**
 *  @abstract
 *      Distance between two taps on the screen, in the head unit's coordinate system, used
 *      for registering double-tap callbacks.
 *  @remark
 *      Default is 50 pixels.
 */
@property (nonatomic, assign) CGFloat tapDistanceThreshold;

/**
 *  @abstract
 *      Time (in seconds) between tap events to register a double-tap callback.
 *  @remark
 *      Default is 0.4 seconds.
 */
@property (nonatomic, assign) CGFloat tapTimeThreshold;

/**
 *  @abstract
 *      Time (in seconds) between movement events to register panning or pinching 
 *      callbacks.
 *  @remark
 *      Default is 0.05 seconds.
 */
@property (nonatomic, assign) CGFloat movementTimeThreshold;

/**
 *  @abstract
 *      Boolean denoting whether or not the touch manager should deliver touch event
 *      callbacks.
 *  @remark
 *      Default is true.
 */
@property (nonatomic, assign, getter=isTouchEnabled) BOOL touchEnabled;

/**
 *  @abstract
 *      Cancels pending touch event timers that may be in progress.
 *  @remark
 *      Currently only impacts the timer used to register single taps.
 */
- (void)cancelPendingTouches;

@end

NS_ASSUME_NONNULL_END