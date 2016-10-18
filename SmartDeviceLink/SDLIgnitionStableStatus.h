//  SDLIgnitionStableStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the ignition switch stability.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLIgnitionStableStatus SDL_SWIFT_ENUM;

/**
 * @abstract The current ignition switch status is considered not to be stable.
 */
extern SDLIgnitionStableStatus const SDLIgnitionStableStatusNotStable;

/**
 * @abstract The current ignition switch status is considered to be stable.
 */
extern SDLIgnitionStableStatus const SDLIgnitionStableStatusStable;

extern SDLIgnitionStableStatus const SDLIgnitionStableStatusMissingFromTransmitter;
