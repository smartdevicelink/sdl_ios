//  SDLGetWaypoints.m
//

#import "SDLGetWaypoints.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetWayPoints

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

- (void)setWaypointType:(nullable SDLWaypointType)waypointType {
    [parameters sdl_setObject:waypointType forName:SDLNameWaypointType];
}

- (nullable SDLWaypointType)waypointType {
    return [parameters sdl_objectForName:SDLNameWaypointType];
}

@end

NS_ASSUME_NONNULL_END
