//
//  SDLTouchManager.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLTouchManager.h"

#import "CGPoint_Util.h"
#import "dispatch_timer.h"

#import "SDLDebugTool.h"
#import "SDLOnTouchEvent.h"
#import "SDLPinchGesture.h"
#import "SDLProxyListener.h"
#import "SDLTouch.h"
#import "SDLTouchCoord.h"
#import "SDLTouchEvent.h"
#import "SDLTouchType.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SDLPerformingTouchType) {
    SDLPerformingTouchTypeNone,
    SDLPerformingTouchTypeSingleTouch,
    SDLPerformingTouchTypeMultiTouch,
    SDLPerformingTouchTypePanningTouch
};

/*!
 *  @abstract 
 *      Touch Manager will ignore touches that represent more than 2 fingers on the screen.
 */
static NSUInteger const MaximumNumberOfTouches = 2;

@interface SDLTouchManager () <SDLProxyListener>

/*!
 *  @abstract 
 *      First Touch received from onOnTouchEvent.
 */
@property (nonatomic, strong, nullable) SDLTouch *previousTouch;

/*!
 * @abstract 
 *      Cached previous single tap used for double tap detection.
 */
@property (nonatomic, strong, nullable) SDLTouch *singleTapTouch;

/*!
 *  @abstract
 *      Distance of a previously generated pinch event. Used to calculate the scale of zoom motion.
 */
@property (nonatomic, assign) CGFloat previousPinchDistance;

/*!
 *  @abstract
 *      Current in-progress pinch gesture.
 */
@property (nonatomic, strong, nullable) SDLPinchGesture *currentPinchGesture;

/*!
 *  @abstract
 *      Timer used for distinguishing between single & double taps.
 */
@property (nonatomic, strong, nullable) dispatch_source_t singleTapTimer;

/*!
 *  @abstract
 *      Current touch type being performed.
 */
@property (nonatomic, assign) SDLPerformingTouchType performingTouchType;

@end

@implementation SDLTouchManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    _movementTimeThreshold = 0.05f;
    _tapTimeThreshold = 0.4f;
    _tapDistanceThreshold = 50.0f;
    _touchEnabled = YES;

    return self;
}

#pragma mark - Public
- (void)cancelPendingTouches {
    [self sdl_cancelSingleTapTimer];
}

#pragma mark - SDLProxyListener Delegate
- (void)onProxyOpened {
}
- (void)onProxyClosed {
}
- (void)onOnHMIStatus:(SDLOnHMIStatus *)notification {
}
- (void)onOnDriverDistraction:(SDLOnDriverDistraction *)notification {
}

- (void)onOnTouchEvent:(SDLOnTouchEvent *)notification {
    if (!self.isTouchEnabled) {
        return;
    }

    SDLTouchEvent *touchEvent = notification.event.firstObject;

    SDLTouch *touch = [[SDLTouch alloc] initWithTouchEvent:touchEvent];

    if (touch.identifier > MaximumNumberOfTouches) {
        return;
    }

    if ([notification.type isEqualToEnum:SDLTouchType.BEGIN]) {
        [self sdl_handleTouchBegan:touch];
    } else if ([notification.type isEqualToEnum:SDLTouchType.MOVE]) {
        [self sdl_handleTouchMoved:touch];
    } else if ([notification.type isEqualToEnum:SDLTouchType.END]) {
        [self sdl_handleTouchEnded:touch];
    }
}

#pragma mark - Private
- (void)sdl_handleTouchBegan:(SDLTouch *)touch {
    if (!touch.isFirstFinger && !self.isTouchEnabled) {
        return; // no-op
    }

    _performingTouchType = SDLPerformingTouchTypeSingleTouch;

    switch (touch.identifier) {
        case SDLTouchIdentifierFirstFinger:
            self.previousTouch = touch;
            break;
        case SDLTouchIdentifierSecondFinger:
            _performingTouchType = SDLPerformingTouchTypeMultiTouch;
            self.currentPinchGesture = [[SDLPinchGesture alloc] initWithFirstTouch:self.previousTouch
                                                                       secondTouch:touch];
            self.previousPinchDistance = self.currentPinchGesture.distance;
            if ([self.touchEventDelegate respondsToSelector:@selector(touchManager:pinchDidStartAtCenterPoint:)]) {
                [self.touchEventDelegate touchManager:self
                           pinchDidStartAtCenterPoint:self.currentPinchGesture.center];
            }
            break;
    }
}

