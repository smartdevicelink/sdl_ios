//  SDLGPSData.m
//

#import "SDLGPSData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGPSData

- (void)setLongitudeDegrees:(NSNumber<SDLFloat> *)longitudeDegrees {
    [self.store sdl_setObject:longitudeDegrees forName:SDLRPCParameterNameLongitudeDegrees];
}

- (NSNumber<SDLFloat> *)longitudeDegrees {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameLongitudeDegrees ofClass:NSNumber.class error:&error];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    [self.store sdl_setObject:latitudeDegrees forName:SDLRPCParameterNameLatitudeDegrees];
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameLatitudeDegrees ofClass:NSNumber.class error:&error];
}

- (void)setUtcYear:(nullable NSNumber<SDLInt> *)utcYear {
    [self.store sdl_setObject:utcYear forName:SDLRPCParameterNameUTCYear];
}

- (nullable NSNumber<SDLInt> *)utcYear {
    return [self.store sdl_objectForName:SDLRPCParameterNameUTCYear ofClass:NSNumber.class error:nil];
}

- (void)setUtcMonth:(nullable NSNumber<SDLInt> *)utcMonth {
    [self.store sdl_setObject:utcMonth forName:SDLRPCParameterNameUTCMonth];
}

- (nullable NSNumber<SDLInt> *)utcMonth {
    return [self.store sdl_objectForName:SDLRPCParameterNameUTCMonth ofClass:NSNumber.class error:nil];
}

- (void)setUtcDay:(nullable NSNumber<SDLInt> *)utcDay {
    [self.store sdl_setObject:utcDay forName:SDLRPCParameterNameUTCDay];
}

- (nullable NSNumber<SDLInt> *)utcDay {
    return [self.store sdl_objectForName:SDLRPCParameterNameUTCDay ofClass:NSNumber.class error:nil];
}

- (void)setUtcHours:(nullable NSNumber<SDLInt> *)utcHours {
    [self.store sdl_setObject:utcHours forName:SDLRPCParameterNameUTCHours];
}

- (nullable NSNumber<SDLInt> *)utcHours {
    return [self.store sdl_objectForName:SDLRPCParameterNameUTCHours ofClass:NSNumber.class error:nil];
}

- (void)setUtcMinutes:(nullable NSNumber<SDLInt> *)utcMinutes {
    [self.store sdl_setObject:utcMinutes forName:SDLRPCParameterNameUTCMinutes];
}

- (nullable NSNumber<SDLInt> *)utcMinutes {
    return [self.store sdl_objectForName:SDLRPCParameterNameUTCMinutes ofClass:NSNumber.class error:nil];
}

- (void)setUtcSeconds:(nullable NSNumber<SDLInt> *)utcSeconds {
    [self.store sdl_setObject:utcSeconds forName:SDLRPCParameterNameUTCSeconds];
}

- (nullable NSNumber<SDLInt> *)utcSeconds {
    return [self.store sdl_objectForName:SDLRPCParameterNameUTCSeconds ofClass:NSNumber.class error:nil];
}

- (void)setCompassDirection:(nullable SDLCompassDirection)compassDirection {
    [self.store sdl_setObject:compassDirection forName:SDLRPCParameterNameCompassDirection];
}

- (nullable SDLCompassDirection)compassDirection {
    return [self.store sdl_enumForName:SDLRPCParameterNameCompassDirection error:nil];
}

- (void)setPdop:(nullable NSNumber<SDLFloat> *)pdop {
    [self.store sdl_setObject:pdop forName:SDLRPCParameterNamePDOP];
}

- (nullable NSNumber<SDLFloat> *)pdop {
    return [self.store sdl_objectForName:SDLRPCParameterNamePDOP ofClass:NSNumber.class error:nil];
}

- (void)setHdop:(nullable NSNumber<SDLFloat> *)hdop {
    [self.store sdl_setObject:hdop forName:SDLRPCParameterNameHDOP];
}

- (nullable NSNumber<SDLFloat> *)hdop {
    return [self.store sdl_objectForName:SDLRPCParameterNameHDOP ofClass:NSNumber.class error:nil];
}

- (void)setVdop:(nullable NSNumber<SDLFloat> *)vdop {
    [self.store sdl_setObject:vdop forName:SDLRPCParameterNameVDOP];
}

- (nullable NSNumber<SDLFloat> *)vdop {
    return [self.store sdl_objectForName:SDLRPCParameterNameVDOP ofClass:NSNumber.class error:nil];
}

- (void)setActual:(nullable NSNumber<SDLBool> *)actual {
    [self.store sdl_setObject:actual forName:SDLRPCParameterNameActual];
}

- (nullable NSNumber<SDLBool> *)actual {
    return [self.store sdl_objectForName:SDLRPCParameterNameActual ofClass:NSNumber.class error:nil];
}

- (void)setSatellites:(nullable NSNumber<SDLInt> *)satellites {
    [self.store sdl_setObject:satellites forName:SDLRPCParameterNameSatellites];
}

- (nullable NSNumber<SDLInt> *)satellites {
    return [self.store sdl_objectForName:SDLRPCParameterNameSatellites ofClass:NSNumber.class error:nil];
}

- (void)setDimension:(nullable SDLDimension)dimension {
    [self.store sdl_setObject:dimension forName:SDLRPCParameterNameDimension];
}

- (nullable SDLDimension)dimension {
    return [self.store sdl_enumForName:SDLRPCParameterNameDimension error:nil];
}

- (void)setAltitude:(nullable NSNumber<SDLFloat> *)altitude {
    [self.store sdl_setObject:altitude forName:SDLRPCParameterNameAltitude];
}

- (nullable NSNumber<SDLFloat> *)altitude {
    return [self.store sdl_objectForName:SDLRPCParameterNameAltitude ofClass:NSNumber.class error:nil];
}

- (void)setHeading:(nullable NSNumber<SDLFloat> *)heading {
    [self.store sdl_setObject:heading forName:SDLRPCParameterNameHeading];
}

- (nullable NSNumber<SDLFloat> *)heading {
    return [self.store sdl_objectForName:SDLRPCParameterNameHeading ofClass:NSNumber.class error:nil];
}

- (void)setSpeed:(nullable NSNumber<SDLFloat> *)speed {
    [self.store sdl_setObject:speed forName:SDLRPCParameterNameSpeed];
}

- (nullable NSNumber<SDLFloat> *)speed {
    return [self.store sdl_objectForName:SDLRPCParameterNameSpeed ofClass:NSNumber.class error:nil];
}

- (void)setShifted:(nullable NSNumber<SDLBool> *)shifted {
    [self.store sdl_setObject:shifted forName:SDLRPCParameterNameShifted];
}

- (nullable NSNumber<SDLBool> *)shifted {
    return [self.store sdl_objectForName:SDLRPCParameterNameShifted ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
