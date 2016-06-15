//
//  SDLTouch.c
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#include "SDLTouch.h"

SDLTouch const SDLTouchZero = {0, {0, 0}, 0};

SDLTouch SDLTouchMake(unsigned long identifier, float x, float y, unsigned long timeStamp) {
    SDLTouch touch;
    touch.identifier = identifier;
    touch.location = CGPointMake(x, y);
    touch.timeStamp = timeStamp;
    return touch;
}

bool SDLTouchEqualToTouch(SDLTouch touch1, SDLTouch touch2) {
    bool isEqual = (touch1.identifier == touch2.identifier);
    isEqual = (isEqual && CGPointEqualToPoint(touch1.location, touch2.location));
    isEqual = (isEqual && touch1.timeStamp == touch2.timeStamp);
    return isEqual;
}

bool SDLTouchIsValid(SDLTouch touch) {
    return SDLTouchEqualToTouch(touch, SDLTouchZero) ? false : true;
}

bool SDLTouchIsFirstFinger(SDLTouch touch) {
    return touch.identifier == SDLTouchIdentifierFirstFinger ? true : false;
}

bool SDLTouchIsSecondFinger(SDLTouch touch) {
    return touch.identifier == SDLTouchIdentifierSecondFinger ? true : false;
}