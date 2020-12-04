//  SDLIgnitionStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the status of ignition. Used in BodyInformation.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLIgnitionStatus NS_TYPED_ENUM;

/**
 * Ignition status currently unknown
 */
extern SDLIgnitionStatus const SDLIgnitionStatusUnknown;

/**
 * Ignition is off
 */
extern SDLIgnitionStatus const SDLIgnitionStatusOff;

/**
 * Ignition is in mode accessory
 */
extern SDLIgnitionStatus const SDLIgnitionStatusAccessory;

/**
 * Ignition is in mode run
 */
extern SDLIgnitionStatus const SDLIgnitionStatusRun;

/**
 * Ignition is in mode start
 */
extern SDLIgnitionStatus const SDLIgnitionStatusStart;

/**
 * Signal is invalid
 */
extern SDLIgnitionStatus const SDLIgnitionStatusInvalid;
