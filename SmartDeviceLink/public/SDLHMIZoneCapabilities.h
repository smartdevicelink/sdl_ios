//  SDLHmiZoneCapabilities.h
//


#import "SDLEnum.h"

/**
 * Specifies HMI Zones in the vehicle. Used in RegisterAppInterfaceResponse
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLHMIZoneCapabilities NS_TYPED_ENUM;

/**
 * Indicates HMI available for front seat passengers.
 */
extern SDLHMIZoneCapabilities const SDLHMIZoneCapabilitiesFront;

/**
 * Indicates HMI available for rear seat passengers.
 */
extern SDLHMIZoneCapabilities const SDLHMIZoneCapabilitiesBack;
