//  SDLOnSyncPData.m
//


#import "SDLOnSyncPData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnSyncPData

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnSyncPData]) {
    }
    return self;
}

- (void)setURL:(nullable NSString *)URL {
    [parameters sdl_setObject:URL forName:SDLRPCParameterNameURLUppercase];
}

- (nullable NSString *)URL {
    return [parameters sdl_objectForName:SDLRPCParameterNameURLUppercase];
}

- (void)setTimeout:(nullable NSNumber<SDLInt> *)Timeout {
    [parameters sdl_setObject:Timeout forName:SDLRPCParameterNameTimeoutCapitalized];
}

- (nullable NSNumber<SDLInt> *)Timeout {
    return [parameters sdl_objectForName:SDLRPCParameterNameTimeoutCapitalized];
}

@end

NS_ASSUME_NONNULL_END
