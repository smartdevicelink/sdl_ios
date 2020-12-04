//  SDLDeliveryMode.h
//

#import "SDLEnum.h"

/**
 * Specifies the mode in which the sendLocation request is sent. Used in SendLocation.
 */
typedef SDLEnum SDLDeliveryMode NS_TYPED_ENUM;

/**
 * User is prompted on HMI
 */
extern SDLDeliveryMode const SDLDeliveryModePrompt;

/**
 * Set the location as destination without prompting the user
 */
extern SDLDeliveryMode const SDLDeliveryModeDestination;

/**
 * Adds the current location to navigation queue
 */
extern SDLDeliveryMode const SDLDeliveryModeQueue;
