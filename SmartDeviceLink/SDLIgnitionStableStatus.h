//  SDLIgnitionStableStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the ignition switch stability.
 *
 * @since SDL 2.0
 */
@interface SDLIgnitionStableStatus : SDLEnum {
}

/**
 * @abstract return SDLIgnitionStableStatus
 * @param value The value of the string to get an object for
 * @return SDLIgnitionStableStatus
 */
+ (SDLIgnitionStableStatus *)valueOf:(NSString *)value;

/**
 * @abstract store all possible SDLIgnitionStableStatus values
 * @return an array with all possible SDLIgnitionStableStatus values inside
 */
+ (NSArray *)values;

/**
 * @abstract The current ignition switch status is considered not to be stable.
 * @return the Ignition Stable Status with value of *IGNITION_SWITCH_NOT_STABLE*
 */
+ (SDLIgnitionStableStatus *)IGNITION_SWITCH_NOT_STABLE;

/**
 * @abstract The current ignition switch status is considered to be stable.
 * @return the Ignition Stable Status with value of *IGNITION_SWITCH_STABLE*
 */
+ (SDLIgnitionStableStatus *)IGNITION_SWITCH_STABLE;

+ (SDLIgnitionStableStatus *)MISSING_FROM_TRANSMITTER;

@end
