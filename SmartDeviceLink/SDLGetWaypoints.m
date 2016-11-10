//  SDLGetWaypoints.m
//

#import "SDLGetWaypoints.h"

#import "SDLNames.h"

@implementation SDLGetWaypoints

- (instancetype)init {
    if (self = [super initWithName:SDLNameGetWaypoints]) {
    }
    return self;
}


- (instancetype)initWithType:(SDLWaypointType)type {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.waypointType = type;

    return self;
}

- (void)setWaypointType:(SDLWaypointType)waypointType {
    [parameters sdl_setObject:waypointType forName:SDLNameWaypointType];
}

- (SDLWaypointType)waypointType {
    return [parameters sdl_objectForName:SDLNameWaypointType];
}

@end
