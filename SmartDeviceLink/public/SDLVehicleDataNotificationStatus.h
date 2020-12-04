//  SDLVehicleDataNotificationStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the status of a vehicle data notification. Used in ECallInfo
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLVehicleDataNotificationStatus NS_TYPED_ENUM;

/**
 The vehicle data notification status is not supported
 */
extern SDLVehicleDataNotificationStatus const SDLVehicleDataNotificationStatusNotSupported;

/**
 The vehicle data notification status is normal
 */
extern SDLVehicleDataNotificationStatus const SDLVehicleDataNotificationStatusNormal;

/**
 The vehicle data notification status is active
 */
extern SDLVehicleDataNotificationStatus const SDLVehicleDataNotificationStatusActive;

/**
 The vehicle data notification status is not used
 */
extern SDLVehicleDataNotificationStatus const SDLVehicleDataNotificationStatusNotUsed;
