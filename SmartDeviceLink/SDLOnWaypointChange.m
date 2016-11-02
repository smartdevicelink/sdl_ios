//  SDLOnWaypointChange.m
//

#import "SDLOnWaypointChange.h"

#import "SDLNames.h"

@implementation SDLOnWaypointChange

- (instancetype)init {
    if (self = [super initWithName:NAMES_OnWaypointChange]) {
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
