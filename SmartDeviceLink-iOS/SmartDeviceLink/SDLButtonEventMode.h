//  SDLButtonEventMode.h
//


#import "SDLEnum.h"

/**
 * Indicates whether the button was depressed or released. A BUTTONUP event will always be preceded by a BUTTONDOWN event.
 *
 * @since SDL 1.0
 */
@interface SDLButtonEventMode : SDLEnum {
}

/**
 * @abstract Convert String to SDLButtonEventMode
 * @param value The value of the string to get an object for
 * @return SDLButtonEventMode (BUTTONUP / BUTTONDOWN)
 */
+ (SDLButtonEventMode *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLButtonEventMode
 * @return an array that store all possible SDLButtonEventMode
 */
+ (NSArray *)values;

/**
 * @abstract The button was released
 * @return a SDLButtonEventMode with value of *BUTTONUP*
 */
+ (SDLButtonEventMode *)BUTTONUP;

/**
 * @abstract The button was depressed
 * @return a SDLButtonEventMode with value of *BUTTONDOWN*
 */
+ (SDLButtonEventMode *)BUTTONDOWN;

@end
