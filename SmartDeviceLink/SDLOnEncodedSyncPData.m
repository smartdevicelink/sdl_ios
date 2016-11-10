//  SDLOnEncodedSyncPData.m
//

#import "SDLOnEncodedSyncPData.h"

#import "SDLNames.h"

@implementation SDLOnEncodedSyncPData

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnEncodedSyncPData]) {
    }
    return self;
}

- (void)setData:(NSMutableArray<NSString *> *)data {
    [parameters sdl_setObject:data forName:SDLNameData];
}

- (NSMutableArray<NSString *> *)data {
    return [parameters sdl_objectForName:SDLNameData];
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
