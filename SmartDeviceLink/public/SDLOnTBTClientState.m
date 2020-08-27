//  SDLOnTBTClientState.m
//

#import "SDLOnTBTClientState.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnTBTClientState

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnTBTClientState]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setState:(SDLTBTState)state {
    [self.parameters sdl_setObject:state forName:SDLRPCParameterNameState];
}

- (SDLTBTState)state {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameState error:&error];
}

@end

NS_ASSUME_NONNULL_END
