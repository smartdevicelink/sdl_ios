//  SDLDeviceLevelStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the reported battery status of the connected device, if reported.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLDeviceLevelStatus SDL_SWIFT_ENUM;

/**
 * @abstract Device battery level is zero bars
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusZeroBars;

/**
 * @abstract Device battery level is one bar
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusOneBar;

/**
 * @abstract Device battery level is two bars
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusTwoBars;

/**
 * @abstract Device battery level is three bars
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusThreeBars;

/**
 * @abstract Device battery level is four bars
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusFourBars;

/**
 * @abstract Device battery level is unknown
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusNotProvided;
