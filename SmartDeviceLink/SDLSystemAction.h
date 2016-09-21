//  SDLSystemAction.h
//


#import "SDLEnum.h"

/**
 *
 * Enumeration that describes system actions that can be triggered.
 */
typedef SDLEnum SDLSystemAction NS_EXTENSIBLE_STRING_ENUM;

/**
 @abstract Default_Action
 */
extern SDLSystemAction const SDLSystemActionDefaultAction;

/**
 @abstract Steal_Focus
 */
extern SDLSystemAction const SDLSystemActionStealFocus;

/**
 @abstract Keep_Context
 */
extern SDLSystemAction const SDLSystemActionKeepContext;
