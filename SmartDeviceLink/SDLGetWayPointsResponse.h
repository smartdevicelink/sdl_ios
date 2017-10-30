//  SDLGetWaypointsResponse.h
//

#import "SDLRPCResponse.h"

@class SDLLocationDetails;

NS_ASSUME_NONNULL_BEGIN

@interface SDLGetWayPointsResponse : SDLRPCResponse

/**
 * @abstract Array of waypoints
 *
 * @see SDLLocationDetails
 *
 * Optional, Array size 1 - 10
 */
@property (nullable, strong, nonatomic) NSArray<SDLLocationDetails *> *waypoints;

@end

NS_ASSUME_NONNULL_END
