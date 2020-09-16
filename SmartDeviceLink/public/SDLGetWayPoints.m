//  SDLGetWaypoints.m
//

#import "SDLGetWayPoints.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetWayPoints

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameGetWayPoints]) {
    }
    return self;
}
#pragma clang diagnostic pop


- (instancetype)initWithType:(SDLWayPointType)type {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.waypointType = type;

    return self;
}

- (void)setWaypointType:(nullable SDLWayPointType)waypointType {
    [self.parameters sdl_setObject:waypointType forName:SDLRPCParameterNameWayPointType];
}

- (nullable SDLWayPointType)waypointType {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameWayPointType error:nil];
}

@end

NS_ASSUME_NONNULL_END
