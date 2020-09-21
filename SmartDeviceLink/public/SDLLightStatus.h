//  SDLLightStatus.h
//

#import "SDLEnum.h"

/**
 * Reflects the status of Light.
 *
 */
typedef SDLEnum SDLLightStatus NS_TYPED_ENUM;

/**
 * @abstract Light status currently on.
 */
extern SDLLightStatus const SDLLightStatusOn;

/**
 * @abstract Light status currently Off.
 */
extern SDLLightStatus const SDLLightStatusOFF;

/**
 * @abstract Light status currently RAMP_UP.
 */
extern SDLLightStatus const SDLLightStatusRampUp;

/**
 * @abstract Light status currently RAMP_DOWN.
 */
extern SDLLightStatus const SDLLightStatusRampDown;

/**
 * @abstract Light status currently UNKNOWN.
 */
extern SDLLightStatus const SDLLightStatusUnknown;

/**
 * @abstract Light status currently INVALID.
 */
extern SDLLightStatus const SDLLightStatusInvalid;
