//
//  SDLTouchManager.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLTouchManager.h"

#import "CGPoint_Util.h"
#import "SDLGlobals.h"
#import "SDLFocusableItemHitTester.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLOnTouchEvent.h"
#import "SDLPinchGesture.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLStreamingVideoScaleManager.h"
#import "SDLTimer.h"
#import "SDLTouch.h"
#import "SDLTouchCoord.h"
#import "SDLTouchEvent.h"
#import "SDLTouchManagerDelegate.h"

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

@interface SDLTouchManager ()

/*!
 *  @abstract
 *      First touch received from onOnTouchEvent.
 */
@property (nonatomic, strong, nullable) SDLTouch *firstTouch;

/*!
 *  @abstract
 *      Previous touch received from onOnTouchEvent.
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
@property (nonatomic, strong, nullable) SDLTimer *singleTapTimer;

/*!
 *  @abstract
 *      Current touch type being performed.
 */
@property (nonatomic, assign) SDLPerformingTouchType performingTouchType;

/**
 A hit tester that allows us to check for a view based on coordinates, if available.
 */
@property (nonatomic, weak, nullable) id<SDLFocusableItemHitTester> hitTester;

/**
 The last panning touch we received
 */
@property (nonatomic) CGPoint lastStoredTouchLocation;

/**
 The last panning touch that we notified the developer about
 */
@property (nonatomic) CGPoint lastNotifiedTouchLocation;

/**
 The scale manager that scales from the display screen coordinate system to the app's viewport coordinate system
*/
@property (strong, nonatomic) SDLStreamingVideoScaleManager *videoScaleManager;

@end

@implementation SDLTouchManager

- (instancetype)initWithHitTester:(nullable id<SDLFocusableItemHitTester>)hitTester {
    return [self initWithHitTester:hitTester videoScaleManager:[[SDLStreamingVideoScaleManager alloc] init]];
}

- (instancetype)initWithHitTester:(nullable id<SDLFocusableItemHitTester>)hitTester videoScaleManager:(SDLStreamingVideoScaleManager *)videoScaleManager {
    self = [super init];
    if (!self) {
        return nil;
    }

    _hitTester = hitTester;
    _videoScaleManager = videoScaleManager;
    _movementTimeThreshold = 0.05f;
    _tapTimeThreshold = 0.4f;
    _tapDistanceThreshold = 50.0f;
    _panDistanceThreshold = 8.0f;
    _touchEnabled = YES;
    _enableSyncedPanning = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_onTouchEvent:) name:SDLDidReceiveTouchEventNotification object:nil];

    return self;
}

#pragma mark - Public
- (void)cancelPendingTouches {
    [self sdl_cancelSingleTapTimer];
}

- (void)syncFrame {
    if (!self.isTouchEnabled || (!self.touchEventHandler && !self.touchEventDelegate)) {
        return;
    }

    if (self.performingTouchType == SDLPerformingTouchTypePanningTouch) {
        CGPoint storedTouchLocation = self.lastStoredTouchLocation;
        CGPoint notifiedTouchLocation = self.lastNotifiedTouchLocation;

        if (CGPointEqualToPoint(storedTouchLocation, CGPointZero) ||
            CGPointEqualToPoint(notifiedTouchLocation, CGPointZero) ||
            CGPointEqualToPoint(storedTouchLocation, notifiedTouchLocation)) {
            return;
        }

        if ([self.touchEventDelegate respondsToSelector:@selector(touchManager:didReceivePanningFromPoint:toPoint:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.touchEventDelegate touchManager:self
                           didReceivePanningFromPoint:notifiedTouchLocation
                                              toPoint:storedTouchLocation];

                self.lastNotifiedTouchLocation = storedTouchLocation;
            });
        }
    } else if (self.performingTouchType == SDLPerformingTouchTypeMultiTouch) {
        if (self.previousPinchDistance == self.currentPinchGesture.distance) {
            return;
        }

        if ([self.touchEventDelegate respondsToSelector:@selector(touchManager:didReceivePinchAtCenterPoint:withScale:)]) {

            CGFloat scale = self.currentPinchGesture.distance / self.previousPinchDistance;
            CGPoint center = self.currentPinchGesture.center;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.touchEventDelegate touchManager:self
                         didReceivePinchAtCenterPoint:center
                                            withScale:scale];
            });
        }

        self.previousPinchDistance = self.currentPinchGesture.distance;
    }
}

