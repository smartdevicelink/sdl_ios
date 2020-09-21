//  SDLSystemAction.h
//


#import "SDLEnum.h"

/**
 * Enumeration that describes system actions that can be triggered. Used in SoftButton.
 */
typedef SDLEnum SDLSystemAction NS_TYPED_ENUM;

/**
 A default soft button action
 */
extern SDLSystemAction const SDLSystemActionDefaultAction;

/**
 An action causing your app to steal HMI focus
 */
extern SDLSystemAction const SDLSystemActionStealFocus;

/**
 An action causing you to keep context
 */
extern SDLSystemAction const SDLSystemActionKeepContext;
