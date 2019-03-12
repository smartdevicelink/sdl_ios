//  SDLGPSData.m
//

#import "SDLGPSData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGPSData

- (void)setLongitudeDegrees:(NSNumber<SDLFloat> *)longitudeDegrees {
    [store sdl_setObject:longitudeDegrees forName:SDLRPCParameterNameLongitudeDegrees];
}

- (NSNumber<SDLFloat> *)longitudeDegrees {
    return [store sdl_objectForName:SDLRPCParameterNameLongitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    [store sdl_setObject:latitudeDegrees forName:SDLRPCParameterNameLatitudeDegrees];
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    return [store sdl_objectForName:SDLRPCParameterNameLatitudeDegrees];
}

- (void)setUtcYear:(nullable NSNumber<SDLInt> *)utcYear {
    [store sdl_setObject:utcYear forName:SDLRPCParameterNameUTCYear];
}

- (nullable NSNumber<SDLInt> *)utcYear {
    return [store sdl_objectForName:SDLRPCParameterNameUTCYear];
}

- (void)setUtcMonth:(nullable NSNumber<SDLInt> *)utcMonth {
    [store sdl_setObject:utcMonth forName:SDLRPCParameterNameUTCMonth];
}

- (nullable NSNumber<SDLInt> *)utcMonth {
    return [store sdl_objectForName:SDLRPCParameterNameUTCMonth];
}

- (void)setUtcDay:(nullable NSNumber<SDLInt> *)utcDay {
    [store sdl_setObject:utcDay forName:SDLRPCParameterNameUTCDay];
}

- (nullable NSNumber<SDLInt> *)utcDay {
    return [store sdl_objectForName:SDLRPCParameterNameUTCDay];
}

- (void)setUtcHours:(nullable NSNumber<SDLInt> *)utcHours {
    [store sdl_setObject:utcHours forName:SDLRPCParameterNameUTCHours];
}

- (nullable NSNumber<SDLInt> *)utcHours {
    return [store sdl_objectForName:SDLRPCParameterNameUTCHours];
}

- (void)setUtcMinutes:(nullable NSNumber<SDLInt> *)utcMinutes {
    [store sdl_setObject:utcMinutes forName:SDLRPCParameterNameUTCMinutes];
}

- (nullable NSNumber<SDLInt> *)utcMinutes {
    return [store sdl_objectForName:SDLRPCParameterNameUTCMinutes];
}

- (void)setUtcSeconds:(nullable NSNumber<SDLInt> *)utcSeconds {
    [store sdl_setObject:utcSeconds forName:SDLRPCParameterNameUTCSeconds];
}

- (nullable NSNumber<SDLInt> *)utcSeconds {
    return [store sdl_objectForName:SDLRPCParameterNameUTCSeconds];
}

- (void)setCompassDirection:(nullable SDLCompassDirection)compassDirection {
    [store sdl_setObject:compassDirection forName:SDLRPCParameterNameCompassDirection];
}

- (nullable SDLCompassDirection)compassDirection {
    return [store sdl_objectForName:SDLRPCParameterNameCompassDirection];
}

- (void)setPdop:(nullable NSNumber<SDLFloat> *)pdop {
    [store sdl_setObject:pdop forName:SDLRPCParameterNamePDOP];
}

- (nullable NSNumber<SDLFloat> *)pdop {
    return [store sdl_objectForName:SDLRPCParameterNamePDOP];
}

- (void)setHdop:(nullable NSNumber<SDLFloat> *)hdop {
    [store sdl_setObject:hdop forName:SDLRPCParameterNameHDOP];
}

- (nullable NSNumber<SDLFloat> *)hdop {
    return [store sdl_objectForName:SDLRPCParameterNameHDOP];
}

- (void)setVdop:(nullable NSNumber<SDLFloat> *)vdop {
    [store sdl_setObject:vdop forName:SDLRPCParameterNameVDOP];
}

- (nullable NSNumber<SDLFloat> *)vdop {
    return [store sdl_objectForName:SDLRPCParameterNameVDOP];
}

- (void)setActual:(nullable NSNumber<SDLBool> *)actual {
    [store sdl_setObject:actual forName:SDLRPCParameterNameActual];
}

- (nullable NSNumber<SDLBool> *)actual {
    return [store sdl_objectForName:SDLRPCParameterNameActual];
}

- (void)setSatellites:(nullable NSNumber<SDLInt> *)satellites {
    [store sdl_setObject:satellites forName:SDLRPCParameterNameSatellites];
}

- (nullable NSNumber<SDLInt> *)satellites {
    return [store sdl_objectForName:SDLRPCParameterNameSatellites];
}

- (void)setDimension:(nullable SDLDimension)dimension {
    [store sdl_setObject:dimension forName:SDLRPCParameterNameDimension];
}

- (nullable SDLDimension)dimension {
    return [store sdl_objectForName:SDLRPCParameterNameDimension];
}

- (void)setAltitude:(nullable NSNumber<SDLFloat> *)altitude {
    [store sdl_setObject:altitude forName:SDLRPCParameterNameAltitude];
}

- (nullable NSNumber<SDLFloat> *)altitude {
    return [store sdl_objectForName:SDLRPCParameterNameAltitude];
}

- (void)setHeading:(nullable NSNumber<SDLFloat> *)heading {
    [store sdl_setObject:heading forName:SDLRPCParameterNameHeading];
}

- (nullable NSNumber<SDLFloat> *)heading {
    return [store sdl_objectForName:SDLRPCParameterNameHeading];
}

- (void)setSpeed:(nullable NSNumber<SDLFloat> *)speed {
    [store sdl_setObject:speed forName:SDLRPCParameterNameSpeed];
}

- (nullable NSNumber<SDLFloat> *)speed {
    return [store sdl_objectForName:SDLRPCParameterNameSpeed];
}

@end

NS_ASSUME_NONNULL_END
