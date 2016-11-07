//  SDLGPSData.m
//

#import "SDLGPSData.h"

#import "SDLNames.h"

@implementation SDLGPSData

- (void)setLongitudeDegrees:(NSNumber<SDLFloat> *)longitudeDegrees {
    [self setObject:longitudeDegrees forName:SDLNameLongitudeDegrees];
}

- (NSNumber<SDLFloat> *)longitudeDegrees {
    return [self objectForName:SDLNameLongitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    [self setObject:latitudeDegrees forName:SDLNameLatitudeDegrees];
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    return [self objectForName:SDLNameLatitudeDegrees];
}

- (void)setUtcYear:(NSNumber<SDLInt> *)utcYear {
    [self setObject:utcYear forName:SDLNameUTCYear];
}

- (NSNumber<SDLInt> *)utcYear {
    return [self objectForName:SDLNameUTCYear];
}

- (void)setUtcMonth:(NSNumber<SDLInt> *)utcMonth {
    [self setObject:utcMonth forName:SDLNameUTCMonth];
}

- (NSNumber<SDLInt> *)utcMonth {
    return [self objectForName:SDLNameUTCMonth];
}

- (void)setUtcDay:(NSNumber<SDLInt> *)utcDay {
    [self setObject:utcDay forName:SDLNameUTCDay];
}

- (NSNumber<SDLInt> *)utcDay {
    return [self objectForName:SDLNameUTCDay];
}

- (void)setUtcHours:(NSNumber<SDLInt> *)utcHours {
    [self setObject:utcHours forName:SDLNameUTCHours];
}

- (NSNumber<SDLInt> *)utcHours {
    return [self objectForName:SDLNameUTCHours];
}

- (void)setUtcMinutes:(NSNumber<SDLInt> *)utcMinutes {
    [self setObject:utcMinutes forName:SDLNameUTCMinutes];
}

- (NSNumber<SDLInt> *)utcMinutes {
    return [self objectForName:SDLNameUTCMinutes];
}

- (void)setUtcSeconds:(NSNumber<SDLInt> *)utcSeconds {
    [self setObject:utcSeconds forName:SDLNameUTCSeconds];
}

- (NSNumber<SDLInt> *)utcSeconds {
    return [self objectForName:SDLNameUTCSeconds];
}

- (void)setCompassDirection:(SDLCompassDirection)compassDirection {
    [self setObject:compassDirection forName:SDLNameCompassDirection];
}

- (SDLCompassDirection)compassDirection {
    return [self objectForName:SDLNameCompassDirection];
}

- (void)setPdop:(NSNumber<SDLFloat> *)pdop {
    [self setObject:pdop forName:SDLNamePDOP];
}

- (NSNumber<SDLFloat> *)pdop {
    return [self objectForName:SDLNamePDOP];
}

- (void)setHdop:(NSNumber<SDLFloat> *)hdop {
    [self setObject:hdop forName:SDLNameHDOP];
}

- (NSNumber<SDLFloat> *)hdop {
    return [self objectForName:SDLNameHDOP];
}

- (void)setVdop:(NSNumber<SDLFloat> *)vdop {
    [self setObject:vdop forName:SDLNameVDOP];
}

- (NSNumber<SDLFloat> *)vdop {
    return [self objectForName:SDLNameVDOP];
}

- (void)setActual:(NSNumber<SDLBool> *)actual {
    [self setObject:actual forName:SDLNameActual];
}

- (NSNumber<SDLBool> *)actual {
    return [self objectForName:SDLNameActual];
}

- (void)setSatellites:(NSNumber<SDLInt> *)satellites {
    [self setObject:satellites forName:SDLNameSatellites];
}

- (NSNumber<SDLInt> *)satellites {
    return [self objectForName:SDLNameSatellites];
}

- (void)setDimension:(SDLDimension)dimension {
    [self setObject:dimension forName:SDLNameDimension];
}

- (SDLDimension)dimension {
    return [self objectForName:SDLNameDimension];
}

- (void)setAltitude:(NSNumber<SDLFloat> *)altitude {
    [self setObject:altitude forName:SDLNameAltitude];
}

- (NSNumber<SDLFloat> *)altitude {
    return [self objectForName:SDLNameAltitude];
}

- (void)setHeading:(NSNumber<SDLFloat> *)heading {
    [self setObject:heading forName:SDLNameHeading];
}

- (NSNumber<SDLFloat> *)heading {
    return [self objectForName:SDLNameHeading];
}

- (void)setSpeed:(NSNumber<SDLFloat> *)speed {
    [self setObject:speed forName:SDLNameSpeed];
}

- (NSNumber<SDLFloat> *)speed {
    return [self objectForName:SDLNameSpeed];
}

@end
