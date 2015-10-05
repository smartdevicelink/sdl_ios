//  SDLVehicleDataNotificationStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the status of a vehicle data notification.
 *
 * @since SDL 2.0
 */
@interface SDLVehicleDataNotificationStatus : SDLEnum {
}

/**
 * Convert String to SDLVehicleDataNotificationStatus
 * @param value The value of the string to get an object for
 * @return SDLVehicleDataNotificationStatus
 */
+ (SDLVehicleDataNotificationStatus *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLVehicleDataNotificationStatus
 * @return an array that store all possible SDLVehicleDataNotificationStatus
 */
+ (NSArray *)values;

/**
 * @abstract SDLVehicleDataNotificationStatus: *NOT_SUPPORTED*
 */
+ (SDLVehicleDataNotificationStatus *)NOT_SUPPORTED;

/**
 @abstract SDLVehicleDataNotificationStatus: *NORMAL*
 */
+ (SDLVehicleDataNotificationStatus *)NORMAL;

/**
 @abstract SDLVehicleDataNotificationStatus: *ACTIVE*
 */
+ (SDLVehicleDataNotificationStatus *)ACTIVE;

/**
 @abstract SDLVehicleDataNotificationStatus: *NOT_USED*
 */
+ (SDLVehicleDataNotificationStatus *)NOT_USED;

@end
