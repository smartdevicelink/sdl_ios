//
//  SDLTouch.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#ifndef SDLTouch_h
#define SDLTouch_h

#include <stdio.h>

#include <CoreGraphics/CGGeometry.h>

typedef struct SDLTouch {
    unsigned long identifier;
    CGPoint location;
    unsigned long timeStamp;
} SDLTouch;

typedef enum {
    SDLTouchIdentifierFirstFinger = 0,
    SDLTouchIdentifierSecondFinger = 1
} SDLTouchIdentifier;

extern const SDLTouch SDLTouchZero;

SDLTouch SDLTouchMake(unsigned long identifier, float x, float y, unsigned long timeStamp);

bool SDLTouchEqualToTouch(SDLTouch touch1, SDLTouch touch2);

// Checks if SDLTouch is equal to SDLTouchZero.
bool SDLTouchIsValid(SDLTouch touch);

bool SDLTouchIsFirstFinger(SDLTouch touch);
bool SDLTouchIsSecondFinger(SDLTouch touch);

#endif /* SDLTouch_h */