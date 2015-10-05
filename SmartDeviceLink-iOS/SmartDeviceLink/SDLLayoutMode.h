//  SDLLayoutMode.h
//


#import "SDLEnum.h"

/** 
 * For touchscreen interactions, the mode of how the choices are presented.
 *
 * @since SDL 3.0
 */
@interface SDLLayoutMode : SDLEnum {
}

+ (SDLLayoutMode *)valueOf:(NSString *)value;
+ (NSArray *)values;

/** 
 * This mode causes the interaction to display the previous set of choices as icons.
 */
+ (SDLLayoutMode *)ICON_ONLY;

/** 
 * This mode causes the interaction to display the previous set of choices as icons along with a search field in the HMI.
 */
+ (SDLLayoutMode *)ICON_WITH_SEARCH;

/** 
 * This mode causes the interaction to display the previous set of choices as a list.
 */
+ (SDLLayoutMode *)LIST_ONLY;

/** 
 * This mode causes the interaction to display the previous set of choices as a list along with a search field in the HMI.
 */
+ (SDLLayoutMode *)LIST_WITH_SEARCH;

/** 
 * This mode causes the interaction to immediately display a keyboard entry through the HMI.
 */
+ (SDLLayoutMode *)KEYBOARD;

@end
