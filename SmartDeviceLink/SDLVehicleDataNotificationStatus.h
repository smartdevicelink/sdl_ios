//  SDLVehicleDataNotificationStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the status of a vehicle data notification.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLVehicleDataNotificationStatus SDL_SWIFT_ENUM;

/**
 * @abstract SDLVehicleDataNotificationStatus: *NOT_SUPPORTED*
 */
extern SDLVehicleDataNotificationStatus const SDLVehicleDataNotificationStatusNotSupported;

/**
 @abstract SDLVehicleDataNotificationStatus: *NORMAL*
 */
extern SDLVehicleDataNotificationStatus const SDLVehicleDataNotificationStatusNormal;

/**
 @abstract SDLVehicleDataNotificationStatus: *ACTIVE*
 */
extern SDLVehicleDataNotificationStatus const SDLVehicleDataNotificationStatusActive;

/**
 @abstract SDLVehicleDataNotificationStatus: *NOT_USED*
 */
extern SDLVehicleDataNotificationStatus const SDLVehicleDataNotificationStatusNotUsed;
