//  SDLKeypressMode.h
//


#import "SDLEnum.h"

/**
 Enumeration listing possible keyboard events.

 Note: Depending on keypressMode value (from keyboardProperties structure of UI.SetGlobalProperties), HMI must send the onKeyboardInput notification with the following data:

 SINGLE_KEYPRESS,QUEUE_KEYPRESSES,RESEND_CURRENT_ENTRY.

 @since SmartDeviceLink 3.0
 */
typedef SDLEnum SDLKeypressMode NS_TYPED_ENUM;

/**
 SINGLE_KEYPRESS:<br>Each and every User`s keypress must be reported (new notification for every newly entered single symbol).
 */
extern SDLKeypressMode const SDLKeypressModeSingleKeypress;

/**
 QUEUE_KEYPRESSES:<br>The whole entry is reported only after the User submits it (by ‘Search’ button click displayed on touchscreen keyboard)
 */
extern SDLKeypressMode const SDLKeypressModeQueueKeypresses;

/**
 RESEND_CURRENT_ENTRY:<br>The whole entry must be reported each and every time the User makes a new keypress<br> (new notification with all previously entered symbols and a newly entered one appended).
 */
extern SDLKeypressMode const SDLKeypressModeResendCurrentEntry;