#pragma mark - SDLDidReceiveTouchEventNotification

/**
 *  Handles detecting the type and state of the gesture and notifies the appropriate delegate callbacks.

 *  @param notification     A SDLOnTouchEvent notification.
 */
- (void)sdl_onTouchEvent:(SDLRPCNotificationNotification *)notification {
    if (!self.isTouchEnabled
        || (!self.touchEventHandler && !self.touchEventDelegate)
        || ![notification.notification isKindOfClass:SDLOnTouchEvent.class]) {
        return;
    }

    SDLOnTouchEvent *onTouchEvent = (SDLOnTouchEvent *)notification.notification;
    onTouchEvent = [self.videoScaleManager scaleTouchEventCoordinates:onTouchEvent];

    SDLTouchType touchType = onTouchEvent.type;
    [onTouchEvent.event enumerateObjectsUsingBlock:^(SDLTouchEvent *touchEvent, NSUInteger idx, BOOL *stop) {
        SDLTouch *touch = [[SDLTouch alloc] initWithTouchEvent:touchEvent];

        if (self.touchEventHandler != NULL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.touchEventHandler(touch, touchType);
            });
        }

        if (!self.touchEventDelegate || (touch.identifier > MaximumNumberOfTouches)) {
            return;
        }

        if ([onTouchEvent.type isEqualToEnum:SDLTouchTypeBegin]) {
            [self sdl_handleTouchBegan:touch];
        } else if ([onTouchEvent.type isEqualToEnum:SDLTouchTypeMove]) {
            [self sdl_handleTouchMoved:touch];
        } else if ([onTouchEvent.type isEqualToEnum:SDLTouchTypeEnd]) {
            [self sdl_handleTouchEnded:touch];
        } else if ([onTouchEvent.type isEqualToEnum:SDLTouchTypeCancel]) {
            [self sdl_handleTouchCanceled:touch];
        }
    }];
}

#pragma mark - Private
/**
 *  Handles a BEGIN touch event sent by Core
 *
 *  @param touch Gesture information
 */
- (void)sdl_handleTouchBegan:(SDLTouch *)touch {
    _performingTouchType = SDLPerformingTouchTypeSingleTouch;

    switch (touch.identifier) {
        case SDLTouchIdentifierFirstFinger: {
            self.firstTouch = touch;
            self.previousTouch = touch;
        } break;
        case SDLTouchIdentifierSecondFinger: {
            _performingTouchType = SDLPerformingTouchTypeMultiTouch;
            self.currentPinchGesture = [[SDLPinchGesture alloc] initWithFirstTouch:self.previousTouch secondTouch:touch];
            self.previousPinchDistance = self.currentPinchGesture.distance;
            if ([self.touchEventDelegate respondsToSelector:@selector(touchManager:pinchDidStartInView:atCenterPoint:)]) {
                CGPoint center = self.currentPinchGesture.center;
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIView *hitView = (self.hitTester != nil) ? [self.hitTester viewForPoint:center] : nil;
                    [self.touchEventDelegate touchManager:self pinchDidStartInView:hitView atCenterPoint:center];
                });
            }
        } break;
    }
}

/**
 *  Handles a MOVE touch event sent by Core
 *
 *  @param touch Gesture information
 */
- (void)sdl_handleTouchMoved:(SDLTouch *)touch {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (!self.enableSyncedPanning &&
        ((touch.timeStamp - self.previousTouch.timeStamp) <= (self.movementTimeThreshold * NSEC_PER_USEC))) {
        return; // no-op
    }
#pragma clang diagnostic pop

    CGFloat xDelta = fabs(touch.location.x - self.firstTouch.location.x);
    CGFloat yDelta = fabs(touch.location.y - self.firstTouch.location.y);
    if (xDelta <= self.panDistanceThreshold && yDelta <= self.panDistanceThreshold) {
        return;
    }

    switch (self.performingTouchType) {
        case SDLPerformingTouchTypeMultiTouch: {
            switch (touch.identifier) {
                case SDLTouchIdentifierFirstFinger: {
                    self.currentPinchGesture.firstTouch = touch;
                } break;
                case SDLTouchIdentifierSecondFinger: {
                    self.currentPinchGesture.secondTouch = touch;
                } break;
            }

            if (!self.enableSyncedPanning) {
                [self syncFrame];
            }
        } break;
        case SDLPerformingTouchTypeSingleTouch: {
            self.lastNotifiedTouchLocation = touch.location;
            self.lastStoredTouchLocation = touch.location;

            _performingTouchType = SDLPerformingTouchTypePanningTouch;
            if ([self.touchEventDelegate respondsToSelector:@selector(touchManager:panningDidStartInView:atPoint:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIView *hitView = (self.hitTester != nil) ? [self.hitTester viewForPoint:touch.location] : nil;
                    [self.touchEventDelegate touchManager:self panningDidStartInView:hitView atPoint:touch.location];
                });
            }
        } break;
        case SDLPerformingTouchTypePanningTouch: {
            if (!self.enableSyncedPanning) {
                [self syncFrame];
            }
            self.lastStoredTouchLocation = touch.location;
        } break;
        case SDLPerformingTouchTypeNone: break;
    }

    self.previousTouch = touch;
}

