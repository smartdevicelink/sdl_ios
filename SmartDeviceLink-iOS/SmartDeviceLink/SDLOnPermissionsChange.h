//  SDLOnPermissionsChange.h
//

#import "SDLRPCNotification.h"


/**
 * Provides update to app of which sets of functions are available
 *
 * @since SDL 2.0
 */
@interface SDLOnPermissionsChange : SDLRPCNotification {
}

/**
 * Constructs a newly allocated SDLOnPermissionsChange object
 */
- (instancetype)init;

/**
 * Constructs a newly allocated SDLOnPermissionsChange object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract Describes change in permissions for a given set of RPCs
 *
 * Required, Array of SDLPermissionItem, Array size 0 - 500
 *
 * @see SDLPermissionItem
 */
@property (strong) NSMutableArray *permissionItem;

@end
