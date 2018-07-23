//  SDLGPSLocation.m
//

#import "SDLGPSLocation.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGPSLocation

- (instancetype)initWithLatitudeDegrees:(double)latitude LongitudeDegrees:(double)longitude {
    self = [self init];
    if(!self) {
        return nil;
    }

    self.latitudeDegrees = @(latitude);
    self.longitudeDegrees = @(longitude);

    return self;
}

-(instancetype)initWithLatitudeDegrees:(double)latitude LongitudeDegrees:(double)longitude altitudeMeter:(nullable NSNumber<SDLFloat> *)altitudeMeters {
    self = [self init];
    if(!self) {
        return nil;
    }

    self.latitudeDegrees = @(latitude);
    self.longitudeDegrees = @(longitude);
    self.altitudeMeters = altitudeMeters;

    return self;
}

- (void)setLongitudeDegrees:(NSNumber<SDLFloat> *)longitudeDegrees {
    [store sdl_setObject:longitudeDegrees forName:SDLNameLongitudeDegrees];
}

- (NSNumber<SDLFloat> *)longitudeDegrees {
    return [store sdl_objectForName:SDLNameLongitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    [store sdl_setObject:latitudeDegrees forName:SDLNameLatitudeDegrees];
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    return [store sdl_objectForName:SDLNameLatitudeDegrees];
}
- (void)setAltitudeMeters:(nullable NSNumber<SDLFloat> *)altitudeMeters {
    [store sdl_setObject:altitudeMeters forName:SDLNameAltitudeMeters];
}

- (nullable NSNumber<SDLFloat> *)altitudeMeters {
    return [store sdl_objectForName:SDLNameAltitudeMeters];
}

@end

NS_ASSUME_NONNULL_END
