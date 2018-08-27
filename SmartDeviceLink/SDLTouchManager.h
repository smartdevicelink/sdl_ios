//
//  SDLTouchManager.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLTouchType.h"

@protocol SDLFocusableItemHitTester;
@protocol SDLTouchManagerDelegate;

@class SDLTouch;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDLTouchEventHandler)(SDLTouch *touch, SDLTouchType type);


@interface SDLTouchManager : NSObject

/**
 Notified of processed touches such as pinches, pans, and taps
 */
@property (nonatomic, weak, nullable) id<SDLTouchManagerDelegate> touchEventDelegate;

/**
 *  @abstract
 *      Returns all OnTouchEvent notifications as SDLTouch and SDLTouchType objects.
 */
@property (copy, nonatomic, nullable) SDLTouchEventHandler touchEventHandler;

/**
 Distance between two taps on the screen, in the head unit's coordinate system, used for registering double-tap callbacks.

 @note Defaults to 50 px.
 */
@property (nonatomic, assign) CGFloat tapDistanceThreshold;

/**
 Minimum distance for a pan gesture in the head unit's coordinate system, used for registering pan callbacks.
 
 @note Defaults to 8 px.
 */
@property (nonatomic, assign) CGFloat panDistanceThreshold;

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
@property (nonatomic, assign) CGFloat movementTimeThreshold __deprecated_msg("This is now unused, the movement time threshold is now synced to the framerate automatically");

/**
 If set to NO, the display link syncing will be ignored and `movementTimeThreshold` will be used. Defaults to YES.
 */
@property (assign, nonatomic) BOOL enableSyncedPanning;

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

- (instancetype)init NS_UNAVAILABLE;

/**
 Initialize a touch manager with a hit tester if available

 @param hitTester The hit tester to be used to correlate a point with a view
 @return The initialized touch manager
 */
- (instancetype)initWithHitTester:(nullable id<SDLFocusableItemHitTester>)hitTester;

/**
 Called by SDLStreamingMediaManager in sync with the streaming framerate. This helps to moderate panning gestures by allowing the UI to be modified in time with the framerate.
 */
- (void)syncFrame;

@end

NS_ASSUME_NONNULL_END
