//  SDLVehicleDataResultCode.h
//


#import "SDLEnum.h"

/**
 Vehicle Data Result Code
 */
@interface SDLVehicleDataResultCode : SDLEnum {
}

/**
 * Convert String to SDLVehicleDataResultCode
 * @param value String
 * @return SDLVehicleDataResultCode
 */
+ (SDLVehicleDataResultCode *)valueOf:(NSString *)value;

/**
 @abstract Store the enumeration of all possible SDLVehicleDataResultCode
 @return an array that store all possible SDLVehicleDataResultCode
 */
+ (NSArray *)values;

/**
 * Individual vehicle data item / DTC / DID request or subscription successful
 */
+ (SDLVehicleDataResultCode *)SUCCESS;

/**
 * DTC / DID request successful, however, not all active DTCs or full contents of DID location available
 */
+ (SDLVehicleDataResultCode *)TRUNCATED_DATA;

/**
 * This vehicle data item is not allowed for this app by SDL
 */
+ (SDLVehicleDataResultCode *)DISALLOWED;

/**
 * The user has not granted access to this type of vehicle data item at this time
 */
+ (SDLVehicleDataResultCode *)USER_DISALLOWED;

/**
 * The ECU ID referenced is not a valid ID on the bus / system
 */
+ (SDLVehicleDataResultCode *)INVALID_ID;

/**
 * The requested vehicle data item / DTC / DID is not currently available or responding on the bus / system
 */
+ (SDLVehicleDataResultCode *)VEHICLE_DATA_NOT_AVAILABLE;

/**
 * The vehicle data item is already subscribed
 */
+ (SDLVehicleDataResultCode *)DATA_ALREADY_SUBSCRIBED;

/**
 * The vehicle data item cannot be unsubscribed because it is not currently subscribed
 */
+ (SDLVehicleDataResultCode *)DATA_NOT_SUBSCRIBED;

/**
 * The request for this item is ignored because it is already in progress
 */
+ (SDLVehicleDataResultCode *)IGNORED;

@end
