//  SDLPresetBankCapabilities.m
//


#import "SDLPresetBankCapabilities.h"



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
        [store setObject:onScreenPresetsAvailable forKey:SDLNameOnScreenPresetsAvailable];
    } else {
        [store removeObjectForKey:SDLNameOnScreenPresetsAvailable];
    }
}

- (NSNumber *)onScreenPresetsAvailable {
    return [store objectForKey:SDLNameOnScreenPresetsAvailable];
}

@end
