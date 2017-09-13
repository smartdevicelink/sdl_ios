//  SDLGetWaypoints.m
//

#import "SDLGetWayPoints.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetWayPoints

- (instancetype)init {
    if (self = [super initWithName:SDLNameGetWayPoints]) {
    }
    return self;
}


- (instancetype)initWithType:(SDLWayPointType)type {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.waypointType = type;

    return self;
}

- (void)setWaypointType:(nullable SDLWayPointType)waypointType {
    [parameters sdl_setObject:waypointType forName:SDLNameWayPointType];
}

- (nullable SDLWayPointType)waypointType {
    return [parameters sdl_objectForName:SDLNameWayPointType];
}

@end

NS_ASSUME_NONNULL_END
