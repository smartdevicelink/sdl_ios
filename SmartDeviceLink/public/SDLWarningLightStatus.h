//  SDLWarningLightStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the status of a cluster instrument warning light. Used in TireStatus
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLWarningLightStatus NS_TYPED_ENUM;

/**
 * The warning light is off
 */
extern SDLWarningLightStatus const SDLWarningLightStatusOff;

/**
 * The warning light is off
 */
extern SDLWarningLightStatus const SDLWarningLightStatusOn;

/**
 * The warning light is flashing
 */
extern SDLWarningLightStatus const SDLWarningLightStatusFlash;

/**
 * The warning light is unused
 */
extern SDLWarningLightStatus const SDLWarningLightStatusNotUsed;
