//  SDLOnWaypointChange.m
//

#import "SDLOnWaypointChange.h"

#import "NSMutableDictionary+Store.h"
#import "SDLLocationDetails.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnWayPointChange

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnWaypointChange]) {
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

NS_ASSUME_NONNULL_END
