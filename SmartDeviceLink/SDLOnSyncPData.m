//  SDLOnSyncPData.m
//


#import "SDLOnSyncPData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"


NS_ASSUME_NONNULL_BEGIN

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
@implementation SDLOnSyncPData
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnSyncPData]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setURL:(nullable NSString *)URL {
    [self.parameters sdl_setObject:URL forName:SDLRPCParameterNameURLUppercase];
}

- (nullable NSString *)URL {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameURLUppercase ofClass:NSString.class error:nil];
}

- (void)setTimeout:(nullable NSNumber<SDLInt> *)Timeout {
    [self.parameters sdl_setObject:Timeout forName:SDLRPCParameterNameTimeoutCapitalized];
}

- (nullable NSNumber<SDLInt> *)Timeout {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTimeoutCapitalized ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
