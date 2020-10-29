//  SDLPresetBankCapabilities.m
//


#import "SDLPresetBankCapabilities.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPresetBankCapabilities

- (instancetype)initWithOnScreenPresetsAvailable:(BOOL)onScreenPresetsAvailable {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.onScreenPresetsAvailable = @(onScreenPresetsAvailable);
    return self;
}

- (void)setOnScreenPresetsAvailable:(NSNumber<SDLBool> *)onScreenPresetsAvailable {
    [self.store sdl_setObject:onScreenPresetsAvailable forName:SDLRPCParameterNameOnScreenPresetsAvailable];
}

- (NSNumber<SDLBool> *)onScreenPresetsAvailable {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameOnScreenPresetsAvailable ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
