//  SDLSoftButtonCapabilities.m
//


#import "SDLSoftButtonCapabilities.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSoftButtonCapabilities

- (void)setShortPressAvailable:(NSNumber<SDLBool> *)shortPressAvailable {
    if (shortPressAvailable != nil) {
        [store setObject:shortPressAvailable forKey:SDLNameShortPressAvailable];
    } else {
        [store removeObjectForKey:SDLNameShortPressAvailable];
    }
}

- (NSNumber<SDLBool> *)shortPressAvailable {
    return [store objectForKey:SDLNameShortPressAvailable];
}

- (void)setLongPressAvailable:(NSNumber<SDLBool> *)longPressAvailable {
    if (longPressAvailable != nil) {
        [store setObject:longPressAvailable forKey:SDLNameLongPressAvailable];
    } else {
        [store removeObjectForKey:SDLNameLongPressAvailable];
    }
}

- (NSNumber<SDLBool> *)longPressAvailable {
    return [store objectForKey:SDLNameLongPressAvailable];
}

- (void)setUpDownAvailable:(NSNumber<SDLBool> *)upDownAvailable {
    if (upDownAvailable != nil) {
        [store setObject:upDownAvailable forKey:SDLNameUpDownAvailable];
    } else {
        [store removeObjectForKey:SDLNameUpDownAvailable];
    }
}

- (NSNumber<SDLBool> *)upDownAvailable {
    return [store objectForKey:SDLNameUpDownAvailable];
}

- (void)setImageSupported:(NSNumber<SDLBool> *)imageSupported {
    if (imageSupported != nil) {
        [store setObject:imageSupported forKey:SDLNameImageSupported];
    } else {
        [store removeObjectForKey:SDLNameImageSupported];
    }
}

- (NSNumber<SDLBool> *)imageSupported {
    return [store objectForKey:SDLNameImageSupported];
}

@end

NS_ASSUME_NONNULL_END
