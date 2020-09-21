//  SDLTouchType.h
//


#import "SDLEnum.h"

/**
 The type of a touch in a projection application. Used in OnTouchEvent.
 */
typedef SDLEnum SDLTouchType NS_TYPED_ENUM;

/**
 The touch is the beginning of a finger pressed on the display.
 */
extern SDLTouchType const SDLTouchTypeBegin;

/**
 The touch is the movement of a finger pressed on the display.
 */
extern SDLTouchType const SDLTouchTypeMove;

/**
 The touch is the ending of a finger pressed on the display.
 */
extern SDLTouchType const SDLTouchTypeEnd;

/**
 The touch is the cancellation of a finger pressed on the display.
 */
extern SDLTouchType const SDLTouchTypeCancel;
