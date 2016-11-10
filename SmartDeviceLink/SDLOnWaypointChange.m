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
    [parameters sdl_setObject:waypoints forName:SDLNameWaypoints];
}

- (NSArray<SDLLocationDetails *> *)waypoints {
    return [parameters sdl_objectForName:SDLNameWaypoints];
}

@end
