//  SDLKeyboardEvent.h
//


#import "SDLEnum.h"

/**
 Enumeration listing possible keyboard events. Used in OnKeyboardInput.

 @since SmartDeviceLink 3.0
 */
typedef SDLEnum SDLKeyboardEvent NS_TYPED_ENUM;

/**
 The use has pressed the keyboard key (applies to both SINGLE_KEYPRESS and RESEND_CURRENT_ENTRY modes).
 */
extern SDLKeyboardEvent const SDLKeyboardEventKeypress;

/**
 The User has finished entering text from the keyboard and submitted the entry.
 */
extern SDLKeyboardEvent const SDLKeyboardEventSubmitted;

/**
 The User has pressed the HMI-defined "Cancel" button.
 */
extern SDLKeyboardEvent const SDLKeyboardEventCancelled;

/**
 The User has not finished entering text and the keyboard is aborted with the event of higher priority.
 */
extern SDLKeyboardEvent const SDLKeyboardEventAborted;

/**
 The user used voice as input for the keyboard

 @since SDL 4.0
 */
extern SDLKeyboardEvent const SDLKeyboardEventVoice;
