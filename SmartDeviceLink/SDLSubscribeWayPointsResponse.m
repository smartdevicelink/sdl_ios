
//  SDLSubscribeWaypointsResponse.m
//

#import "SDLSubscribeWayPointsResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSubscribeWayPointsResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSubscribeWayPoints]) {
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
