//  SDLGetWaypointsResponse.m
//

#import "SDLGetWaypointsResponse.h"
#import "SDLNames.h"

@implementation SDLGetWaypointsResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameGetWaypoints]) {
    }
    return self;
}

- (void)setWaypoints:(nullable NSArray<SDLLocationDetails *> *)waypoints {
    if (waypoints != nil) {
        parameters[SDLNameWaypoints] = waypoints;
    } else {
        [parameters removeObjectForKey:SDLNameWaypoints];
    }
}

- (nullable NSArray<SDLLocationDetails *> *)waypoints {
    return parameters[SDLNameWaypoints];
}

@end
