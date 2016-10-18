//  SDLIgnitionStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the status of ignition..
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLIgnitionStatus SDL_SWIFT_ENUM;

/**
 * @abstract Ignition status currently unknown
 */
extern SDLIgnitionStatus const SDLIgnitionStatusUnknown;

/**
 * @abstract Ignition is off
 */
extern SDLIgnitionStatus const SDLIgnitionStatusOff;

/**
 * @abstract Ignition is in mode accessory
 */
extern SDLIgnitionStatus const SDLIgnitionStatusAccessory;

/**
 * @abstract Ignition is in mode run
 */
extern SDLIgnitionStatus const SDLIgnitionStatusRun;

/**
 * @abstract Ignition is in mode start
 */
extern SDLIgnitionStatus const SDLIgnitionStatusStart;

/**
 * @abstract Signal is invalid
 */
extern SDLIgnitionStatus const SDLIgnitionStatusInvalid;
