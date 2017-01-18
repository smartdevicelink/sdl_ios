//  SDLTouchEventCapabilities.m
//


#import "SDLTouchEventCapabilities.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTouchEventCapabilities

- (void)setPressAvailable:(NSNumber<SDLBool> *)pressAvailable {
    if (pressAvailable != nil) {
        [store setObject:pressAvailable forKey:SDLNamePressAvailable];
    } else {
        [store removeObjectForKey:SDLNamePressAvailable];
    }
}

- (NSNumber<SDLBool> *)pressAvailable {
    return [store objectForKey:SDLNamePressAvailable];
}

- (void)setMultiTouchAvailable:(NSNumber<SDLBool> *)multiTouchAvailable {
    if (multiTouchAvailable != nil) {
        [store setObject:multiTouchAvailable forKey:SDLNameMultiTouchAvailable];
    } else {
        [store removeObjectForKey:SDLNameMultiTouchAvailable];
    }
}

- (NSNumber<SDLBool> *)multiTouchAvailable {
    return [store objectForKey:SDLNameMultiTouchAvailable];
}

- (void)setDoublePressAvailable:(NSNumber<SDLBool> *)doublePressAvailable {
    if (doublePressAvailable != nil) {
        [store setObject:doublePressAvailable forKey:SDLNameDoublePressAvailable];
    } else {
        [store removeObjectForKey:SDLNameDoublePressAvailable];
    }
}

- (NSNumber<SDLBool> *)doublePressAvailable {
    return [store objectForKey:SDLNameDoublePressAvailable];
}

@end

NS_ASSUME_NONNULL_END
