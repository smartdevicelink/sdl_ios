//  SDLKeypressMode.h
//


#import "SDLEnum.h"

/** Enumeration listing possible keyboard events.
 * <p>
 * <b>Note:</b> Depending on keypressMode value (from keyboardProperties structure of UI.SetGlobalProperties),<br>HMI must send the onKeyboardInput notification with the following data:<br>
 SINGLE_KEYPRESS,QUEUE_KEYPRESSES,RESEND_CURRENT_ENTRY.
 * @since SmartDeviceLink 3.0
 *
 */
@interface SDLKeypressMode : SDLEnum {
}

+ (SDLKeypressMode *)valueOf:(NSString *)value;
+ (NSArray *)values;

/** SINGLE_KEYPRESS:<br>Each and every User`s keypress must be reported (new notification for every newly entered single symbol).
 *
 */
+ (SDLKeypressMode *)SINGLE_KEYPRESS;

/** QUEUE_KEYPRESSES:<br>The whole entry is reported only after the User submits it (by ‘Search’ button click displayed on touchscreen keyboard)
 *
 */
+ (SDLKeypressMode *)QUEUE_KEYPRESSES;

/** RESEND_CURRENT_ENTRY:<br>The whole entry must be reported each and every time the User makes a new keypress<br> (new notification with all previously entered symbols and a newly entered one appended).
 *
 */
+ (SDLKeypressMode *)RESEND_CURRENT_ENTRY;

@end
