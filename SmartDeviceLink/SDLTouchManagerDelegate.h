//
//  SDLTouchManagerDelegate.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDLTouchManager;

NS_ASSUME_NONNULL_BEGIN

/// The delegate to be notified of processed touches such as pinches, pans, and taps
@protocol SDLTouchManagerDelegate <NSObject>

@optional

/**
 A single tap was received

 @param manager The SDLTouchManager issuing the callback
 @param view The view under the touch if it could be determined
 @param point The point at which the touch occurred in the head unit's coordinate system
 */
- (void)touchManager:(SDLTouchManager *)manager didReceiveSingleTapForView:(UIView *_Nullable)view atPoint:(CGPoint)point;

/**
 A double tap was received

 @param manager The SDLTouchManager issuing the callback
 @param view The view under the touch if it could be determined
 @param point Location of the double tap in the head unit's coordinate system. This is the average of the first and second tap.
 */
- (void)touchManager:(SDLTouchManager *)manager didReceiveDoubleTapForView:(UIView *_Nullable)view atPoint:(CGPoint)point;

/**
 Panning started

 @param manager The SDLTouchManager issuing the callback
 @param view The view under where the panning started if it could be determined
 @param point Location of the panning start point in the head unit's coordinate system.
 */
- (void)touchManager:(SDLTouchManager *)manager panningDidStartInView:(UIView *_Nullable)view atPoint:(CGPoint)point;

/**
 Panning moved between points

 @param manager The SDLTouchManager issuing the callback
 @param fromPoint Location of the panning's previous point in the head unit's coordinate system
 @param toPoint Location of the panning's new point in the head unit's coordinate system
 */
- (void)touchManager:(SDLTouchManager *)manager didReceivePanningFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;

/**
 Panning ended

 @param manager The SDLTouchManager issuing the callback
 @param view The view under where the panning ended if it could be determined
 @param point Location of the panning's end point in the head unit's coordinate system
 */
- (void)touchManager:(SDLTouchManager *)manager panningDidEndInView:(UIView *_Nullable)view atPoint:(CGPoint)point;

/**
 Panning canceled

 @param manager The SDLTouchManager issuing the callback
 @param point Location of the panning's end point in the head unit's coordinate system
 */
- (void)touchManager:(SDLTouchManager *)manager panningCanceledAtPoint:(CGPoint)point;

/**
 Pinch did start

 @param manager The SDLTouchManager issuing the callback
 @param view The view under the center of the pinch start
 @param point Center point of the pinch in the head unit's coordinate system
 */
- (void)touchManager:(SDLTouchManager *)manager pinchDidStartInView:(UIView *_Nullable)view atCenterPoint:(CGPoint)point;

/**
 *  @abstract
 *      Pinch did move.
 *  @param manager
 *      Current initalized SDLTouchManager issuing the callback.
 *  @param point
 *      Center point of the pinch in the head unit's coordinate system.
 *  @param scale
 *      Scale relative to the distance between touch points.
 */
- (void)touchManager:(SDLTouchManager *)manager didReceivePinchAtCenterPoint:(CGPoint)point withScale:(CGFloat)scale;

/**
 Pinch moved and changed scale

 @param manager The SDLTouchManager issuing the callback
 @param view The view under the center of the pinch
 @param point Center point of the pinch in the head unit's coordinate system
 @param scale Scale relative to the distance between touch points
 */
- (void)touchManager:(SDLTouchManager *)manager didReceivePinchInView:(UIView *_Nullable)view atCenterPoint:(CGPoint)point withScale:(CGFloat)scale;

/**
 Pinch did end

 @param manager The SDLTouchManager issuing the callback
 @param view The view under the center of the pinch
 @param point Center point of the pinch in the head unit's coordinate system
 */
- (void)touchManager:(SDLTouchManager *)manager pinchDidEndInView:(UIView *_Nullable)view atCenterPoint:(CGPoint)point;

/**
 Pinch canceled

 @param manager The SDLTouchManager issuing the callback
 @param point Center point of the pinch in the head unit's coordinate system
 */
- (void)touchManager:(SDLTouchManager *)manager pinchCanceledAtCenterPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
