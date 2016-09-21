//  SDLOnEncodedSyncPData.m
//

#import "SDLOnEncodedSyncPData.h"




@implementation SDLOnEncodedSyncPData

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnEncodedSyncPData]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
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
        [parameters setObject:URL forKey:SDLNameUrlUppercase];
    } else {
        [parameters removeObjectForKey:SDLNameUrlUppercase];
    }
}

- (NSString *)URL {
    return [parameters objectForKey:SDLNameUrlUppercase];
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
