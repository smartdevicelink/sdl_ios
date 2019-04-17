//  SDLGetWaypointsResponse.m
//

#import "SDLGetWayPointsResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLLocationDetails.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetWayPointsResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameGetWayPoints]) {
    }
    return self;
}

- (void)setWaypoints:(nullable NSArray<SDLLocationDetails *> *)waypoints {
    [parameters sdl_setObject:waypoints forName:SDLRPCParameterNameWayPoints];
}

- (nullable NSArray<SDLLocationDetails *> *)waypoints {
    return [parameters sdl_objectsForName:SDLRPCParameterNameWayPoints ofClass:SDLLocationDetails.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
