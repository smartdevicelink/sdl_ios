//  SDLButtonEventMode.h
//


#import "SDLEnum.h"

/**
 * Indicates whether the button was depressed or released. A BUTTONUP event will always be preceded by a BUTTONDOWN event.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLButtonEventMode SDL_SWIFT_ENUM;

/**
 * @abstract The button was released
 */
extern SDLButtonEventMode const SDLButtonEventModeButtonUp;

/**
 * @abstract The button was depressed
 */
extern SDLButtonEventMode const SDLButtonEventModeButtonDown;
