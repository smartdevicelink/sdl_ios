//  SDLMaintenanceModeStatus.h
//


#import "SDLEnum.h"

/**
 * The SDLMaintenanceModeStatus class.
 */
@interface SDLMaintenanceModeStatus : SDLEnum {
}

/**
 * @abstract Maintenance Mode Status
 * @param value The value of the string to get an object for
 * @return SDLMaintenanceModeStatus
 */
+ (SDLMaintenanceModeStatus *)valueOf:(NSString *)value;

/**
 * @abstract declare an array that store all possible Maintenance Mode Status inside
 * @return the array
 */
+ (NSArray *)values;

/**
 * @abstract Maintenance Mode Status : Normal
 * @return the object with value of *NORMAL*
 */
+ (SDLMaintenanceModeStatus *)NORMAL;

/**
 * @abstract Maintenance Mode Status : Near
 * @return the object with value of *NEAR*
 */
+ (SDLMaintenanceModeStatus *)NEAR;

/**
 * @abstract Maintenance Mode Status : Active
 * @return the object with value of *ACTIVE*
 */
+ (SDLMaintenanceModeStatus *)ACTIVE;

/**
 * @abstract Maintenance Mode Status : Feature not present
 * @return the object with value of *FEATURE_NOT_PRESENT*
 */
+ (SDLMaintenanceModeStatus *)FEATURE_NOT_PRESENT;

@end
