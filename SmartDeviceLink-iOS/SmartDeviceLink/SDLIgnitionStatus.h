//  SDLIgnitionStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the status of ignition..
 *
 * @since SDL 2.0
 */
@interface SDLIgnitionStatus : SDLEnum {
}

/**
 * @abstract return SDLIgnitionStatus
 * @param value The value of the string to get an object for
 * @return SDLIgnitionStatus object
 */
+ (SDLIgnitionStatus *)valueOf:(NSString *)value;

/**
 * @abstract store all possible SDLIgnitionStatus values
 * @return an array with all possible SDLIgnitionStatus values inside
 */
+ (NSArray *)values;

/**
 * @abstract Ignition status currently unknown
 * @return Ignition Status with value of *UNKNOWN*
 */
+ (SDLIgnitionStatus *)UNKNOWN;

/**
 * @abstract Ignition is off
 * @return Ignition Status with value of *OFF*
 */
+ (SDLIgnitionStatus *)OFF;

/**
 * @abstract Ignition is in mode accessory
 * @return Ignition Status with value of *ACCESSORY*
 */
+ (SDLIgnitionStatus *)ACCESSORY;

/**
 * @abstract Ignition is in mode run
 * @return Ignition Status with value of *RUN*
 */
+ (SDLIgnitionStatus *)RUN;

/**
 * @abstract Ignition is in mode start
 * @return Ignition Status with value of *START*
 */
+ (SDLIgnitionStatus *)START;

/**
 * @abstract Signal is invalid
 * @return Ignition Status with value of *INVALID*
 */
+ (SDLIgnitionStatus *)INVALID;

@end
