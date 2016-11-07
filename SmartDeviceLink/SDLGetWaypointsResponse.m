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
    [self setObject:waypoints forName:SDLNameWaypoints];
}

- (NSArray<SDLLocationDetails *> *)waypoints {
    return [self objectForName:SDLNameWaypoints];
}

@end
