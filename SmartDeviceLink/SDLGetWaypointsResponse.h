//  SDLGetWaypointsResponse.h
//

#import "SDLRPCResponse.h"

@class SDLLocationDetails;

NS_ASSUME_NONNULL_BEGIN

@interface SDLGetWaypointsResponse : SDLRPCResponse

/**
 * @abstract Array of waypoints
 *
 * @see SDLLocationDetails
 *
 * Optional, Array size 1 - 10
 */
@property (nullable, strong) NSArray<SDLLocationDetails *> *waypoints;

@end

NS_ASSUME_NONNULL_END
