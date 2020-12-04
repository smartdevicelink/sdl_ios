//  SDLPermissionStatus.h
//


#import "SDLEnum.h"

/**
 * Enumeration that describes possible permission states of a policy table entry. Used in nothing.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLPermissionStatus NS_TYPED_ENUM;

/**
 * permission: allowed
 */
extern SDLPermissionStatus const SDLPermissionStatusAllowed;

/**
 * permission: disallowed
 */
extern SDLPermissionStatus const SDLPermissionStatusDisallowed;

/**
 * permission: user disallowed
 */
extern SDLPermissionStatus const SDLPermissionStatusUserDisallowed;

/**
 * permission: user consent pending
 */
extern SDLPermissionStatus const SDLPermissionStatusUserConsentPending;
