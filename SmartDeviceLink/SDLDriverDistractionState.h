//  SDLDriverDistractionState.h
//


#import "SDLEnum.h"

/**
 * Enumeration that describes possible states of driver distraction.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLDriverDistractionState SDL_SWIFT_ENUM;

/**
 * @abstract Driver distraction rules are in effect.
 */
extern SDLDriverDistractionState const SDLDriverDistractionStateOn;

/**
 * @abstract Driver distraction rules are NOT in effect.
 */
extern SDLDriverDistractionState const SDLDriverDistractionStateOff;

