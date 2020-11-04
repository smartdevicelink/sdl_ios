//  SDLUnsubscribeWaypointsResponse.m
//

#import "SDLUnsubscribeWayPointsResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLLocationDetails.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLUnsubscribeWayPointsResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameUnsubscribeWayPoints]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithWayPoints:(nullable NSArray<SDLLocationDetails *> *)wayPoints {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.wayPoints = wayPoints;
    return self;
}

- (void)setWayPoints:(nullable NSArray<SDLLocationDetails *> *)wayPoints {
    [self.parameters sdl_setObject:wayPoints forName:SDLRPCParameterNameWayPoints];
}

- (nullable NSArray<SDLLocationDetails *> *)wayPoints {
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameWayPoints ofClass:SDLLocationDetails.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
