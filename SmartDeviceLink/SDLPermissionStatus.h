//  SDLPermissionStatus.h
//


#import "SDLEnum.h"

/**
 * Enumeration that describes possible permission states of a policy table entry.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLPermissionStatus NS_STRING_ENUM;

/**
 * @abstract permission: allowed
 */
extern SDLPermissionStatus const SDLPermissionStatusAllowed;

/**
 * @abstract permission: disallowed
 */
extern SDLPermissionStatus const SDLPermissionStatusDisallowed;

/**
 * @abstract permission: user disallowed
 */
extern SDLPermissionStatus const SDLPermissionStatusUserDisallowed;

/**
 * @abstract permission: user consent pending
 */
extern SDLPermissionStatus const SDLPermissionStatusUserConsentPending;
