//  SDLGetWaypoints.m
//

#import "SDLGetWaypoints.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

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
    if (waypointType != nil) {
        parameters[SDLNameWaypointType] = waypointType;
    } else {
        [parameters removeObjectForKey:SDLNameWaypointType];
    }
}

- (SDLWaypointType)waypointType {
    return parameters[SDLNameWaypointType];
}

@end

NS_ASSUME_NONNULL_END
