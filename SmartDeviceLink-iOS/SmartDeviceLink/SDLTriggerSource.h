//  SDLTriggerSource.h
//


#import "SDLEnum.h"

/**
 * Indicates whether choice/command was selected via VR or via a menu selection (using SEEKRIGHT/SEEKLEFT, TUNEUP, TUNEDOWN, OK buttons)
 *
 * @since SDL 1.0
 */
@interface SDLTriggerSource : SDLEnum {
}

/**
 * Convert String to SDLTriggerSource
 * @param value The value of the string to get an object for
 * @return SDLTriggerSource
 */
+ (SDLTriggerSource *)valueOf:(NSString *)value;

/**
 @abstract Store the enumeration of all possible SDLTriggerSource
 @return an array that store all possible SDLTriggerSource
 */
+ (NSArray *)values;

/**
 * @abstract Selection made via menu
 * @return SDLTriggerSource with value of *MENU*
 */
+ (SDLTriggerSource *)MENU;

/**
 * @abstract Selection made via Voice session
 * @return SDLTriggerSource with value of *VR*
 */
+ (SDLTriggerSource *)VR;

/**
 * @abstract Selection made via Keyboard
 * @return SDLTriggerSource with value of *KEYBOARD*
 */
+ (SDLTriggerSource *)KEYBOARD;

@end
