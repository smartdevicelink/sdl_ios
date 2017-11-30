//  SDLGetWaypointsResponse.m
//

#import "SDLGetWayPointsResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLLocationDetails.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetWayPointsResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameGetWayPoints]) {
    }
    return self;
}

- (void)setWaypoints:(nullable NSArray<SDLLocationDetails *> *)waypoints {
    [parameters sdl_setObject:waypoints forName:SDLNameWayPoints];
}

- (nullable NSArray<SDLLocationDetails *> *)waypoints {
    return [parameters sdl_objectsForName:SDLNameWayPoints ofClass:SDLLocationDetails.class];
}

@end

NS_ASSUME_NONNULL_END
