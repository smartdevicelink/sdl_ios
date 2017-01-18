//  SDLHmiZoneCapabilities.h
//


#import "SDLEnum.h"

/**
 * Specifies HMI Zones in the vehicle.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLHMIZoneCapabilities SDL_SWIFT_ENUM;

/**
 * @abstract Indicates HMI available for front seat passengers.
 */
extern SDLHMIZoneCapabilities const SDLHMIZoneCapabilitiesFront;

/**
 * @abstract Indicates HMI available for rear seat passengers.
 */
extern SDLHMIZoneCapabilities const SDLHMIZoneCapabilitiesBack;
