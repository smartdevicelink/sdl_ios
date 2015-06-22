//  SDLKeyboardLayout.h
//


#import "SDLEnum.h"

/** Enumeration listing possible keyboard layouts
 *
 *<b>Since</b> SmartDeviceLink 3.0
 *
 */
@interface SDLKeyboardLayout : SDLEnum {
}

+ (SDLKeyboardLayout *)valueOf:(NSString *)value;
+ (NSArray *)values;
/** QWERTY layout (the name comes from the first six keys<br> appearing on the top left letter row of the keyboard and read from left to right)
 *
 */
+ (SDLKeyboardLayout *)QWERTY;

/** QWERTZ layout (the name comes from the first six keys<br> appearing on the top left letter row of the keyboard and read from left to right)
 *
 */
+ (SDLKeyboardLayout *)QWERTZ;

/** AZERTY layout (the name comes from the first six keys<br> appearing on the top left letter row of the keyboard and read from left to right)
 *
 */

+ (SDLKeyboardLayout *)AZERTY;

@end
