//
//  SDLTemperature.m
//

#import "SDLTemperature.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTemperature

- (instancetype)initWithFahrenheitValue:(float)value {
    return [self initWithUnit:SDLTemperatureUnitFahrenheit value:value];
}

- (instancetype)initWithCelsiusValue:(float)value {
    return [self initWithUnit:SDLTemperatureUnitCelsius value:value];
}

- (instancetype)initWithUnit:(SDLTemperatureUnit)unit value:(float)value {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.unit = unit;
    self.value = @(value);
    
    return self;
}

- (void)setUnit:(SDLTemperatureUnit)unit {
    [self.store sdl_setObject:unit forName:SDLRPCParameterNameUnit];
}

- (SDLTemperatureUnit)unit {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameUnit error:&error];
}

- (void)setValue:(NSNumber<SDLFloat> *)value {
    [self.store sdl_setObject:value forName:SDLRPCParameterNameValue];
}

- (NSNumber<SDLFloat> *)value {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameValue ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
