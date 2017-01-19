//  SDLOnSyncPData.m
//


#import "SDLOnSyncPData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnSyncPData

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnSyncPData]) {
    }
    return self;
}

- (void)setURL:(nullable NSString *)URL {
    [parameters sdl_setObject:URL forName:SDLNameURLUppercase];
}

- (nullable NSString *)URL {
    return [parameters sdl_objectForName:SDLNameURLUppercase];
}

- (void)setTimeout:(nullable NSNumber<SDLInt> *)Timeout {
    [parameters sdl_setObject:Timeout forName:SDLNameTimeoutCapitalized];
}

- (nullable NSNumber<SDLInt> *)Timeout {
    return [parameters sdl_objectForName:SDLNameTimeoutCapitalized];
}

@end

NS_ASSUME_NONNULL_END
