//  SDLGetWaypoints.m
//

#import "SDLGetWaypoints.h"

#import "SDLNames.h"
#import "SDLWaypointType.h"

@implementation SDLGetWayPoints

- (instancetype)init {
    if (self = [super initWithName:NAMES_GetWaypoints]) {
    }
    return self;
}


- (instancetype)initWithType:(SDLWaypointType *)type {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.waypointType = type;

    return self;
}

- (void)setWaypointType:(SDLWaypointType *)waypointType {
    if (waypointType != nil) {
        parameters[NAMES_waypointType] = waypointType;
    } else {
        [parameters removeObjectForKey:NAMES_waypointType];
    }
}

- (SDLWaypointType *)waypointType {
    NSObject *obj = parameters[NAMES_waypointType];
    if (obj == nil || [obj isKindOfClass:SDLWaypointType.class]) {
        return (SDLWaypointType *)obj;
    } else {
        return [SDLWaypointType valueOf:(NSString *)obj];
    }
}

@end

@implementation SDLGetWaypoints

@end
