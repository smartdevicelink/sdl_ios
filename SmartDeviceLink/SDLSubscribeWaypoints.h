//  SDLSubscribeWaypoints.h
//

#import "SDLRPCRequest.h"

/**
 * A SDLSubscribeWaypoints can be sent to subscribe
 * for any changes in waypoints/destinations
 *
 * @see SDLUnsubscribeWaypoints
 *
 */
@interface SDLSubscribeWayPoints : SDLRPCRequest

@end

__deprecated_msg("Use SDLSubscribeWayPoints instead")
    @interface SDLSubscribeWaypoints : SDLSubscribeWayPoints
                                       @end
