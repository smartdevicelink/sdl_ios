//  SDLStartTime.m
//


#import "SDLStartTime.h"

#import "SDLNames.h"

@implementation SDLStartTime

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setHours:(NSNumber *)hours {
    if (hours != nil) {
        [store setObject:hours forKey:SDLNameHours];
    } else {
        [store removeObjectForKey:SDLNameHours];
    }
}

- (NSNumber *)hours {
    return [store objectForKey:SDLNameHours];
}

- (void)setMinutes:(NSNumber *)minutes {
    if (minutes != nil) {
        [store setObject:minutes forKey:SDLNameMinutes];
    } else {
        [store removeObjectForKey:SDLNameMinutes];
    }
}

- (NSNumber *)minutes {
    return [store objectForKey:SDLNameMinutes];
}

- (void)setSeconds:(NSNumber *)seconds {
    if (seconds != nil) {
        [store setObject:seconds forKey:SDLNameSeconds];
    } else {
        [store removeObjectForKey:SDLNameSeconds];
    }
}

- (NSNumber *)seconds {
    return [store objectForKey:SDLNameSeconds];
}

@end
