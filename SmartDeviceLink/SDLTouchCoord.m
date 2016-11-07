//  SDLTouchCoord.m
//


#import "SDLTouchCoord.h"

#import "SDLNames.h"

@implementation SDLTouchCoord

- (void)setX:(NSNumber<SDLFloat> *)x {
    [self setObject:x forName:SDLNameX];
}

- (NSNumber<SDLFloat> *)x {
    return [self objectForName:SDLNameX];
}

- (void)setY:(NSNumber<SDLFloat> *)y {
    [self setObject:y forName:SDLNameY];
}

- (NSNumber<SDLFloat> *)y {
    return [self objectForName:SDLNameY];
}

@end
