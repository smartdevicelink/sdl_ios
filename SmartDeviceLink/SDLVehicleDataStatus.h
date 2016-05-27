//  SDLVehicleDataStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the status of a binary vehicle data item.
 *
 * @since SDL 2.0
 */
@interface SDLVehicleDataStatus : SDLEnum {
}

/**
 * Convert String to SDLVehicleDataStatus
 * @param value The value of the string to get an object for
 * @return SDLVehicleDataStatus
 */
+ (SDLVehicleDataStatus *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLVehicleDataStatus
 * @return an array that store all possible SDLVehicleDataStatus
 */
+ (NSArray *)values;

/**
 * @abstract No data avaliable
 * @return SDLVehicleDataStatus: *NO_DATA_EXISTS*
 */
+ (SDLVehicleDataStatus *)NO_DATA_EXISTS;

/**
 * @abstract return SDLVehicleDataStatus: *OFF*
 */
+ (SDLVehicleDataStatus *)OFF;

/**
 * @abstract return SDLVehicleDataStatus: *ON*
 */
+ (SDLVehicleDataStatus *)ON;

@end
