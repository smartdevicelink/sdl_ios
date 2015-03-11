//  SDLVehicleDataResultCode.h
//



#import "SDLEnum.h"

/*!
 Vehicle Data Result Code
 */
@interface SDLVehicleDataResultCode : SDLEnum {}

/**
 * Convert String to SDLVehicleDataResultCode
 * @param value String
 * @return SDLVehicleDataResultCode
 */
+(SDLVehicleDataResultCode*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLVehicleDataResultCode
 @result return an array that store all possible SDLVehicleDataResultCode
 */
+(NSArray*) values;

/*!
 @abstract return SDLVehicleDataResultCode : <font color=gray><i> SUCCESS </i></font>
 */
+(SDLVehicleDataResultCode*) SUCCESS;
+(SDLVehicleDataResultCode*) TRUNCATED_DATA;
/*!
 @abstract return SDLVehicleDataResultCode : <font color=gray><i> DISALLOWED </i></font>
 */
+(SDLVehicleDataResultCode*) DISALLOWED;
/*!
 @abstract return SDLVehicleDataResultCode : <font color=gray><i> USER_DISALLOWED </i></font>
 */
+(SDLVehicleDataResultCode*) USER_DISALLOWED;
/*!
 @abstract return SDLVehicleDataResultCode : <font color=gray><i> INVALID_ID </i></font>
 */
+(SDLVehicleDataResultCode*) INVALID_ID;
/*!
 @abstract return SDLVehicleDataResultCode : <font color=gray><i> VEHICLE_DATA_NOT_AVAILABLE </i></font>
 */
+(SDLVehicleDataResultCode*) VEHICLE_DATA_NOT_AVAILABLE;
/*!
 @abstract return SDLVehicleDataResultCode : <font color=gray><i> DATA_ALREADY_SUBSCRIBED </i></font>
 */
+(SDLVehicleDataResultCode*) DATA_ALREADY_SUBSCRIBED;
/*!
 @abstract return SDLVehicleDataResultCode : <font color=gray><i> DATA_NOT_SUBSCRIBED </i></font>
 */
+(SDLVehicleDataResultCode*) DATA_NOT_SUBSCRIBED;
/*!
 @abstract return SDLVehicleDataResultCode : <font color=gray><i> IGNORED </i></font>
 */
+(SDLVehicleDataResultCode*) IGNORED;

@end

