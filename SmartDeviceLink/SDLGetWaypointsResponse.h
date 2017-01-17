//  SDLGetWaypointsResponse.h
//

#import "SDLRPCResponse.h"

@class SDLLocationDetails;

@interface SDLGetWayPointsResponse : SDLRPCResponse

/**
 * @abstract Array of waypoints
 *
 * @see SDLLocationDetails
 *
 * Optional, Array size 1 - 10
 */
@property (strong) NSArray<SDLLocationDetails *> *waypoints;

@end

__deprecated_msg("Use SDLGetWayPointsResponse instead")
    @interface SDLGetWaypointsResponse : SDLGetWayPointsResponse
                                         @end
