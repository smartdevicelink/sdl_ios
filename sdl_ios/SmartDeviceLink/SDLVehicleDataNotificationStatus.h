//  SDLVehicleDataNotificationStatus.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * Reflects the status of a vehicle data notification.
 *
 * Avaliable since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
@interface SDLVehicleDataNotificationStatus : SDLEnum {}

/**
 * Convert String to SDLVehicleDataNotificationStatus
 * @param value String
 * @return SDLVehicleDataNotificationStatus
 */
+(SDLVehicleDataNotificationStatus*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLVehicleDataNotificationStatus
 @result return an array that store all possible SDLVehicleDataNotificationStatus
 */
+(NSMutableArray*) values;

/*!
 @abstract SDLVehicleDataNotificationStatus : <font color=gray><i> NOT_SUPPORTED </i></font>
 */
+(SDLVehicleDataNotificationStatus*) NOT_SUPPORTED;
/*!
 @abstract SDLVehicleDataNotificationStatus : <font color=gray><i> NORMAL </i></font>
 */
+(SDLVehicleDataNotificationStatus*) NORMAL;
/*!
 @abstract SDLVehicleDataNotificationStatus : <font color=gray><i> ACTIVE </i></font>
 */
+(SDLVehicleDataNotificationStatus*) ACTIVE;
/*!
 @abstract SDLVehicleDataNotificationStatus : <font color=gray><i> NOT_USED </i></font>
 */
+(SDLVehicleDataNotificationStatus*) NOT_USED;

@end
