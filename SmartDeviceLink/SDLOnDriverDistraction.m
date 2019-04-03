//  SDLOnDriverDistraction.m
//

#import "SDLOnDriverDistraction.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLDriverDistractionState.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnDriverDistraction

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnDriverDistraction]) {
    }
    return self;
}

- (void)setState:(SDLDriverDistractionState)state {
    [parameters sdl_setObject:state forName:SDLRPCParameterNameState];
}

- (SDLDriverDistractionState)state {
    NSError *error = nil;
    return [parameters sdl_enumForName:SDLRPCParameterNameState error:&error];
}

@end

NS_ASSUME_NONNULL_END
