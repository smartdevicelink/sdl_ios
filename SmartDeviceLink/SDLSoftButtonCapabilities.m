//  SDLSoftButtonCapabilities.m
//


#import "SDLSoftButtonCapabilities.h"

#import "SDLNames.h"

@implementation SDLSoftButtonCapabilities

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

- (void)setImageSupported:(NSNumber<SDLBool> *)imageSupported {
    [self setObject:imageSupported forName:SDLNameImageSupported];
}

- (NSNumber<SDLBool> *)imageSupported {
    return [self objectForName:SDLNameImageSupported];
}

@end
