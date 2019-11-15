//  SDLGetWaypoints.h
//

#import "SDLRPCRequest.h"

#import "SDLWayPointType.h"

NS_ASSUME_NONNULL_BEGIN

/// This RPC allows you to get navigation waypoint data
///
/// @since RPC 4.1
@interface SDLGetWayPoints : SDLRPCRequest

/// Convenience init to get waypoints.
///
/// @param type To request for either the destination only or for all waypoints including destination
/// @return An SDLGetWayPoints object
- (instancetype)initWithType:(SDLWayPointType)type;

/**
 * To request for either the destination
 * only or for all waypoints including destination
 *
 * Required
 */
@property (nullable, strong, nonatomic) SDLWayPointType waypointType;

@end

NS_ASSUME_NONNULL_END
