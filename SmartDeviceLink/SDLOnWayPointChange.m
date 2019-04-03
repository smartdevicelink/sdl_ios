//  SDLOnWayPointChange.m
//

#import "SDLOnWayPointChange.h"

#import "NSMutableDictionary+Store.h"
#import "SDLLocationDetails.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnWayPointChange

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnWayPointChange]) {
    }
    return self;
}

- (void)setWaypoints:(NSArray<SDLLocationDetails *> *)waypoints {
    [parameters sdl_setObject:waypoints forName:SDLRPCParameterNameWayPoints];
}

- (NSArray<SDLLocationDetails *> *)waypoints {
    NSError *error = nil;
    return [parameters sdl_objectsForName:SDLRPCParameterNameWayPoints ofClass:SDLLocationDetails.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