/**
 *  Handles a END touch type notification sent by Core
 *
 *  @param touch    Gesture information
 */
- (void)sdl_handleTouchEnded:(SDLTouch *)touch {
    switch (self.performingTouchType) {
        case SDLPerformingTouchTypeMultiTouch: {
            [self sdl_setMultiTouchFingerTouchForTouch:touch];
            if (self.currentPinchGesture.isValid) {
                if ([self.touchEventDelegate respondsToSelector:@selector(touchManager:pinchDidEndInView:atCenterPoint:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIView *hitView = (self.hitTester != nil) ? [self.hitTester viewForPoint:self.currentPinchGesture.center] : nil;
                        [self.touchEventDelegate touchManager:self pinchDidEndInView:hitView atCenterPoint:self.currentPinchGesture.center];
                        self.currentPinchGesture = nil;
                    });
                } else {
                    self.currentPinchGesture = nil;
                }
            }
        } break;
        case SDLPerformingTouchTypePanningTouch: {
            if ([self.touchEventDelegate respondsToSelector:@selector(touchManager:panningDidEndInView:atPoint:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIView *hitView = (self.hitTester != nil) ? [self.hitTester viewForPoint:touch.location] : nil;
                    [self.touchEventDelegate touchManager:self panningDidEndInView:hitView atPoint:touch.location];
                });
            }
        } break;
        case SDLPerformingTouchTypeSingleTouch: {
            if (self.singleTapTimer == nil) {
                // Initial Tap
                self.singleTapTouch = touch;
                [self sdl_initializeSingleTapTimerAtPoint:self.singleTapTouch.location];
            } else {
                // Double Tap
                [self sdl_cancelSingleTapTimer];

                NSUInteger timeStampDelta = touch.timeStamp - self.singleTapTouch.timeStamp;
                CGFloat xDelta = fabs(touch.location.x - self.singleTapTouch.location.x);
                CGFloat yDelta = fabs(touch.location.y - self.singleTapTouch.location.y);

                if (timeStampDelta <= self.tapTimeThreshold * NSEC_PER_USEC && xDelta <= self.tapDistanceThreshold && yDelta <= self.tapDistanceThreshold) {
                    CGPoint centerPoint = CGPointCenterOfPoints(touch.location,
                                                                self.singleTapTouch.location);
                    if ([self.touchEventDelegate respondsToSelector:@selector(touchManager:didReceiveDoubleTapForView:atPoint:)]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIView *hitView = (self.hitTester != nil) ? [self.hitTester viewForPoint:centerPoint] : nil;
                            [self.touchEventDelegate touchManager:self didReceiveDoubleTapForView:hitView atPoint:centerPoint];
                        });
                    }
                }

                self.singleTapTouch = nil;
            }
        } break;
        case SDLPerformingTouchTypeNone: break;
    }

    self.firstTouch = nil;
    self.previousTouch = nil;
    _performingTouchType = SDLPerformingTouchTypeNone;
}

/**
 *  Handles a CANCEL touch event sent by CORE. A CANCEL touch event is sent when a gesture is interrupted during a video stream. This can happen when a system dialog box appears on the screen, such as when the user is alerted about an incoming phone call.
 *
 *  Pinch and pan gesture subscribers are notified if the gesture is canceled. Tap gestures are simply canceled without notification.
 *
 *  @param touch    Gesture information
 */
