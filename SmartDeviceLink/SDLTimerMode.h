//  SDLTimerMode.h
//


#import "SDLEnum.h"

/**
 The direction of a timer. Used in nothing.
 */
typedef SDLEnum SDLTimerMode SDL_SWIFT_ENUM;

/**
 The timer should count up.
 */
extern SDLTimerMode const SDLTimerModeUp;

/**
 The timer should count down.
 */
extern SDLTimerMode const SDLTimerModeDown;

/**
 The timer should not count.
 */
extern SDLTimerMode const SDLTimerModeNone;
