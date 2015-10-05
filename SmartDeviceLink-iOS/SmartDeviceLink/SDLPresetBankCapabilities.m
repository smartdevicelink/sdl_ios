//  SDLPresetBankCapabilities.m
//


#import "SDLPresetBankCapabilities.h"

#import "SDLNames.h"

@implementation SDLPresetBankCapabilities

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

- (void)setOnScreenPresetsAvailable:(NSNumber *)onScreenPresetsAvailable {
    if (onScreenPresetsAvailable != nil) {
        [store setObject:onScreenPresetsAvailable forKey:NAMES_onScreenPresetsAvailable];
    } else {
        [store removeObjectForKey:NAMES_onScreenPresetsAvailable];
    }
}

- (NSNumber *)onScreenPresetsAvailable {
    return [store objectForKey:NAMES_onScreenPresetsAvailable];
}

@end
