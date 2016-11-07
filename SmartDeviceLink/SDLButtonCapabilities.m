//  SDLButtonCapabilities.m
//

#import "SDLButtonCapabilities.h"

#import "SDLNames.h"

@implementation SDLButtonCapabilities

- (void)setName:(SDLButtonName)name {
    [self setObject:name forName:SDLNameName];
}

- (SDLButtonName)name {
    return [self objectForName:SDLNameName];
}

- (void)setShortPressAvailable:(NSNumber<SDLBool> *)shortPressAvailable {
    [self setObject:shortPressAvailable forName:SDLNameShortPressAvailable];
}

- (NSNumber<SDLBool> *)shortPressAvailable {
    return [self objectForName:SDLNameShortPressAvailable];
}

- (void)setLongPressAvailable:(NSNumber<SDLBool> *)longPressAvailable {
    [self setObject:longPressAvailable forName:SDLNameLongPressAvailable];
}

- (NSNumber<SDLBool> *)longPressAvailable {
    return [self objectForName:SDLNameLongPressAvailable];
}

- (void)setUpDownAvailable:(NSNumber<SDLBool> *)upDownAvailable {
    [self setObject:upDownAvailable forName:SDLNameUpDownAvailable];
}

- (NSNumber<SDLBool> *)upDownAvailable {
    return [self objectForName:SDLNameUpDownAvailable];
}

@end
