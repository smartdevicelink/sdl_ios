//  SDLOnWayPointChange.m
//

#import "SDLOnWayPointChange.h"

#import "NSMutableDictionary+Store.h"
#import "SDLLocationDetails.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnWayPointChange

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnWayPointChange]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithWayPoints:(NSArray<SDLLocationDetails *> *)wayPoints {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.wayPoints = wayPoints;
    return self;
}

- (void)setWayPoints:(NSArray<SDLLocationDetails *> *)wayPoints {
    [self.parameters sdl_setObject:wayPoints forName:SDLRPCParameterNameWayPoints];
}

- (NSArray<SDLLocationDetails *> *)wayPoints {
    NSError *error = nil;
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameWayPoints ofClass:SDLLocationDetails.class error:&error];
}

- (void)setWaypoints:(NSArray<SDLLocationDetails *> *)waypoints {
    [self.parameters sdl_setObject:waypoints forName:SDLRPCParameterNameWayPoints];
}

- (NSArray<SDLLocationDetails *> *)waypoints {
    NSError *error = nil;
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameWayPoints ofClass:SDLLocationDetails.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
