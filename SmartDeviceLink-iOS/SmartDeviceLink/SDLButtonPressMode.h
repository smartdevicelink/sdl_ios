//  SDLButtonPressMode.h
//


#import "SDLEnum.h"

/**
 * Indicates whether this is a LONG or SHORT button press
 *
 * @since SDL 1.0
 */
@interface SDLButtonPressMode : SDLEnum {
}

/**
 * @abstract Convert String to SDLButtonPressMode
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLButtonPressMode
 */
+ (SDLButtonPressMode *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLButtonPressMode
 *
 * @return an array that store all possible SDLButtonPressMode
 */
+ (NSArray *)values;

/**
 * @abstract A button was released, after it was pressed for a long time. Actual timing is defined by the head unit and may vary.
 *
 * @return a SDLButtonPressMode with the value of *LONG*
 */
+ (SDLButtonPressMode *)LONG;

/**
 * @abstract A button was released, after it was pressed for a short time. Actual timing is defined by the head unit and may vary.
 *
 * @return a SDLButtonPressMode with the value of *SHORT*
 */
+ (SDLButtonPressMode *)SHORT;

@end
