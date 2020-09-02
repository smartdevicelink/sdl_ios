//  SDLOnAppInterfaceUnregistered.m
//

#import "SDLOnAppInterfaceUnregistered.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnAppInterfaceUnregistered

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnAppInterfaceUnregistered]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setReason:(SDLAppInterfaceUnregisteredReason)reason {
    [self.parameters sdl_setObject:reason forName:SDLRPCParameterNameReason];
}

- (SDLAppInterfaceUnregisteredReason)reason {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameReason error:&error];
}

@end

NS_ASSUME_NONNULL_END
