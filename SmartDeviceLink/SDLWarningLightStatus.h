//  SDLWarningLightStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the status of a cluster instrument warning light.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLWarningLightStatus SDL_SWIFT_ENUM;

/**
 * @abstract Warninglight Off
 */
extern SDLWarningLightStatus const SDLWarningLightStatusOff;

/**
 * @abstract Warninglight On
 */
extern SDLWarningLightStatus const SDLWarningLightStatusOn;

/**
 * @abstract Warninglight is flashing
 */
extern SDLWarningLightStatus const SDLWarningLightStatusFlash;

/**
 * @abstract Not used
 */
extern SDLWarningLightStatus const SDLWarningLightStatusNotUsed;
