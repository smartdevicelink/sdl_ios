//  SDLPresetBankCapabilities.m
//


#import "SDLPresetBankCapabilities.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPresetBankCapabilities

- (void)setOnScreenPresetsAvailable:(NSNumber<SDLBool> *)onScreenPresetsAvailable {
    [store sdl_setObject:onScreenPresetsAvailable forName:SDLNameOnScreenPresetsAvailable];
}

- (NSNumber<SDLBool> *)onScreenPresetsAvailable {
    return [store sdl_objectForName:SDLNameOnScreenPresetsAvailable];
}

@end

NS_ASSUME_NONNULL_END
