//  SDLHMISettingsControlData.m
//

#import "SDLHMISettingsControlData.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLHMISettingsControlData

- (instancetype)initWithDisplaymode:(SDLDisplayMode)displayMode temperatureUnit:(SDLTemperatureUnit)temperatureUnit distanceUnit:(SDLDistanceUnit)distanceUnit {
    self = [self init];
    if(!self) {
        return nil;
    }
    self.displayMode = displayMode;
    self.distanceUnit = distanceUnit;
    self.temperatureUnit = temperatureUnit;

    return self;
}

- (void)setDisplayMode:(nullable SDLDisplayMode)displayMode {
    [store sdl_setObject:displayMode forName:SDLRPCParameterNameDisplayMode];
}

- (nullable SDLDisplayMode)displayMode {
    return [store sdl_enumForName:SDLRPCParameterNameDisplayMode error:nil];
}

- (void)setDistanceUnit:(nullable SDLDistanceUnit)distanceUnit {
    [store sdl_setObject:distanceUnit forName:SDLRPCParameterNameDistanceUnit];
}

- (nullable SDLDistanceUnit)distanceUnit {
    return [store sdl_enumForName:SDLRPCParameterNameDistanceUnit error:nil];
}

- (void)setTemperatureUnit:(nullable SDLTemperatureUnit)temperatureUnit {
    [store sdl_setObject:temperatureUnit forName:SDLRPCParameterNameTemperatureUnit];
}

- (nullable SDLTemperatureUnit)temperatureUnit {
    return [store sdl_enumForName:SDLRPCParameterNameTemperatureUnit error:nil];
}

@end

NS_ASSUME_NONNULL_END
