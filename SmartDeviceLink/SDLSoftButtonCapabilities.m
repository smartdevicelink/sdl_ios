//  SDLSoftButtonCapabilities.m
//


#import "SDLSoftButtonCapabilities.h"



@implementation SDLSoftButtonCapabilities

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
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

- (void)setImageSupported:(NSNumber *)imageSupported {
    if (imageSupported != nil) {
        [store setObject:imageSupported forKey:SDLNameImageSupported];
    } else {
        [store removeObjectForKey:SDLNameImageSupported];
    }
}

- (NSNumber *)imageSupported {
    return [store objectForKey:SDLNameImageSupported];
}

@end
