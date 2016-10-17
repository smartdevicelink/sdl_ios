//  SDLOnPermissionsChange.h
//

#import "SDLRPCNotification.h"

@class SDLPermissionItem;

/**
 * Provides update to app of which sets of functions are available
 *
 * @since SDL 2.0
 */
@interface SDLOnPermissionsChange : SDLRPCNotification

/**
 * @abstract Describes change in permissions for a given set of RPCs
 *
 * Required, Array of SDLPermissionItem, Array size 0 - 500
 *
 * @see SDLPermissionItem
 */
@property (strong) NSMutableArray<SDLPermissionItem *> *permissionItem;

@end
