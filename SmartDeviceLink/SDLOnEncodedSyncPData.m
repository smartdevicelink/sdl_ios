//  SDLOnEncodedSyncPData.m
//

#import "SDLOnEncodedSyncPData.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnEncodedSyncPData

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnEncodedSyncPData]) {
    }
    return self;
}

- (void)setData:(NSMutableArray<NSString *> *)data {
    if (data != nil) {
        [parameters setObject:data forKey:SDLNameData];
    } else {
        [parameters removeObjectForKey:SDLNameData];
    }
}

- (NSMutableArray<NSString *> *)data {
    return [parameters objectForKey:SDLNameData];
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
