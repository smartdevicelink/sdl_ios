//  SDLGetWaypointsResponse.m
//

#import "SDLGetWaypointsResponse.h"
#import "SDLNames.h"

@implementation SDLGetWayPointsResponse

- (instancetype)init {
    if (self = [super initWithName:NAMES_GetWaypoints]) {
    }
    return self;
}

- (void)setWaypoints:(NSArray<SDLLocationDetails *> *)waypoints {
    if (waypoints != nil) {
        parameters[NAMES_waypoints] = waypoints;
    } else {
        [parameters removeObjectForKey:NAMES_waypoints];
    }
}

- (NSArray<SDLLocationDetails *> *)waypoints {
    return parameters[NAMES_waypoints];
}

@end

@implementation SDLGetWaypointsResponse

@end

