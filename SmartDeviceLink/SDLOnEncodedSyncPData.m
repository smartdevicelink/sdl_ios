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

- (void)setData:(NSMutableArray *)data {
    if (data != nil) {
        [parameters setObject:data forKey:SDLNameData];
    } else {
        [parameters removeObjectForKey:SDLNameData];
    }
}

- (NSMutableArray *)data {
    return [parameters objectForKey:SDLNameData];
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

- (void)setTimeout:(NSNumber *)Timeout {
    if (Timeout != nil) {
        [parameters setObject:Timeout forKey:SDLNameTimeoutCapitalized];
    } else {
        [parameters removeObjectForKey:SDLNameTimeoutCapitalized];
    }
}

- (NSNumber *)Timeout {
    return [parameters objectForKey:SDLNameTimeoutCapitalized];
}

@end
