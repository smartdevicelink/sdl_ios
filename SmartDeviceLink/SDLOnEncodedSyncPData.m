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
    [self setObject:data forName:SDLNameData];
}

- (NSMutableArray<NSString *> *)data {
    return [parameters objectForKey:SDLNameData];
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
