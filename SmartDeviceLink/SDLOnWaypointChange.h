//  SDLOnWaypointChange.h
//

#import "SDLRPCNotification.h"

@class SDLLocationDetails;

@interface SDLOnWaypointChange : SDLRPCNotification

/**
 * @abstract Location address for display purposes only.
 *
 * Required, Array of Strings, Array size 1 - 10
 */
@property (copy, nonatomic) NSArray<SDLLocationDetails *> *waypoints;

@end
