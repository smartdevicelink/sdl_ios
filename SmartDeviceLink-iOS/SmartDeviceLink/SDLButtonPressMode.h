//  SDLButtonPressMode.h
//



#import "SDLEnum.h"

/**
* Indicates whether this is a LONG or SHORT button press
* <p>
*
* This enum is avaliable since <font color=red><b>SmartDeviceLink 1.0</b></font>
*/
@interface SDLButtonPressMode : SDLEnum {}

/**
 * @abstract Convert String to SDLButtonPressMode
 * @param value NSString
 * @result SDLButtonPressMode
 */
+(SDLButtonPressMode*) valueOf:(NSString*) value;

/*!
 @abstract Store the enumeration of all possible SDLButtonPressMode
 @result return an array that store all possible SDLButtonPressMode
 */
+(NSMutableArray*) values;

/**
 * @abstract The button has been depressed for 2 seconds. The button may remain
 * depressed after receiving this event
 * @result return a SDLButtonPressMode with the value of <font color=gray><i>LONG</i></font>
 */
+(SDLButtonPressMode*) LONG;

/**
 * @abstract The button was released before the 2-second long-press interval had
 * elapsed
 * @result return a SDLButtonPressMode with the value of <font color=gray><i>SHORT</i></font>
 */
+(SDLButtonPressMode*) SHORT;

@end
