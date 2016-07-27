//  SDLButtonCapabilities.m
//

#import "SDLButtonCapabilities.h"

#import "SDLButtonName.h"
#import "SDLNames.h"


@implementation SDLButtonCapabilities

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

- (void)setName:(SDLButtonName *)name {
    if (name != nil) {
        [store setObject:name forKey:NAMES_name];
    } else {
        [store removeObjectForKey:NAMES_name];
    }
}

- (SDLButtonName *)name {
    NSObject *obj = [store objectForKey:NAMES_name];
    if (obj == nil || [obj isKindOfClass:SDLButtonName.class]) {
        return (SDLButtonName *)obj;
    } else {
        return [SDLButtonName valueOf:(NSString *)obj];
    }
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

@end
