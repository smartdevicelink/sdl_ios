//  SDLGetWaypointsResponse.m
//

#import "SDLGetWaypointsResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLLocationDetails.h"
#import "SDLNames.h"

@implementation SDLGetWayPointsResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameGetWaypoints]) {
    }
    return self;
}

- (void)setWaypoints:(NSArray<SDLLocationDetails *> *)waypoints {
    [parameters sdl_setObject:waypoints forName:SDLNameWaypoints];
}

- (NSArray<SDLLocationDetails *> *)waypoints {
    return [parameters sdl_objectsForName:SDLNameWaypoints ofClass:SDLLocationDetails.class];
}

@end

@implementation SDLGetWaypointsResponse

@end
