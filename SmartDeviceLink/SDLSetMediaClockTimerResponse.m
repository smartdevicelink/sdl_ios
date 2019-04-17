//  SDLSetMediaClockTimerResponse.m
//


#import "SDLSetMediaClockTimerResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSetMediaClockTimerResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSetMediaClockTimer]) {
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
