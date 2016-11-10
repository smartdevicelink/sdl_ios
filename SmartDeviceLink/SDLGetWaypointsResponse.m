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

- (void)setWaypoints:(NSArray<SDLLocationDetails *> *)waypoints {
    [parameters sdl_setObject:waypoints forName:SDLNameWaypoints];
}

- (NSArray<SDLLocationDetails *> *)waypoints {
    return [parameters sdl_objectForName:SDLNameWaypoints];
}

@end
