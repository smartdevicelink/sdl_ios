//  SDLGetWaypointsResponse.h
//

#import "SDLRPCResponse.h"

@class SDLLocationDetails;

NS_ASSUME_NONNULL_BEGIN

/**
 Response to SDLGetWayPoints
 */
@interface SDLGetWayPointsResponse : SDLRPCResponse

/**
 Provides additional human readable info regarding the result.
 
 Optional, Array size 1 - 10
 */
@property (nullable, strong, nonatomic) NSArray<SDLLocationDetails *> *waypoints;

@end

NS_ASSUME_NONNULL_END
