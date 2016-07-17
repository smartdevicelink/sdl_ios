//
//  SDLTouchManagerListener.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

@class SDLTouchManager;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLTouchManagerListener <NSObject>

@optional
- (void)touchManager:(SDLTouchManager*)manager didReceiveSingleTapAtPoint:(CGPoint)point;
- (void)touchManager:(SDLTouchManager*)manager didReceiveDoubleTapAtPoint:(CGPoint)point;

- (void)touchManager:(SDLTouchManager*)manager panningDidStartAtPoint:(CGPoint)point;
- (void)touchManager:(SDLTouchManager*)manager didReceivePanningFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
- (void)touchManager:(SDLTouchManager*)manager panningDidEndAtPoint:(CGPoint)point;

- (void)touchManager:(SDLTouchManager*)manager pinchDidStartAtCenterPoint:(CGPoint)point;
- (void)touchManager:(SDLTouchManager*)manager didReceivePinchAtCenterPoint:(CGPoint)point withScale:(CGFloat)scale;
- (void)touchManager:(SDLTouchManager*)manager pinchDidEndAtCenterPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END