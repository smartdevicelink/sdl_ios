//  SDLComponentVolumeStatus.h
//


#import "SDLEnum.h"

/**
 * The volume status of a vehicle component. Used in SingleTireStatus and VehicleData Fuel Level
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLComponentVolumeStatus NS_TYPED_ENUM;

/**
 * Unknown SDLComponentVolumeStatus
 */
extern SDLComponentVolumeStatus const SDLComponentVolumeStatusUnknown;

/**
 * Normal SDLComponentVolumeStatus
 */
extern SDLComponentVolumeStatus const SDLComponentVolumeStatusNormal;

/**
 * Low SDLComponentVolumeStatus
 */
extern SDLComponentVolumeStatus const SDLComponentVolumeStatusLow;

/**
 * Fault SDLComponentVolumeStatus
 */
extern SDLComponentVolumeStatus const SDLComponentVolumeStatusFault;

/**
 * Alert SDLComponentVolumeStatus
 */
extern SDLComponentVolumeStatus const SDLComponentVolumeStatusAlert;

/**
 * Not supported SDLComponentVolumeStatus
 */
extern SDLComponentVolumeStatus const SDLComponentVolumeStatusNotSupported;
