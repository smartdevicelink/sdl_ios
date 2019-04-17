//  SDLUnsubscribeWaypointsResponse.m
//

#import "SDLUnsubscribeWayPointsResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLUnsubscribeWayPointsResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameUnsubscribeWayPoints]) {
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
