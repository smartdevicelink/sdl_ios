//
//  SDLTemperature.m
//

#import "SDLTemperature.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTemperature

- (instancetype)initWithUnit:(SDLTemperatureUnit)unit value:(float)value {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.unit = unit;
    self.value = @(value);
    
    return self;
}

- (void)setUnit:(SDLTemperatureUnit)unit {
    [store sdl_setObject:unit forName:SDLRPCParameterNameUnit];
}

- (SDLTemperatureUnit)unit {
    return [store sdl_objectForName:SDLRPCParameterNameUnit];
}

- (void)setValue:(NSNumber<SDLFloat> *)value {
    [store sdl_setObject:value forName:SDLRPCParameterNameValue];
}

- (NSNumber<SDLFloat> *)value {
    return [store sdl_objectForName:SDLRPCParameterNameValue];
}

@end

NS_ASSUME_NONNULL_END
