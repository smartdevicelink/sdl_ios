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
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameLongitudeDegrees ofClass:NSNumber.class error:&error];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    [store sdl_setObject:latitudeDegrees forName:SDLRPCParameterNameLatitudeDegrees];
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameLatitudeDegrees ofClass:NSNumber.class error:&error];
}

- (void)setUtcYear:(nullable NSNumber<SDLInt> *)utcYear {
    [store sdl_setObject:utcYear forName:SDLRPCParameterNameUTCYear];
}

- (nullable NSNumber<SDLInt> *)utcYear {
    return [store sdl_objectForName:SDLRPCParameterNameUTCYear ofClass:NSNumber.class error:nil];
}

- (void)setUtcMonth:(nullable NSNumber<SDLInt> *)utcMonth {
    [store sdl_setObject:utcMonth forName:SDLRPCParameterNameUTCMonth];
}

- (nullable NSNumber<SDLInt> *)utcMonth {
    return [store sdl_objectForName:SDLRPCParameterNameUTCMonth ofClass:NSNumber.class error:nil];
}

- (void)setUtcDay:(nullable NSNumber<SDLInt> *)utcDay {
    [store sdl_setObject:utcDay forName:SDLRPCParameterNameUTCDay];
}

- (nullable NSNumber<SDLInt> *)utcDay {
    return [store sdl_objectForName:SDLRPCParameterNameUTCDay ofClass:NSNumber.class error:nil];
}

- (void)setUtcHours:(nullable NSNumber<SDLInt> *)utcHours {
    [store sdl_setObject:utcHours forName:SDLRPCParameterNameUTCHours];
}

- (nullable NSNumber<SDLInt> *)utcHours {
    return [store sdl_objectForName:SDLRPCParameterNameUTCHours ofClass:NSNumber.class error:nil];
}

- (void)setUtcMinutes:(nullable NSNumber<SDLInt> *)utcMinutes {
    [store sdl_setObject:utcMinutes forName:SDLRPCParameterNameUTCMinutes];
}

- (nullable NSNumber<SDLInt> *)utcMinutes {
    return [store sdl_objectForName:SDLRPCParameterNameUTCMinutes ofClass:NSNumber.class error:nil];
}

- (void)setUtcSeconds:(nullable NSNumber<SDLInt> *)utcSeconds {
    [store sdl_setObject:utcSeconds forName:SDLRPCParameterNameUTCSeconds];
}

- (nullable NSNumber<SDLInt> *)utcSeconds {
    return [store sdl_objectForName:SDLRPCParameterNameUTCSeconds ofClass:NSNumber.class error:nil];
}

- (void)setCompassDirection:(nullable SDLCompassDirection)compassDirection {
    [store sdl_setObject:compassDirection forName:SDLRPCParameterNameCompassDirection];
}

- (nullable SDLCompassDirection)compassDirection {
    return [store sdl_enumForName:SDLRPCParameterNameCompassDirection error:nil];
}

- (void)setPdop:(nullable NSNumber<SDLFloat> *)pdop {
    [store sdl_setObject:pdop forName:SDLRPCParameterNamePDOP];
}

- (nullable NSNumber<SDLFloat> *)pdop {
    return [store sdl_objectForName:SDLRPCParameterNamePDOP ofClass:NSNumber.class error:nil];
}

- (void)setHdop:(nullable NSNumber<SDLFloat> *)hdop {
    [store sdl_setObject:hdop forName:SDLRPCParameterNameHDOP];
}

- (nullable NSNumber<SDLFloat> *)hdop {
    return [store sdl_objectForName:SDLRPCParameterNameHDOP ofClass:NSNumber.class error:nil];
}

- (void)setVdop:(nullable NSNumber<SDLFloat> *)vdop {
    [store sdl_setObject:vdop forName:SDLRPCParameterNameVDOP];
}

- (nullable NSNumber<SDLFloat> *)vdop {
    return [store sdl_objectForName:SDLRPCParameterNameVDOP ofClass:NSNumber.class error:nil];
}

- (void)setActual:(nullable NSNumber<SDLBool> *)actual {
    [store sdl_setObject:actual forName:SDLRPCParameterNameActual];
}

- (nullable NSNumber<SDLBool> *)actual {
    return [store sdl_objectForName:SDLRPCParameterNameActual ofClass:NSNumber.class error:nil];
}

- (void)setSatellites:(nullable NSNumber<SDLInt> *)satellites {
    [store sdl_setObject:satellites forName:SDLRPCParameterNameSatellites];
}

- (nullable NSNumber<SDLInt> *)satellites {
    return [store sdl_objectForName:SDLRPCParameterNameSatellites ofClass:NSNumber.class error:nil];
}

- (void)setDimension:(nullable SDLDimension)dimension {
    [store sdl_setObject:dimension forName:SDLRPCParameterNameDimension];
}

- (nullable SDLDimension)dimension {
    return [store sdl_enumForName:SDLRPCParameterNameDimension error:nil];
}

- (void)setAltitude:(nullable NSNumber<SDLFloat> *)altitude {
    [store sdl_setObject:altitude forName:SDLRPCParameterNameAltitude];
}

- (nullable NSNumber<SDLFloat> *)altitude {
    return [store sdl_objectForName:SDLRPCParameterNameAltitude ofClass:NSNumber.class error:nil];
}

- (void)setHeading:(nullable NSNumber<SDLFloat> *)heading {
    [store sdl_setObject:heading forName:SDLRPCParameterNameHeading];
}

- (nullable NSNumber<SDLFloat> *)heading {
    return [store sdl_objectForName:SDLRPCParameterNameHeading ofClass:NSNumber.class error:nil];
}

- (void)setSpeed:(nullable NSNumber<SDLFloat> *)speed {
    [store sdl_setObject:speed forName:SDLRPCParameterNameSpeed];
}

- (nullable NSNumber<SDLFloat> *)speed {
    return [store sdl_objectForName:SDLRPCParameterNameSpeed ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
