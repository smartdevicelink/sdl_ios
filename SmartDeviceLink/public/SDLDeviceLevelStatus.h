//  SDLDeviceLevelStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the reported battery status of the connected device, if reported. Used in DeviceStatus.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLDeviceLevelStatus NS_TYPED_ENUM;

/**
 * Device battery level is zero bars
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusZeroBars;

/**
 * Device battery level is one bar
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusOneBar;

/**
 * Device battery level is two bars
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusTwoBars;

/**
 * Device battery level is three bars
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusThreeBars;

/**
 * Device battery level is four bars
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusFourBars;

/**
 * Device battery level is unknown
 */
extern SDLDeviceLevelStatus const SDLDeviceLevelStatusNotProvided;
