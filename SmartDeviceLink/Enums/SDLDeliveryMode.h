//  SDLDeliveryMode.h
//

#import "SDLEnum.h"

/**
 *Specifies the mode in which the sendLocation request is sent.
 */
typedef SDLEnum SDLDeliveryMode SDL_SWIFT_ENUM;

/**
 * @abstract User is prompted on HMI
 *
 */
extern SDLDeliveryMode const SDLDeliveryModePrompt;

/**
 * @abstract Set the location as destination without prompting the user
 *
 */
extern SDLDeliveryMode const SDLDeliveryModeDestination;

/**
 * @abstract Adds the current location to navigation queue
 *
 */
extern SDLDeliveryMode const SDLDeliveryModeQueue;
