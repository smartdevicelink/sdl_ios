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
    NSError *error;
    return [store sdl_objectForName:SDLNameLongitudeDegrees ofClass:NSNumber.class error:&error];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    [store sdl_setObject:latitudeDegrees forName:SDLNameLatitudeDegrees];
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    NSError *error;
    return [store sdl_objectForName:SDLNameLatitudeDegrees ofClass:NSNumber.class error:&error];
}

- (void)setUtcYear:(nullable NSNumber<SDLInt> *)utcYear {
    [store sdl_setObject:utcYear forName:SDLNameUTCYear];
}

- (nullable NSNumber<SDLInt> *)utcYear {
    return [store sdl_objectForName:SDLNameUTCYear ofClass:NSNumber.class];
}

- (void)setUtcMonth:(nullable NSNumber<SDLInt> *)utcMonth {
    [store sdl_setObject:utcMonth forName:SDLNameUTCMonth];
}

- (nullable NSNumber<SDLInt> *)utcMonth {
    return [store sdl_objectForName:SDLNameUTCMonth ofClass:NSNumber.class];
}

- (void)setUtcDay:(nullable NSNumber<SDLInt> *)utcDay {
    [store sdl_setObject:utcDay forName:SDLNameUTCDay];
}

- (nullable NSNumber<SDLInt> *)utcDay {
    return [store sdl_objectForName:SDLNameUTCDay ofClass:NSNumber.class];
}

- (void)setUtcHours:(nullable NSNumber<SDLInt> *)utcHours {
    [store sdl_setObject:utcHours forName:SDLNameUTCHours];
}

- (nullable NSNumber<SDLInt> *)utcHours {
    return [store sdl_objectForName:SDLNameUTCHours ofClass:NSNumber.class];
}

- (void)setUtcMinutes:(nullable NSNumber<SDLInt> *)utcMinutes {
    [store sdl_setObject:utcMinutes forName:SDLNameUTCMinutes];
}

- (nullable NSNumber<SDLInt> *)utcMinutes {
    return [store sdl_objectForName:SDLNameUTCMinutes ofClass:NSNumber.class];
}

- (void)setUtcSeconds:(nullable NSNumber<SDLInt> *)utcSeconds {
    [store sdl_setObject:utcSeconds forName:SDLNameUTCSeconds];
}

- (nullable NSNumber<SDLInt> *)utcSeconds {
    return [store sdl_objectForName:SDLNameUTCSeconds ofClass:NSNumber.class];
}

- (void)setCompassDirection:(nullable SDLCompassDirection)compassDirection {
    [store sdl_setObject:compassDirection forName:SDLNameCompassDirection];
}

- (nullable SDLCompassDirection)compassDirection {
    return [store sdl_enumForName:SDLNameCompassDirection];
}

- (void)setPdop:(nullable NSNumber<SDLFloat> *)pdop {
    [store sdl_setObject:pdop forName:SDLNamePDOP];
}

- (nullable NSNumber<SDLFloat> *)pdop {
    return [store sdl_objectForName:SDLNamePDOP ofClass:NSNumber.class];
}

- (void)setHdop:(nullable NSNumber<SDLFloat> *)hdop {
    [store sdl_setObject:hdop forName:SDLNameHDOP];
}

- (nullable NSNumber<SDLFloat> *)hdop {
    return [store sdl_objectForName:SDLNameHDOP ofClass:NSNumber.class];
}

- (void)setVdop:(nullable NSNumber<SDLFloat> *)vdop {
    [store sdl_setObject:vdop forName:SDLNameVDOP];
}

- (nullable NSNumber<SDLFloat> *)vdop {
    return [store sdl_objectForName:SDLNameVDOP ofClass:NSNumber.class];
}

- (void)setActual:(nullable NSNumber<SDLBool> *)actual {
    [store sdl_setObject:actual forName:SDLNameActual];
}

- (nullable NSNumber<SDLBool> *)actual {
    return [store sdl_objectForName:SDLNameActual ofClass:NSNumber.class];
}

- (void)setSatellites:(nullable NSNumber<SDLInt> *)satellites {
    [store sdl_setObject:satellites forName:SDLNameSatellites];
}

- (nullable NSNumber<SDLInt> *)satellites {
    return [store sdl_objectForName:SDLNameSatellites ofClass:NSNumber.class];
}

- (void)setDimension:(nullable SDLDimension)dimension {
    [store sdl_setObject:dimension forName:SDLNameDimension];
}

- (nullable SDLDimension)dimension {
    return [store sdl_enumForName:SDLNameDimension];
}

- (void)setAltitude:(nullable NSNumber<SDLFloat> *)altitude {
    [store sdl_setObject:altitude forName:SDLNameAltitude];
}

- (nullable NSNumber<SDLFloat> *)altitude {
    return [store sdl_objectForName:SDLNameAltitude ofClass:NSNumber.class];
}

- (void)setHeading:(nullable NSNumber<SDLFloat> *)heading {
    [store sdl_setObject:heading forName:SDLNameHeading];
}

- (nullable NSNumber<SDLFloat> *)heading {
    return [store sdl_objectForName:SDLNameHeading ofClass:NSNumber.class];
}

- (void)setSpeed:(nullable NSNumber<SDLFloat> *)speed {
    [store sdl_setObject:speed forName:SDLNameSpeed];
}

- (nullable NSNumber<SDLFloat> *)speed {
    return [store sdl_objectForName:SDLNameSpeed ofClass:NSNumber.class];
}

@end

NS_ASSUME_NONNULL_END
