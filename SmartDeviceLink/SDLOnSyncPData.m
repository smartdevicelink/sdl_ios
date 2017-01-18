//  SDLOnSyncPData.m
//


#import "SDLOnSyncPData.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnSyncPData

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnSyncPData]) {
    }
    return self;
}

- (void)setURL:(nullable NSString *)URL {
    if (URL != nil) {
        [parameters setObject:URL forKey:SDLNameURLUppercase];
    } else {
        [parameters removeObjectForKey:SDLNameURLUppercase];
    }
}

- (nullable NSString *)URL {
    return [parameters objectForKey:SDLNameURLUppercase];
}

- (void)setTimeout:(nullable NSNumber<SDLInt> *)Timeout {
    if (Timeout != nil) {
        [parameters setObject:Timeout forKey:SDLNameTimeoutCapitalized];
    } else {
        [parameters removeObjectForKey:SDLNameTimeoutCapitalized];
    }
}

- (nullable NSNumber<SDLInt> *)Timeout {
    return [parameters objectForKey:SDLNameTimeoutCapitalized];
}

@end

NS_ASSUME_NONNULL_END
