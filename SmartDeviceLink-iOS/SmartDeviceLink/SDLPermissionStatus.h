//  SDLPermissionStatus.h
//


#import "SDLEnum.h"

/**
 * Enumeration that describes possible permission states of a policy table entry.
 *
 * @since SDL 2.0
 */
@interface SDLPermissionStatus : SDLEnum {
}

/**
 * @abstract SDLPermissionStatus
 *
 * @param value The value of the string to get an object for
 *
 * @return a SDLPermissionStatus object
 */
+ (SDLPermissionStatus *)valueOf:(NSString *)value;

/**
 * @abstract declare an array to store all possible SDLPermissionStatus values
 * @return the array
 */
+ (NSArray *)values;


/**
 * @abstract permission: allowed
 * @return permission status: *ALLOWED*
 */
+ (SDLPermissionStatus *)ALLOWED;

/**
 * @abstract permission: disallowed
 * @return permission status: *DISALLOWED*
 */
+ (SDLPermissionStatus *)DISALLOWED;

/**
 * @abstract permission: user disallowed
 * @return permission status: *USER_DISALLOWED*
 */
+ (SDLPermissionStatus *)USER_DISALLOWED;

/**
 * @abstract permission: user consent pending
 * @return permission status: *USER_CONSENT_PENDING*
 */
+ (SDLPermissionStatus *)USER_CONSENT_PENDING;

@end
