//  SDLTouchCoord.m
//


#import "SDLTouchCoord.h"

#import "SDLNames.h"

@implementation SDLTouchCoord

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setX:(NSNumber *)x {
    if (x != nil) {
        [store setObject:x forKey:SDLNameX];
    } else {
        [store removeObjectForKey:SDLNameX];
    }
}

- (NSNumber *)x {
    return [store objectForKey:SDLNameX];
}

- (void)setY:(NSNumber *)y {
    if (y != nil) {
        [store setObject:y forKey:SDLNameY];
    } else {
        [store removeObjectForKey:SDLNameY];
    }
}

- (NSNumber *)y {
    return [store objectForKey:SDLNameY];
}

@end
