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
    [parameters sdl_setObject:URL forName:SDLNameURLUppercase];
}

- (NSString *)URL {
    return [parameters sdl_objectForName:SDLNameURLUppercase];
}

- (void)setTimeout:(NSNumber<SDLInt> *)Timeout {
    [parameters sdl_setObject:Timeout forName:SDLNameTimeoutCapitalized];
}

- (NSNumber<SDLInt> *)Timeout {
    return [parameters sdl_objectForName:SDLNameTimeoutCapitalized];
}

@end
