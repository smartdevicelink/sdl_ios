//  SDLGPSData.m
//

#import "SDLGPSData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGPSData

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

- (void)setUtcYear:(NSNumber<SDLInt> *)utcYear {
    [store sdl_setObject:utcYear forName:SDLNameUTCYear];
}

- (NSNumber<SDLInt> *)utcYear {
    return [store sdl_objectForName:SDLNameUTCYear];
}

- (void)setUtcMonth:(NSNumber<SDLInt> *)utcMonth {
    [store sdl_setObject:utcMonth forName:SDLNameUTCMonth];
}

- (NSNumber<SDLInt> *)utcMonth {
    return [store sdl_objectForName:SDLNameUTCMonth];
}

- (void)setUtcDay:(NSNumber<SDLInt> *)utcDay {
    [store sdl_setObject:utcDay forName:SDLNameUTCDay];
}

- (NSNumber<SDLInt> *)utcDay {
    return [store sdl_objectForName:SDLNameUTCDay];
}

- (void)setUtcHours:(NSNumber<SDLInt> *)utcHours {
    [store sdl_setObject:utcHours forName:SDLNameUTCHours];
}

- (NSNumber<SDLInt> *)utcHours {
    return [store sdl_objectForName:SDLNameUTCHours];
}

- (void)setUtcMinutes:(NSNumber<SDLInt> *)utcMinutes {
    [store sdl_setObject:utcMinutes forName:SDLNameUTCMinutes];
}

- (NSNumber<SDLInt> *)utcMinutes {
    return [store sdl_objectForName:SDLNameUTCMinutes];
}

- (void)setUtcSeconds:(NSNumber<SDLInt> *)utcSeconds {
    [store sdl_setObject:utcSeconds forName:SDLNameUTCSeconds];
}

- (NSNumber<SDLInt> *)utcSeconds {
    return [store sdl_objectForName:SDLNameUTCSeconds];
}

- (void)setCompassDirection:(SDLCompassDirection)compassDirection {
    [store sdl_setObject:compassDirection forName:SDLNameCompassDirection];
}

- (SDLCompassDirection)compassDirection {
    return [store sdl_objectForName:SDLNameCompassDirection];
}

- (void)setPdop:(NSNumber<SDLFloat> *)pdop {
    [store sdl_setObject:pdop forName:SDLNamePDOP];
}

- (NSNumber<SDLFloat> *)pdop {
    return [store sdl_objectForName:SDLNamePDOP];
}

- (void)setHdop:(NSNumber<SDLFloat> *)hdop {
    [store sdl_setObject:hdop forName:SDLNameHDOP];
}

- (NSNumber<SDLFloat> *)hdop {
    return [store sdl_objectForName:SDLNameHDOP];
}

- (void)setVdop:(NSNumber<SDLFloat> *)vdop {
    [store sdl_setObject:vdop forName:SDLNameVDOP];
}

- (NSNumber<SDLFloat> *)vdop {
    return [store sdl_objectForName:SDLNameVDOP];
}

- (void)setActual:(NSNumber<SDLBool> *)actual {
    [store sdl_setObject:actual forName:SDLNameActual];
}

- (NSNumber<SDLBool> *)actual {
    return [store sdl_objectForName:SDLNameActual];
}

- (void)setSatellites:(NSNumber<SDLInt> *)satellites {
    [store sdl_setObject:satellites forName:SDLNameSatellites];
}

- (NSNumber<SDLInt> *)satellites {
    return [store sdl_objectForName:SDLNameSatellites];
}

- (void)setDimension:(SDLDimension)dimension {
    [store sdl_setObject:dimension forName:SDLNameDimension];
}

- (SDLDimension)dimension {
    return [store sdl_objectForName:SDLNameDimension];
}

- (void)setAltitude:(NSNumber<SDLFloat> *)altitude {
    [store sdl_setObject:altitude forName:SDLNameAltitude];
}

- (NSNumber<SDLFloat> *)altitude {
    return [store sdl_objectForName:SDLNameAltitude];
}

- (void)setHeading:(NSNumber<SDLFloat> *)heading {
    [store sdl_setObject:heading forName:SDLNameHeading];
}

- (NSNumber<SDLFloat> *)heading {
    return [store sdl_objectForName:SDLNameHeading];
}

- (void)setSpeed:(NSNumber<SDLFloat> *)speed {
    [store sdl_setObject:speed forName:SDLNameSpeed];
}

- (NSNumber<SDLFloat> *)speed {
    return [store sdl_objectForName:SDLNameSpeed];
}

@end

NS_ASSUME_NONNULL_END
