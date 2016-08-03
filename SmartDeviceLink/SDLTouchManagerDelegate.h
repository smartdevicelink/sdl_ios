//
//  SDLTouchManagerDelegate.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

@import UIKit;

@class SDLTouchManager;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLTouchManagerDelegate <NSObject>

@optional

/**
 *  @abstract
 *      Single tap was received.
 *  @param manager
 *      Current initalized SDLTouchManager issuing the callback.
 *  @param point
 *      Location of the single tap in the head unit's coordinate system.
 */
- (void)touchManager:(SDLTouchManager *)manager didReceiveSingleTapAtPoint:(CGPoint)point;

/**
 *  @abstract
 *      Double tap was received.
 *  @param manager
 *      Current initalized SDLTouchManager issuing the callback.
 *  @param point
 *      Location of the double tap in the head unit's coordinate system. This is the
 *      average of the first and second tap.
 */
- (void)touchManager:(SDLTouchManager *)manager didReceiveDoubleTapAtPoint:(CGPoint)point;

/**
 *  @abstract
 *      Panning did start.
 *  @param manager
 *      Current initalized SDLTouchManager issuing the callback.
 *  @param point
 *      Location of the panning start point in the head unit's coordinate system.
 */
- (void)touchManager:(SDLTouchManager *)manager panningDidStartAtPoint:(CGPoint)point;

/**
 *  @abstract
 *      Panning did move.
 *  @param manager
 *      Current initalized SDLTouchManager issuing the callback.
 *  @param fromPoint
 *      Location of the panning's previous point in the head unit's coordinate system.
 *  @param toPoint
 *      Location of the panning's new point in the head unit's coordinate system.
 */
- (void)touchManager:(SDLTouchManager *)manager didReceivePanningFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;

/**
 *  @abstract
 *      Panning did end.
 *  @param manager
 *      Current initalized SDLTouchManager issuing the callback.
 *  @param point
 *      Location of the panning's end point in the head unit's coordinate system.
 */
- (void)touchManager:(SDLTouchManager *)manager panningDidEndAtPoint:(CGPoint)point;

/**
 *  @abstract
 *      Pinch did start.
 *  @param manager
 *      Current initalized SDLTouchManager issuing the callback.
 *  @param point
 *      Center point of the pinch in the head unit's coordinate system.
 */
- (void)touchManager:(SDLTouchManager *)manager pinchDidStartAtCenterPoint:(CGPoint)point;

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
 *  @abstract
 *      Pinch did end.
 *  @param manager
 *      Current initalized SDLTouchManager issuing the callback.
 *  @param point
 *      Center point of the pinch in the head unit's coordinate system.
 */
- (void)touchManager:(SDLTouchManager *)manager pinchDidEndAtCenterPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END