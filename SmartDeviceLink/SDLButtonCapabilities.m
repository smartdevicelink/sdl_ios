//  SDLButtonCapabilities.m
//

#import "SDLButtonCapabilities.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLButtonCapabilities

- (void)setName:(SDLButtonName)name {
    if (name != nil) {
        [store setObject:name forKey:SDLNameName];
    } else {
        [store removeObjectForKey:SDLNameName];
    }
}

- (SDLButtonName)name {
    NSObject *obj = [store objectForKey:SDLNameName];
    return (SDLButtonName)obj;
}

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

@end

NS_ASSUME_NONNULL_END
