//  SDLPresetBankCapabilities.m
//


#import "SDLPresetBankCapabilities.h"

#import "SDLNames.h"

@implementation SDLPresetBankCapabilities

- (void)setOnScreenPresetsAvailable:(NSNumber<SDLBool> *)onScreenPresetsAvailable {
    if (onScreenPresetsAvailable != nil) {
        [store setObject:onScreenPresetsAvailable forKey:SDLNameOnScreenPresetsAvailable];
    } else {
        [store removeObjectForKey:SDLNameOnScreenPresetsAvailable];
    }
}

- (NSNumber<SDLBool> *)onScreenPresetsAvailable {
    return [store objectForKey:SDLNameOnScreenPresetsAvailable];
}

@end
