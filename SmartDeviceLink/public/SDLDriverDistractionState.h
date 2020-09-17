//  SDLDriverDistractionState.h
//


#import "SDLEnum.h"

/**
 * Enumeration that describes possible states of driver distraction. Used in OnDriverDistraction.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLDriverDistractionState NS_TYPED_ENUM;

/**
 * Driver distraction rules are in effect.
 */
extern SDLDriverDistractionState const SDLDriverDistractionStateOn;

/**
 * Driver distraction rules are NOT in effect.
 */
extern SDLDriverDistractionState const SDLDriverDistractionStateOff;

