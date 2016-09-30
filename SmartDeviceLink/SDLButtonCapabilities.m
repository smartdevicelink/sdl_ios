//  SDLButtonCapabilities.m
//

#import "SDLButtonCapabilities.h"

#import "SDLButtonName.h"
#import "SDLNames.h"

@implementation SDLButtonCapabilities

- (void)setName:(SDLButtonName *)name {
    if (name != nil) {
        [store setObject:name forKey:SDLNameName];
    } else {
        [store removeObjectForKey:SDLNameName];
    }
}

- (SDLButtonName *)name {
    NSObject *obj = [store objectForKey:SDLNameName];
    if (obj == nil || [obj isKindOfClass:SDLButtonName.class]) {
        return (SDLButtonName *)obj;
    } else {
        return [SDLButtonName valueOf:(NSString *)obj];
    }
}

- (void)setShortPressAvailable:(NSNumber *)shortPressAvailable {
    if (shortPressAvailable != nil) {
        [store setObject:shortPressAvailable forKey:SDLNameShortPressAvailable];
    } else {
        [store removeObjectForKey:SDLNameShortPressAvailable];
    }
}

- (NSNumber *)shortPressAvailable {
    return [store objectForKey:SDLNameShortPressAvailable];
}

- (void)setLongPressAvailable:(NSNumber *)longPressAvailable {
    if (longPressAvailable != nil) {
        [store setObject:longPressAvailable forKey:SDLNameLongPressAvailable];
    } else {
        [store removeObjectForKey:SDLNameLongPressAvailable];
    }
}

- (NSNumber *)longPressAvailable {
    return [store objectForKey:SDLNameLongPressAvailable];
}

- (void)setUpDownAvailable:(NSNumber *)upDownAvailable {
    if (upDownAvailable != nil) {
        [store setObject:upDownAvailable forKey:SDLNameUpDownAvailable];
    } else {
        [store removeObjectForKey:SDLNameUpDownAvailable];
    }
}

- (NSNumber *)upDownAvailable {
    return [store objectForKey:SDLNameUpDownAvailable];
}

@end
