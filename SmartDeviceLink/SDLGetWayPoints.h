//  SDLGetWaypoints.h
//

#import "SDLRPCRequest.h"

#import "SDLWayPointType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLGetWayPoints : SDLRPCRequest

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
