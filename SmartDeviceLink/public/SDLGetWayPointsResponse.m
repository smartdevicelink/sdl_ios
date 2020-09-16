//  SDLGetWaypointsResponse.m
//

#import "SDLGetWayPointsResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLLocationDetails.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetWayPointsResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameGetWayPoints]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setWaypoints:(nullable NSArray<SDLLocationDetails *> *)waypoints {
    [self.parameters sdl_setObject:waypoints forName:SDLRPCParameterNameWayPoints];
}

- (nullable NSArray<SDLLocationDetails *> *)waypoints {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameWayPoints ofClass:SDLLocationDetails.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
