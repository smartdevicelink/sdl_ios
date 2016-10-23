//  SDLOnSyncPData.m
//


#import "SDLOnSyncPData.h"

#import "SDLNames.h"

@implementation SDLOnSyncPData

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnSyncPData]) {
    }
    return self;
}

- (void)setURL:(NSString *)URL {
    if (URL != nil) {
        [parameters setObject:URL forKey:SDLNameURLUppercase];
    } else {
        [parameters removeObjectForKey:SDLNameURLUppercase];
    }
}

- (NSString *)URL {
    return [parameters objectForKey:SDLNameURLUppercase];
}

- (void)setTimeout:(NSNumber<SDLInt> *)Timeout {
    if (Timeout != nil) {
        [parameters setObject:Timeout forKey:SDLNameTimeoutCapitalized];
    } else {
        [parameters removeObjectForKey:SDLNameTimeoutCapitalized];
    }
}

- (NSNumber<SDLInt> *)Timeout {
    return [parameters objectForKey:SDLNameTimeoutCapitalized];
}

@end
