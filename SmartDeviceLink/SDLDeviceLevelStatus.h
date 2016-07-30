//  SDLDeviceLevelStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the reported battery status of the connected device, if reported.
 *
 * @since SDL 2.0
 */
@interface SDLDeviceLevelStatus : SDLEnum {
}

/**
 * Convert String to DeviceLevelStatus
 * @param value String
 * @return DeviceLevelStatus
 */
+ (SDLDeviceLevelStatus *)valueOf:(NSString *)value;

/**
 @abstract Store the enumeration of all possible SDLDeviceLevelStatus
 @return an array that store all possible SDLDeviceLevelStatus
 */
+ (NSArray *)values;

/**
 * @abstract Device battery level is zero bars
 * @return a SDLDeviceLevelStatus with value of *ZERO_LEVEL_BARS*
 */
+ (SDLDeviceLevelStatus *)ZERO_LEVEL_BARS;

/**
 * @abstract Device battery level is one bar
 * @return a SDLDeviceLevelStatus with value of *ONE_LEVEL_BARS*
 */
+ (SDLDeviceLevelStatus *)ONE_LEVEL_BARS;

/**
 * @abstract Device battery level is two bars
 * @return a SDLDeviceLevelStatus with value of *TWO_LEVEL_BARS*
 */
+ (SDLDeviceLevelStatus *)TWO_LEVEL_BARS;

/**
 * @abstract Device battery level is three bars
 * @return a SDLDeviceLevelStatus with value of *THREE_LEVEL_BARS*
 */
+ (SDLDeviceLevelStatus *)THREE_LEVEL_BARS;

/**
 * @abstract Device battery level is four bars
 * @return a SDLDeviceLevelStatus with value of *FOUR_LEVEL_BARS*
 */
+ (SDLDeviceLevelStatus *)FOUR_LEVEL_BARS;

/**
 * @abstract Device battery level is unknown
 * @return a SDLDeviceLevelStatus with value of *NOT_PROVIDED*
 */
+ (SDLDeviceLevelStatus *)NOT_PROVIDED;

@end
