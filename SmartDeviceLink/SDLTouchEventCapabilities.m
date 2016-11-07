//  SDLTouchEventCapabilities.m
//


#import "SDLTouchEventCapabilities.h"

#import "SDLNames.h"

@implementation SDLTouchEventCapabilities

- (void)setPressAvailable:(NSNumber<SDLBool> *)pressAvailable {
    [self setObject:pressAvailable forName:SDLNamePressAvailable];
}

- (NSNumber<SDLBool> *)pressAvailable {
    return [self objectForName:SDLNamePressAvailable];
}

- (void)setMultiTouchAvailable:(NSNumber<SDLBool> *)multiTouchAvailable {
    [self setObject:multiTouchAvailable forName:SDLNameMultiTouchAvailable];
}

- (NSNumber<SDLBool> *)multiTouchAvailable {
    return [self objectForName:SDLNameMultiTouchAvailable];
}

- (void)setDoublePressAvailable:(NSNumber<SDLBool> *)doublePressAvailable {
    [self setObject:doublePressAvailable forName:SDLNameDoublePressAvailable];
}

- (NSNumber<SDLBool> *)doublePressAvailable {
    return [self objectForName:SDLNameDoublePressAvailable];
}

@end
