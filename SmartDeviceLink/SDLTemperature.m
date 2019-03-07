//
//  SDLTemperature.m
//

#import "SDLTemperature.h"
#import "SDLNames.h"
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
    [store sdl_setObject:unit forName:SDLNameUnit];
}

- (SDLTemperatureUnit)unit {
    NSError *error;
    return [store sdl_enumForName:SDLNameUnit error:&error];
}

- (void)setValue:(NSNumber<SDLFloat> *)value {
    [store sdl_setObject:value forName:SDLNameValue];
}

- (NSNumber<SDLFloat> *)value {
    NSError *error;
    return [store sdl_objectForName:SDLNameValue ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
