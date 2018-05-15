//  SDLHMISettingsControlData.m
//

#import "SDLHMISettingsControlData.h"
#import "SDLNames.h"
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
    [store sdl_setObject:displayMode forName:SDLNameDisplayMode];
}

- (nullable SDLDisplayMode)displayMode {
    return [store sdl_objectForName:SDLNameDisplayMode];
}

- (void)setDistanceUnit:(nullable SDLDistanceUnit)distanceUnit {
    [store sdl_setObject:distanceUnit forName:SDLNameDistanceUnit];
}

- (nullable SDLDistanceUnit)distanceUnit {
    return [store sdl_objectForName:SDLNameDistanceUnit];
}

- (void)setTemperatureUnit:(nullable SDLTemperatureUnit)temperatureUnit {
    [store sdl_setObject:temperatureUnit forName:SDLNameTemperatureUnit];
}

- (nullable SDLTemperatureUnit)temperatureUnit {
    return [store sdl_objectForName:SDLNameTemperatureUnit];
}



@end

NS_ASSUME_NONNULL_END
