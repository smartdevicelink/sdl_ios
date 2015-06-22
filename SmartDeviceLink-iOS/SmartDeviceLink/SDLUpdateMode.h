//  SDLUpdateMode.h
//


#import "SDLEnum.h"

/**
 * Specifies what function should be performed on the media clock/counter
 *
 * @since SDL 1.0
 */
@interface SDLUpdateMode : SDLEnum {
}

/**
 * Convert String to SDLUpdateMode
 * @param value The value of the string to get an object for
 * @return SDLUpdateMode
 */
+ (SDLUpdateMode *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLUpdateMode
 * @return an array that store all possible SDLUpdateMode
 */
+ (NSArray *)values;

/**
 * @abstract Starts the media clock timer counting upward, in increments of 1 second.
 * @return SDLUpdateMode with value of *COUNTUP*
 */
+ (SDLUpdateMode *)COUNTUP;

/**
 * @abstract Starts the media clock timer counting downward, in increments of 1 second.
 * @return SDLUpdateMode with value of *COUNTDOWN*
 */
+ (SDLUpdateMode *)COUNTDOWN;

/**
 * @abstract Pauses the media clock timer.
 * @return SDLUpdateMode with value of *PAUSE*
 */
+ (SDLUpdateMode *)PAUSE;

/**
 * @abstract Resumes the media clock timer. The timer resumes counting in whatever mode was in effect before pausing (i.e. COUNTUP or COUNTDOWN).
 * @return SDLUpdateMode with value of *RESUME*
 */
+ (SDLUpdateMode *)RESUME;

/**
 * @abstract Clear the media clock timer.
 */
+ (SDLUpdateMode *)CLEAR;

@end
