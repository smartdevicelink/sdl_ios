//  SDLComponentVolumeStatus.h
//


#import "SDLEnum.h"

/**
 * The volume status of a vehicle component.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLComponentVolumeStatus SDL_SWIFT_ENUM;

/**
 * @abstract Unknown SDLComponentVolumeStatus
 */
extern SDLComponentVolumeStatus const SDLComponentVolumeStatusUnknown;

/**
 * @abstract Normal SDLComponentVolumeStatus
 */
extern SDLComponentVolumeStatus const SDLComponentVolumeStatusNormal;

/**
 * @abstract Low SDLComponentVolumeStatus
 */
extern SDLComponentVolumeStatus const SDLComponentVolumeStatusLow;

/**
 * @abstract Fault SDLComponentVolumeStatus
 */
extern SDLComponentVolumeStatus const SDLComponentVolumeStatusFault;

/**
 * @abstract Alert SDLComponentVolumeStatus
 */
extern SDLComponentVolumeStatus const SDLComponentVolumeStatusAlert;

/**
 * @abstract Not supported SDLComponentVolumeStatus
 */
extern SDLComponentVolumeStatus const SDLComponentVolumeStatusNotSupported;
