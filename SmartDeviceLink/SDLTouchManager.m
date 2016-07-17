//
//  SDLTouchManager.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLTouchManager.h"

#import "dispatch_timer.h"
#import "CGPoint_Util.h"

#import "SDLOnTouchEvent.h"
#import "SDLPinchGesture.h"
#import "SDLProxyListener.h"
#import "SDLTouch.h"
#import "SDLTouchCoord.h"
#import "SDLTouchEvent.h"
#import "SDLTouchType.h"

typedef NS_ENUM(NSUInteger, SDLPerformingTouchType) {
    SDLPerformingTouchTypeNone,
    SDLPerformingTouchTypeSingleTouch,
    SDLPerformingTouchTypeMultiTouch,
    SDLPerformingTouchTypePanningTouch
};

static NSUInteger const MaximumNumberOfTouches = 2;

@interface SDLTouchManager () <SDLProxyListener>

@property SDLTouch* previousTouch;

/*
 * Only used for caching previous single taps for double tap detection
 */
@property SDLTouch* singleTapTouch;

@property CGFloat previousPinchDistance;

@property SDLPinchGesture* currentPinchGesture;

@property dispatch_source_t singleTapTimer;

@property SDLPerformingTouchType performingTouchType;

@end

@implementation SDLTouchManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _movementTimeThreshold = 0.5f;
    _tapTimeThreshold = 0.4f;
    _tapDistanceThreshold = 50.0f;
    _touchEnabled = YES;
    
    return self;
}

#pragma mark - SDLProxyListener Delegate
- (void)onProxyOpened { }
- (void)onProxyClosed { }
- (void)onOnHMIStatus:(SDLOnHMIStatus *)notification { }
- (void)onOnDriverDistraction:(SDLOnDriverDistraction *)notification { }

- (void)onOnTouchEvent:(SDLOnTouchEvent *)notification {
    if (!self.isTouchEnabled) {
        return;
    }
    
    SDLTouchEvent* touchEvent = notification.event.firstObject;
    
    SDLTouch* touch = [[SDLTouch alloc] initWithTouchEvent:touchEvent];

    if (touch.identifier > MaximumNumberOfTouches) {
        return;
    }
    
    if ([notification.type isEqualToEnum:SDLTouchType.BEGIN]) {
        [self sdl_handleBeginTouch:touch];
    } else if ([notification.type isEqualToEnum:SDLTouchType.MOVE]) {
        [self sdl_handleMovedTouch:touch];
    } else if ([notification.type isEqualToEnum:SDLTouchType.END]) {
        [self sdl_handleEndTouch:touch];
    }
}

#pragma mark - Private
- (void)sdl_handleBeginTouch:(SDLTouch*)touch {
    if (!touch.isFirstFinger
        && !self.isTouchEnabled) {
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
            if ([self.touchEventListener respondsToSelector:@selector(touchManager:pinchDidStartAtCenterPoint:)]) {
                [self.touchEventListener touchManager:self
                           pinchDidStartAtCenterPoint:self.currentPinchGesture.center];
            }
            break;
    }
}

- (void)sdl_handleMovedTouch:(SDLTouch*)touch {
    if ((touch.timeStamp - self.previousTouch.timeStamp) <= (self.movementTimeThreshold * NSEC_PER_USEC)
        || !self.isTouchEnabled) {
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
            
            
            if ([self.touchEventListener respondsToSelector:@selector(touchManager:didReceivePinchAtCenterPoint:withScale:)]) {
                CGFloat scale = self.currentPinchGesture.distance / self.previousPinchDistance;
                [self.touchEventListener touchManager:self
                         didReceivePinchAtCenterPoint:self.currentPinchGesture.center
                                            withScale:scale];
            }
            
            self.previousPinchDistance = self.currentPinchGesture.distance;
            break;
        case SDLPerformingTouchTypeSingleTouch:
            _performingTouchType = SDLPerformingTouchTypePanningTouch;
            if ([self.touchEventListener respondsToSelector:@selector(touchManager:panningDidStartAtPoint:)]) {
                [self.touchEventListener touchManager:self
                               panningDidStartAtPoint:touch.location];
            }
            break;
        case SDLPerformingTouchTypePanningTouch:
            if ([self.touchEventListener respondsToSelector:@selector(touchManager:didReceivePanningFromPoint:toPoint:)]) {
                [self.touchEventListener touchManager:self
                           didReceivePanningFromPoint:self.previousTouch.location toPoint:touch.location];
            }
            break;
        case SDLPerformingTouchTypeNone:
            break;
    }
    
    self.previousTouch = touch;
}

- (void)sdl_handleEndTouch:(SDLTouch*)touch {
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
                if ([self.touchEventListener respondsToSelector:@selector(touchManager:pinchDidEndAtCenterPoint:)]) {
                    [self.touchEventListener touchManager:self
                                    pinchDidEndAtCenterPoint:self.currentPinchGesture.center];
                }
                self.currentPinchGesture = nil;
            }
            break;
        case SDLPerformingTouchTypePanningTouch:
            if ([self.touchEventListener respondsToSelector:@selector(touchManager:panningDidEndAtPoint:)]) {
                [self.touchEventListener touchManager:self
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
                
                if (timeStampDelta <= self.tapTimeThreshold * NSEC_PER_USEC
                    && xDelta <= self.tapDistanceThreshold
                    && yDelta <= self.tapDistanceThreshold) {
                    CGPoint averagePoint = CGPointAverageOfPoints(touch.location,
                                                                  self.singleTapTouch.location);
                    if ([self.touchEventListener respondsToSelector:@selector(touchManager:didReceiveDoubleTapAtPoint:)]) {
                        [self.touchEventListener touchManager:self
                                   didReceiveDoubleTapAtPoint:averagePoint];
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
        if ([strongSelf.touchEventListener respondsToSelector:@selector(touchManager:didReceiveSingleTapAtPoint:)]) {
            [strongSelf.touchEventListener touchManager:strongSelf
                             didReceiveSingleTapAtPoint:point];
        }
    });
}

- (void)sdl_cancelSingleTapTimer {
    dispatch_stop_timer(self.singleTapTimer);
    self.singleTapTimer = NULL;
}

@end
