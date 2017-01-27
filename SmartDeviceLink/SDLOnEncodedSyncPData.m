//  SDLOnEncodedSyncPData.m
//

#import "SDLOnEncodedSyncPData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnEncodedSyncPData

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnEncodedSyncPData]) {
    }
    return self;
}

- (void)setData:(NSArray<NSString *> *)data {
    [parameters sdl_setObject:data forName:SDLNameData];
}

- (NSArray<NSString *> *)data {
    return [parameters sdl_objectForName:SDLNameData];
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
