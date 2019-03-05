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
    NSObject *obj = [parameters sdl_objectForName:SDLRPCParameterNameState];
    return (SDLTBTState)obj;
}

@end

NS_ASSUME_NONNULL_END
