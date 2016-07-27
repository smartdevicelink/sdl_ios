//  SDLVehicleDataEventStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the status of a vehicle data event; e.g. a seat belt event status.
 *
 * @since SDL 2.0
 */
@interface SDLVehicleDataEventStatus : SDLEnum {
}

/**
 * Convert String to SDLVehicleDataEventStatus
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLVehicleDataEventStatus
 */
+ (SDLVehicleDataEventStatus *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLVehicleDataEventStatus
 *
 * @return an array that store all possible SDLVehicleDataEventStatus
 */
+ (NSArray *)values;

/**
 * @return The SDLVehicleDataEventStatus instance with value of *NO_EVENT*
 */
+ (SDLVehicleDataEventStatus *)NO_EVENT;

/**
 * @return The SDLVehicleDataEventStatus instance with value of *NO*
 */
+ (SDLVehicleDataEventStatus *)_NO;

/**
 * @return The SDLVehicleDataEventStatus instance with value of *YES*
 */
+ (SDLVehicleDataEventStatus *)_YES;

/**
 * @abstract Vehicle data event is not supported
 *
 * @return the SDLVehicleDataEventStatus instance with value of *NOT_SUPPORTED*
 */
+ (SDLVehicleDataEventStatus *)NOT_SUPPORTED;

/**
 * @abstract The SDLVehicleDataEventStatus instance with value of *FAULT*
 */
+ (SDLVehicleDataEventStatus *)FAULT;

@end
