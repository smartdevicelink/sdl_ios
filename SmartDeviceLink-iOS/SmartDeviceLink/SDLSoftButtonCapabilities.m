//  SDLSoftButtonCapabilities.m
//


#import "SDLSoftButtonCapabilities.h"

#import "SDLNames.h"

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
        [store setObject:shortPressAvailable forKey:NAMES_shortPressAvailable];
    } else {
        [store removeObjectForKey:NAMES_shortPressAvailable];
    }
}

- (NSNumber *)shortPressAvailable {
    return [store objectForKey:NAMES_shortPressAvailable];
}

- (void)setLongPressAvailable:(NSNumber *)longPressAvailable {
    if (longPressAvailable != nil) {
        [store setObject:longPressAvailable forKey:NAMES_longPressAvailable];
    } else {
        [store removeObjectForKey:NAMES_longPressAvailable];
    }
}

- (NSNumber *)longPressAvailable {
    return [store objectForKey:NAMES_longPressAvailable];
}

- (void)setUpDownAvailable:(NSNumber *)upDownAvailable {
    if (upDownAvailable != nil) {
        [store setObject:upDownAvailable forKey:NAMES_upDownAvailable];
    } else {
        [store removeObjectForKey:NAMES_upDownAvailable];
    }
}

- (NSNumber *)upDownAvailable {
    return [store objectForKey:NAMES_upDownAvailable];
}

- (void)setImageSupported:(NSNumber *)imageSupported {
    if (imageSupported != nil) {
        [store setObject:imageSupported forKey:NAMES_imageSupported];
    } else {
        [store removeObjectForKey:NAMES_imageSupported];
    }
}

- (NSNumber *)imageSupported {
    return [store objectForKey:NAMES_imageSupported];
}

@end
