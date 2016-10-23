//  SDLTouchCoord.m
//


#import "SDLTouchCoord.h"

#import "SDLNames.h"

@implementation SDLTouchCoord

- (void)setX:(NSNumber<SDLFloat> *)x {
    if (x != nil) {
        [store setObject:x forKey:SDLNameX];
    } else {
        [store removeObjectForKey:SDLNameX];
    }
}

- (NSNumber<SDLFloat> *)x {
    return [store objectForKey:SDLNameX];
}

- (void)setY:(NSNumber<SDLFloat> *)y {
    if (y != nil) {
        [store setObject:y forKey:SDLNameY];
    } else {
        [store removeObjectForKey:SDLNameY];
    }
}

- (NSNumber<SDLFloat> *)y {
    return [store objectForKey:SDLNameY];
}

@end
