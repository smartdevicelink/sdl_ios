//  SDLKeyboardEvent.h
//


#import "SDLEnum.h"

/** Enumeration listing possible keyboard events.
 *
 * @since SmartDeviceLink 3.0
 *
 */
@interface SDLKeyboardEvent : SDLEnum {
}

+ (SDLKeyboardEvent *)valueOf:(NSString *)value;
+ (NSArray *)values;

/** The use has pressed the keyboard key (applies to both SINGLE_KEYPRESS and RESEND_CURRENT_ENTRY modes).
 *
 */
+ (SDLKeyboardEvent *)KEYPRESS;

/** The User has finished entering text from the keyboard and submitted the entry.
 *
 */

+ (SDLKeyboardEvent *)ENTRY_SUBMITTED;

/** The User has pressed the HMI-defined "Cancel" button.
 *
 */
+ (SDLKeyboardEvent *)ENTRY_CANCELLED;


/** The User has not finished entering text and the keyboard is aborted with the event of higher priority.
 *
 */
+ (SDLKeyboardEvent *)ENTRY_ABORTED;

/**
 * @since SDL 4.0
 */
+ (SDLKeyboardEvent *)ENTRY_VOICE;

@end
