//  SDLOnTBTClientState.m
//

#import "SDLOnTBTClientState.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnTBTClientState

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnTBTClientState]) {
    }
    return self;
}

- (void)setState:(SDLTBTState)state {
    [parameters sdl_setObject:state forName:SDLRPCParameterNameState];
}

- (SDLTBTState)state {
    NSError *error = nil;
    return [parameters sdl_enumForName:SDLRPCParameterNameState error:&error];
}

@end

NS_ASSUME_NONNULL_END
