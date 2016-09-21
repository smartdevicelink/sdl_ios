//  SDLDeviceLevelStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the reported battery status of the connected device, if reported.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLDeviceLevelStatus NS_EXTENSIBLE_STRING_ENUM;

/**
 * @abstract Device battery level is zero bars
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusZeroLevelBars;

/**
 * @abstract Device battery level is one bar
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusOneLevelBars;

/**
 * @abstract Device battery level is two bars
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusTwoLevelBars;

/**
 * @abstract Device battery level is three bars
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusThreeLevelBars;

/**
 * @abstract Device battery level is four bars
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusFourLevelBars;

/**
 * @abstract Device battery level is unknown
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusNotProvided;
