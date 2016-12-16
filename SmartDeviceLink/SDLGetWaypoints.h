//  SDLGetWaypoints.h
//

#import "SDLRPCRequest.h"

@class SDLWaypointType;


@interface SDLGetWayPoints : SDLRPCRequest

- (instancetype)initWithType:(SDLWaypointType *)type;

/**
 * To request for either the destination
 * only or for all waypoints including destination
 *
 * Required
 */
@property (strong, nonatomic) SDLWaypointType *waypointType;

@end

__deprecated_msg("Use SDLGetWayPoints instead")
    @interface SDLGetWaypoints : SDLGetWayPoints
                                 @end
