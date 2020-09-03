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
@class SDLStreamingVideoScaleManager;

NS_ASSUME_NONNULL_BEGIN

/// Handler for touch events
///
/// @param touch Describes a touch location
/// @param type The type of touch
typedef void(^SDLTouchEventHandler)(SDLTouch *touch, SDLTouchType type);

/// Touch Manager responsible for processing touch event notifications.
@interface SDLTouchManager : NSObject

/**
 Notified of processed touches such as pinches, pans, and taps
 */
@property (nonatomic, weak, nullable) id<SDLTouchManagerDelegate> touchEventDelegate;

/**
 Returns all OnTouchEvent notifications as SDLTouch and SDLTouchType objects.
 */
@property (copy, nonatomic, nullable) SDLTouchEventHandler touchEventHandler;

/**
 Distance between two taps on the screen, in the head unit's coordinate system, used for registering double-tap callbacks.

 Defaults to 50 px.
 */
@property (nonatomic, assign) CGFloat tapDistanceThreshold;

/**
 Minimum distance for a pan gesture in the head unit's coordinate system, used for registering pan callbacks.
 
 Defaults to 8 px.
 */
@property (nonatomic, assign) CGFloat panDistanceThreshold;

/**
 Time (in seconds) between tap events to register a double-tap callback. This must be greater than 0.0.

 Default is 0.4 seconds.
 */
@property (nonatomic, assign) CGFloat tapTimeThreshold;

/**
 If set to NO, the display link syncing will be ignored. Defaults to YES.
 */
@property (assign, nonatomic) BOOL enableSyncedPanning;

/**
 Boolean denoting whether or not the touch manager should deliver touch event callbacks.

 Default is true.
 */
@property (nonatomic, assign, getter=isTouchEnabled) BOOL touchEnabled;

/**
 Cancels pending touch event timers that may be in progress.

 Currently only impacts the timer used to register single taps.
 */
- (void)cancelPendingTouches;

/// Initializer unavailable
- (instancetype)init NS_UNAVAILABLE;

/**
 Initialize a touch manager with a hit tester and a video scale manager.

 @param hitTester The hit tester to be used to correlate a point with a view
 @param videoScaleManager The scale manager that scales from the display screen coordinate system to the app's viewport coordinate system
 @return The initialized touch manager
 */
- (instancetype)initWithHitTester:(nullable id<SDLFocusableItemHitTester>)hitTester videoScaleManager:(SDLStreamingVideoScaleManager *)videoScaleManager;

/**
 Called by SDLStreamingMediaManager in sync with the streaming framerate. This helps to moderate panning gestures by allowing the UI to be modified in time with the framerate.
 */
- (void)syncFrame;

@end

NS_ASSUME_NONNULL_END
