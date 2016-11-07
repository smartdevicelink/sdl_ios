//  SDLPresetBankCapabilities.m
//


#import "SDLPresetBankCapabilities.h"

#import "SDLNames.h"

@implementation SDLPresetBankCapabilities

- (void)setOnScreenPresetsAvailable:(NSNumber<SDLBool> *)onScreenPresetsAvailable {
    [self setObject:onScreenPresetsAvailable forName:SDLNameOnScreenPresetsAvailable];
}

- (NSNumber<SDLBool> *)onScreenPresetsAvailable {
    return [self objectForName:SDLNameOnScreenPresetsAvailable];
}

@end