- (void)sdl_handleTouchMoved:(SDLTouch *)touch {
    if ((touch.timeStamp - self.previousTouch.timeStamp) <= (self.movementTimeThreshold * NSEC_PER_USEC) || !self.isTouchEnabled) {
        return; // no-op
    }

    switch (self.performingTouchType) {
        case SDLPerformingTouchTypeMultiTouch:
            switch (touch.identifier) {
                case SDLTouchIdentifierFirstFinger:
                    self.currentPinchGesture.firstTouch = touch;
                    break;
                case SDLTouchIdentifierSecondFinger:
                    self.currentPinchGesture.secondTouch = touch;
                    break;
            }


            if ([self.touchEventDelegate respondsToSelector:@selector(touchManager:didReceivePinchAtCenterPoint:withScale:)]) {
                CGFloat scale = self.currentPinchGesture.distance / self.previousPinchDistance;
                [self.touchEventDelegate touchManager:self
                         didReceivePinchAtCenterPoint:self.currentPinchGesture.center
                                            withScale:scale];
            }

            self.previousPinchDistance = self.currentPinchGesture.distance;
            break;
        case SDLPerformingTouchTypeSingleTouch:
            _performingTouchType = SDLPerformingTouchTypePanningTouch;
            if ([self.touchEventDelegate respondsToSelector:@selector(touchManager:panningDidStartAtPoint:)]) {
                [self.touchEventDelegate touchManager:self
                               panningDidStartAtPoint:touch.location];
            }
            break;
        case SDLPerformingTouchTypePanningTouch:
            if ([self.touchEventDelegate respondsToSelector:@selector(touchManager:didReceivePanningFromPoint:toPoint:)]) {
                [self.touchEventDelegate touchManager:self
                           didReceivePanningFromPoint:self.previousTouch.location
                                              toPoint:touch.location];
            }
            break;
        case SDLPerformingTouchTypeNone:
            break;
    }

    self.previousTouch = touch;
}

- (void)sdl_handleTouchEnded:(SDLTouch *)touch {
    if (!self.isTouchEnabled) {
        return; // no-op
    }

    switch (self.performingTouchType) {
        case SDLPerformingTouchTypeMultiTouch:
            switch (touch.identifier) {
                case SDLTouchIdentifierFirstFinger:
                    self.currentPinchGesture.firstTouch = touch;
                    break;
                case SDLTouchIdentifierSecondFinger:
                    self.currentPinchGesture.secondTouch = touch;
                    break;
            }

            if (self.currentPinchGesture.isValid) {
                if ([self.touchEventDelegate respondsToSelector:@selector(touchManager:pinchDidEndAtCenterPoint:)]) {
                    [self.touchEventDelegate touchManager:self
                                 pinchDidEndAtCenterPoint:self.currentPinchGesture.center];
                }
                self.currentPinchGesture = nil;
            }
            break;
        case SDLPerformingTouchTypePanningTouch:
            if ([self.touchEventDelegate respondsToSelector:@selector(touchManager:panningDidEndAtPoint:)]) {
                [self.touchEventDelegate touchManager:self
                                 panningDidEndAtPoint:touch.location];
            }
            break;
        case SDLPerformingTouchTypeSingleTouch:
            if (self.singleTapTimer == nil) { // Initial Tap
                self.singleTapTouch = touch;
                [self sdl_initializeSingleTapTimerAtPoint:self.singleTapTouch.location];
            } else { // Double Tap
                [self sdl_cancelSingleTapTimer];

                NSUInteger timeStampDelta = touch.timeStamp - self.singleTapTouch.timeStamp;
                CGFloat xDelta = fabs(touch.location.x - self.singleTapTouch.location.x);
                CGFloat yDelta = fabs(touch.location.y - self.singleTapTouch.location.y);

                if (timeStampDelta <= self.tapTimeThreshold * NSEC_PER_USEC && xDelta <= self.tapDistanceThreshold && yDelta <= self.tapDistanceThreshold) {
                    CGPoint centerPoint = CGPointCenterOfPoints(touch.location,
                                                                self.singleTapTouch.location);
                    if ([self.touchEventDelegate respondsToSelector:@selector(touchManager:didReceiveDoubleTapAtPoint:)]) {
                        [self.touchEventDelegate touchManager:self
                                   didReceiveDoubleTapAtPoint:centerPoint];
                    }
                }

                self.singleTapTouch = nil;
            }
            break;
        case SDLPerformingTouchTypeNone:
            break;
    }
    self.previousTouch = nil;
    _performingTouchType = SDLPerformingTouchTypeNone;
}

- (void)sdl_initializeSingleTapTimerAtPoint:(CGPoint)point {
    __weak typeof(self) weakSelf = self;
    self.singleTapTimer = dispatch_create_timer(self.tapTimeThreshold, NO, ^{
        typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.singleTapTouch = nil;
        [strongSelf sdl_cancelSingleTapTimer];
        if ([strongSelf.touchEventDelegate respondsToSelector:@selector(touchManager:didReceiveSingleTapAtPoint:)]) {
            [strongSelf.touchEventDelegate touchManager:strongSelf
                             didReceiveSingleTapAtPoint:point];
        }
    });
}

- (void)sdl_cancelSingleTapTimer {
    if (self.singleTapTimer == NULL) {
        return;
    }
    dispatch_stop_timer(self.singleTapTimer);
    self.singleTapTimer = NULL;
}

@end

NS_ASSUME_NONNULL_END