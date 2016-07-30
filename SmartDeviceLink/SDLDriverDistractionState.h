//  SDLDriverDistractionState.h
//


#import "SDLEnum.h"

/**
 * Enumeration that describes possible states of driver distraction.
 *
 * @since SDL 1.0
 */
@interface SDLDriverDistractionState : SDLEnum {
}

/**
 * Convert String to SDLDisplayType
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLDisplayType
 */
+ (SDLDriverDistractionState *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLDriverDistractionState
 *
 * @return an array that store all possible SDLDriverDistractionState
 */
+ (NSArray *)values;

/**
 * @abstract Driver distraction rules are in effect.
 *
 * @return a SDLDriverDistractionState with value of *DD_ON*
 */
+ (SDLDriverDistractionState *)DD_ON;

/**
 * @abstract Driver distraction rules are NOT in effect.
 *
 * @return a SDLDriverDistractionState with value of *DD_OFF*
 */
+ (SDLDriverDistractionState *)DD_OFF;

@end
