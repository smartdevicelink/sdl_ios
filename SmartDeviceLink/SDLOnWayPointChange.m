//  SDLOnWayPointChange.m
//

#import "SDLOnWayPointChange.h"

#import "NSMutableDictionary+Store.h"
#import "SDLLocationDetails.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnWayPointChange

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnWayPointChange]) {
    }
    return self;
}

- (void)setWaypoints:(NSArray<SDLLocationDetails *> *)waypoints {
    [parameters sdl_setObject:waypoints forName:SDLNameWayPoints];
}

- (NSArray<SDLLocationDetails *> *)waypoints {
    return [parameters sdl_objectsForName:SDLNameWayPoints ofClass:SDLLocationDetails.class];
}

@end

NS_ASSUME_NONNULL_END
