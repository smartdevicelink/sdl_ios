//  SDLOnWaypointChange.h
//

#import "SDLRPCNotification.h"

@class SDLLocationDetails;

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnWayPointChange : SDLRPCNotification

/**
 * @abstract Location address for display purposes only.
 *
 * Required, Array of Strings, Array size 1 - 10
 */
@property (copy, nonatomic) NSArray<SDLLocationDetails *> *waypoints;

@end

__deprecated_msg("Use SDLOnWayPointChange instead")
    @interface SDLOnWaypointChange : SDLOnWayPointChange
@end

NS_ASSUME_NONNULL_END
