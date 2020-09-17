//  SDLIgnitionStableStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the ignition switch stability. Used in BodyInformation
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLIgnitionStableStatus NS_TYPED_ENUM;

/**
 * The current ignition switch status is considered not to be stable.
 */
extern SDLIgnitionStableStatus const SDLIgnitionStableStatusNotStable;

/**
 * The current ignition switch status is considered to be stable.
 */
extern SDLIgnitionStableStatus const SDLIgnitionStableStatusStable;

/**
 * The current ignition switch status is considered to be missing from the transmitter
 */
extern SDLIgnitionStableStatus const SDLIgnitionStableStatusMissingFromTransmitter;
