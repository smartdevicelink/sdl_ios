//  SDLKeyboardLayout.h
//


#import "SDLEnum.h"

/**
 Enumeration listing possible keyboard layouts. Used in KeyboardProperties.

 Since SmartDeviceLink 3.0
 */
typedef SDLEnum SDLKeyboardLayout NS_TYPED_ENUM;

/**
 QWERTY layout (the name comes from the first six keys<br> appearing on the top left letter row of the keyboard and read from left to right)
 */
extern SDLKeyboardLayout const SDLKeyboardLayoutQWERTY;

/**
 QWERTZ layout (the name comes from the first six keys<br> appearing on the top left letter row of the keyboard and read from left to right)
 */
extern SDLKeyboardLayout const SDLKeyboardLayoutQWERTZ;

/**
 AZERTY layout (the name comes from the first six keys<br> appearing on the top left letter row of the keyboard and read from left to right)
 */
extern SDLKeyboardLayout const SDLKeyboardLayoutAZERTY;
