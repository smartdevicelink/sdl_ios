//  SDLVehicleDataActiveStatus.h
//


#import "SDLEnum.h"

/**
 Vehicle Data Activity Status
 */
@interface SDLVehicleDataActiveStatus : SDLEnum {
}

/**
 * @abstract Convert String to SDLVehicleDataActiveStatus
 * @param value NSString
 * @return SDLVehicleDataActiveStatus
 */
+ (SDLVehicleDataActiveStatus *)valueOf:(NSString *)value;

/**
 @abstract return the array that store all possible SDLVehicleDataActiveStatus values
 */
+ (NSArray *)values;

/**
 @abstract SDLVehicleDataActiveStatus : Inactive not confirmed
 */
+ (SDLVehicleDataActiveStatus *)INACTIVE_NOT_CONFIRMED;
/**
 @abstract SDLVehicleDataActiveStatus : Inactive confirmed
 */
+ (SDLVehicleDataActiveStatus *)INACTIVE_CONFIRMED;
/**
 @abstract SDLVehicleDataActiveStatus : Active not confirmed
 */
+ (SDLVehicleDataActiveStatus *)ACTIVE_NOT_CONFIRMED;
/**
 @abstract SDLVehicleDataActiveStatus : Active confirmed
 */
+ (SDLVehicleDataActiveStatus *)ACTIVE_CONFIRMED;
/**
 @abstract SDLVehicleDataActiveStatus : Fault
 */
+ (SDLVehicleDataActiveStatus *)FAULT;

@end
