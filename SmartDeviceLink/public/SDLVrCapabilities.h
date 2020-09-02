//  SDLVRCapabilities.h
//


#import "SDLEnum.h"

/**
 * The VR capabilities of the connected SDL platform. Used in RegisterAppInterfaceResponse.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLVRCapabilities SDL_SWIFT_ENUM;

/**
 * The SDL platform is capable of recognizing spoken text in the current language.
 */
extern SDLVRCapabilities const SDLVRCapabilitiesText;
