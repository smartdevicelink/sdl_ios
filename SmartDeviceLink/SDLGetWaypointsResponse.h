//  SDLGetWaypointsResponse.h
//

#import "SDLRPCResponse.h"

@class SDLLocationDetails;

@interface SDLGetWaypointsResponse : SDLRPCResponse

/**
 * @abstract Array of waypoints
 *
 * @see SDLLocationDetails
 *
 * Optional, Array size 1 - 10
 */
@property (strong) NSArray<SDLLocationDetails *> *waypoints;

@end
