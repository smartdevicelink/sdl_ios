//  SDLPresetBankCapabilities.m
//


#import "SDLPresetBankCapabilities.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
