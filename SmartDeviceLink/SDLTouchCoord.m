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
        [store setObject:x forKey:NAMES_x];
    } else {
        [store removeObjectForKey:NAMES_x];
    }
}

- (NSNumber *)x {
    return [store objectForKey:NAMES_x];
}

- (void)setY:(NSNumber *)y {
    if (y != nil) {
        [store setObject:y forKey:NAMES_y];
    } else {
        [store removeObjectForKey:NAMES_y];
    }
}

- (NSNumber *)y {
    return [store objectForKey:NAMES_y];
}

@end
