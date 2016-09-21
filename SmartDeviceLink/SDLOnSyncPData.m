//  SDLOnSyncPData.m
//


#import "SDLOnSyncPData.h"



@implementation SDLOnSyncPData

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnSyncPData]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
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
