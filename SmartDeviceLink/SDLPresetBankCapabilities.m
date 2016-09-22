//  SDLPresetBankCapabilities.m
//


#import "SDLPresetBankCapabilities.h"

#import "SDLNames.h"

@implementation SDLPresetBankCapabilities

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
