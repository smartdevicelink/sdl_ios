//  SDLTouchEventCapabilities.m
//


#import "SDLTouchEventCapabilities.h"

#import "SDLNames.h"

@implementation SDLTouchEventCapabilities

- (void)setPressAvailable:(NSNumber *)pressAvailable {
    if (pressAvailable != nil) {
        [store setObject:pressAvailable forKey:SDLNamePressAvailable];
    } else {
        [store removeObjectForKey:SDLNamePressAvailable];
    }
}

- (NSNumber *)pressAvailable {
    return [store objectForKey:SDLNamePressAvailable];
}

- (void)setMultiTouchAvailable:(NSNumber *)multiTouchAvailable {
    if (multiTouchAvailable != nil) {
        [store setObject:multiTouchAvailable forKey:SDLNameMultiTouchAvailable];
    } else {
        [store removeObjectForKey:SDLNameMultiTouchAvailable];
    }
}

- (NSNumber *)multiTouchAvailable {
    return [store objectForKey:SDLNameMultiTouchAvailable];
}

- (void)setDoublePressAvailable:(NSNumber *)doublePressAvailable {
    if (doublePressAvailable != nil) {
        [store setObject:doublePressAvailable forKey:SDLNameDoublePressAvailable];
    } else {
        [store removeObjectForKey:SDLNameDoublePressAvailable];
    }
}

- (NSNumber *)doublePressAvailable {
    return [store objectForKey:SDLNameDoublePressAvailable];
}

@end
