//
//  SDLPinchGesture.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#ifndef SDLPinchGesture_h
#define SDLPinchGesture_h

#include <stdio.h>

#include "SDLTouch.h"
#include "CGPoint_Util.h"

typedef struct {
    SDLTouch firstTouch;
    SDLTouch secondTouch;
    CGFloat distance;
    CGPoint center;
} SDLPinchGesture;

extern const SDLPinchGesture SDLPinchGestureZero;

SDLPinchGesture SDLPinchGestureMake(SDLTouch firstTouch, SDLTouch secondTouch);

SDLPinchGesture SDLPinchGestureUpdateFromTouch(SDLPinchGesture pinch, SDLTouch touch);

bool SDLPinchGestureIsValid(SDLPinchGesture pinch);

#endif /* SDLPinchGesture_h */
