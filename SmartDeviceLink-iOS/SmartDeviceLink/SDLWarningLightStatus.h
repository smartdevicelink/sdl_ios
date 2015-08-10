//  SDLWarningLightStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the status of a cluster instrument warning light.
 *
 * @since SDL 2.0
 */
@interface SDLWarningLightStatus : SDLEnum {
}

/**
 * Convert String to SDLWarningLightStatus
 * @param value The value of the string to get an object for
 * @return SDLWarningLightStatus
 */
+ (SDLWarningLightStatus *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLWarningLightStatus
 * @return an array that store all possible SDLWarningLightStatus
 */
+ (NSArray *)values;

/**
 * @abstract Warninglight Off
 * @return SDLWarningLightStatus instance with value of *OFF*
 */
+ (SDLWarningLightStatus *)OFF;

/**
 * @abstract Warninglight On
 * @return SDLWarningLightStatus instance with value of *ON*
 */
+ (SDLWarningLightStatus *)ON;

/**
 * @abstract Warninglight is flashing
 * @return SDLWarningLightStatus instance with value of *FLASH*
 */
+ (SDLWarningLightStatus *)FLASH;

/**
 * @abstract Not used
 * @return SDLWarningLightStatus instance with value of *NOT_USED*
 */
+ (SDLWarningLightStatus *)NOT_USED;

@end
