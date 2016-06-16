//
//  SDLPinchGesture.c
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#include "SDLPinchGesture.h"
#import <limits.h>

SDLPinchGesture SDLPinchGestureMake(SDLTouch firstTouch, SDLTouch secondTouch) {
    SDLPinchGesture pinchGesture;
    pinchGesture.firstTouch = firstTouch;
    pinchGesture.secondTouch = secondTouch;
    pinchGesture.center = CGPointCenterOfPoints(firstTouch.location, secondTouch.location);
    pinchGesture.distance = CGPointDistanceBetweenPoints(firstTouch.location, secondTouch.location);
    return pinchGesture;
}

const SDLPinchGesture SDLPinchGestureZero = {{ULONG_MAX, {0, 0}, ULONG_MAX}, {ULONG_MAX, {0, 0}, ULONG_MAX}, 0, {0, 0}};

SDLPinchGesture SDLPinchGestureUpdateFromTouch(SDLPinchGesture pinch, SDLTouch touch) {
    switch (touch.identifier) {
        case SDLTouchIdentifierFirstFinger:
            return SDLPinchGestureMake(touch, pinch.secondTouch);
            break;
        case SDLTouchIdentifierSecondFinger:
            return SDLPinchGestureMake(pinch.firstTouch, touch);
            break;
        default:
            return SDLPinchGestureZero;
            break;
    }
}

bool SDLPinchGestureIsValid(SDLPinchGesture pinch) {
    return SDLTouchIsValid(pinch.firstTouch) && SDLTouchIsValid(pinch.secondTouch);
}