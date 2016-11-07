//  SDLOnWaypointChange.m
//

#import "SDLOnWaypointChange.h"

#import "SDLNames.h"

@implementation SDLOnWaypointChange

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnWaypointChange]) {
    }
    return self;
}

- (void)setWaypoints:(NSArray<SDLLocationDetails *> *)waypoints {
    [self setObject:waypoints forName:SDLNameWaypoints];
}

- (NSArray<SDLLocationDetails *> *)waypoints {
    return [self objectForName:SDLNameWaypoints];
}

@end