- (void)sdl_handleTouchCanceled:(SDLTouch *)touch {
    if (self.singleTapTimer != nil) {
        // Cancel any ongoing single tap timer
        [self sdl_cancelSingleTapTimer];
        self.singleTapTouch = nil;
    }

    switch (self.performingTouchType) {
        case SDLPerformingTouchTypeMultiTouch: {
            [self sdl_setMultiTouchFingerTouchForTouch:touch];
            if (self.currentPinchGesture.isValid) {
                if ([self.touchEventDelegate respondsToSelector:@selector(touchManager:pinchCanceledAtCenterPoint:)]) {
                    CGPoint center = self.currentPinchGesture.center;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.touchEventDelegate touchManager:self
                                   pinchCanceledAtCenterPoint:center];
                    });
                }
                self.currentPinchGesture = nil;
            }
        } break;
        case SDLPerformingTouchTypePanningTouch: {
            if ([self.touchEventDelegate respondsToSelector:@selector(touchManager:panningCanceledAtPoint:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.touchEventDelegate touchManager:self
                                   panningCanceledAtPoint:touch.location];
                });
            }
        } break;
        case SDLPerformingTouchTypeSingleTouch: // fallthrough
        case SDLPerformingTouchTypeNone: break;
    }

    self.firstTouch = nil;
    self.previousTouch = nil;
    _performingTouchType = SDLPerformingTouchTypeNone;
}

#pragma mark - Helpers

/**
 *  Saves the pinch touch gesture to the correct finger
 *
 *  @param touch   Gesture information
 */
- (void)sdl_setMultiTouchFingerTouchForTouch:(SDLTouch *)touch {
    switch (touch.identifier) {
        case SDLTouchIdentifierFirstFinger: {
            self.currentPinchGesture.firstTouch = touch;
        } break;
        case SDLTouchIdentifierSecondFinger: {
            self.currentPinchGesture.secondTouch = touch;
        } break;
    }
}

/**
 *  Creates a timer used to detect the type of tap gesture (single or double tap)
 *
 *  @param point  Screen coordinates of the tap gesture
 */
- (void)sdl_initializeSingleTapTimerAtPoint:(CGPoint)point {
    if (self.singleTapTimer != nil) {
        [self sdl_cancelSingleTapTimer];
    }

    __weak typeof(self) weakSelf = self;
    self.singleTapTimer = [[SDLTimer alloc] initWithDuration:self.tapTimeThreshold];
    self.singleTapTimer.elapsedBlock = ^{
        [weakSelf sdl_singleTapTimerCallbackWithPoint:point];
    };
    [self.singleTapTimer start];
}

/**
 The method that will be called when the timer fires that was started in `sdl_initializeSingleTapTimerAtPoint:`.

 This is called on the main thread based on `sdl_initializeSingleTapTimerAtPoint:`

 @param point The point where the tap occurred
 */
- (void)sdl_singleTapTimerCallbackWithPoint:(CGPoint)point {
    self.singleTapTouch = nil;
    [self sdl_cancelSingleTapTimer];
    if ([self.touchEventDelegate respondsToSelector:@selector(touchManager:didReceiveSingleTapForView:atPoint:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sdl_getSingleTapHitView:point hitViewHandler:^(UIView * _Nullable selectedView) {
                [self.touchEventDelegate touchManager:self didReceiveSingleTapForView:selectedView atPoint:point];
            }];
        });
    }
}

/**
 *  HAX to preserve the thread on which the delegate is notified for single taps; returning on the main thread would be a breaking change. All other touch gestures currently notify the delegate on the main thread. The single tap timer runs on a background thread so when a single tap is detected the hit test needs to be done on the main thread and then the result is returned on a background thread.
 *
 *  Checks if a single tap is inside a view. As the single tap timer is run on a background thread, the check is done on a main thread and then the result is returned on a background thread.
 *
 *  @param point Screen coordinates of the tap gesture
 *  @param hitViewHandler A handler that returns the view the point is inside of; nil if the point does not lie inside of a view
 */
- (void)sdl_getSingleTapHitView:(CGPoint)point hitViewHandler:(nullable void (^)(UIView * __nullable hitView))hitViewHandler {
    if (!self.hitTester) {
        if (!hitViewHandler) { return; }
        return hitViewHandler(nil);
    }

    UIView *hitView = [self.hitTester viewForPoint:point];
    if (!hitViewHandler) { return; }

    return hitViewHandler(hitView);
}

/**
 *  Cancels a tap gesture timer
 */
- (void)sdl_cancelSingleTapTimer {
    if (self.singleTapTimer == nil) {
        return;
    }

    [self.singleTapTimer cancel];
    self.singleTapTimer = nil;
}

@end

NS_ASSUME_NONNULL_END
