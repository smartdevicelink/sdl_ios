//  SDLOnAppInterfaceUnregistered.m
//

#import "SDLOnAppInterfaceUnregistered.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnAppInterfaceUnregistered

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnAppInterfaceUnregistered]) {
    }
    return self;
}

- (void)setReason:(SDLAppInterfaceUnregisteredReason)reason {
    [parameters sdl_setObject:reason forName:SDLRPCParameterNameReason];
}

- (SDLAppInterfaceUnregisteredReason)reason {
    NSError *error = nil;
    return [parameters sdl_enumForName:SDLRPCParameterNameReason error:&error];
}

@end

NS_ASSUME_NONNULL_END
