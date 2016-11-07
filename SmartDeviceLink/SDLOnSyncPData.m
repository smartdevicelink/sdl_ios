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
    [self setObject:URL forName:SDLNameURLUppercase];
}

- (NSString *)URL {
    return [parameters objectForKey:SDLNameURLUppercase];
}

- (void)setTimeout:(NSNumber<SDLInt> *)Timeout {
    [self setObject:Timeout forName:SDLNameTimeoutCapitalized];
}

- (NSNumber<SDLInt> *)Timeout {
    return [parameters objectForKey:SDLNameTimeoutCapitalized];
}

@end
