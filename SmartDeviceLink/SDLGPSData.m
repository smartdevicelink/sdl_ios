//  SDLGPSData.m
//

#import "SDLGPSData.h"

#import "SDLNames.h"

@implementation SDLGPSData

- (void)setLongitudeDegrees:(NSNumber<SDLFloat> *)longitudeDegrees {
    if (longitudeDegrees != nil) {
        [store setObject:longitudeDegrees forKey:SDLNameLongitudeDegrees];
    } else {
        [store removeObjectForKey:SDLNameLongitudeDegrees];
    }
}

- (NSNumber<SDLFloat> *)longitudeDegrees {
    return [store objectForKey:SDLNameLongitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber<SDLFloat> *)latitudeDegrees {
    if (latitudeDegrees != nil) {
        [store setObject:latitudeDegrees forKey:SDLNameLatitudeDegrees];
    } else {
        [store removeObjectForKey:SDLNameLatitudeDegrees];
    }
}

- (NSNumber<SDLFloat> *)latitudeDegrees {
    return [store objectForKey:SDLNameLatitudeDegrees];
}

- (void)setUtcYear:(NSNumber<SDLInt> *)utcYear {
    if (utcYear != nil) {
        [store setObject:utcYear forKey:SDLNameUTCYear];
    } else {
        [store removeObjectForKey:SDLNameUTCYear];
    }
}

- (NSNumber<SDLInt> *)utcYear {
    return [store objectForKey:SDLNameUTCYear];
}

- (void)setUtcMonth:(NSNumber<SDLInt> *)utcMonth {
    if (utcMonth != nil) {
        [store setObject:utcMonth forKey:SDLNameUTCMonth];
    } else {
        [store removeObjectForKey:SDLNameUTCMonth];
    }
}

- (NSNumber<SDLInt> *)utcMonth {
    return [store objectForKey:SDLNameUTCMonth];
}

- (void)setUtcDay:(NSNumber<SDLInt> *)utcDay {
    if (utcDay != nil) {
        [store setObject:utcDay forKey:SDLNameUTCDay];
    } else {
        [store removeObjectForKey:SDLNameUTCDay];
    }
}

- (NSNumber<SDLInt> *)utcDay {
    return [store objectForKey:SDLNameUTCDay];
}

- (void)setUtcHours:(NSNumber<SDLInt> *)utcHours {
    if (utcHours != nil) {
        [store setObject:utcHours forKey:SDLNameUTCHours];
    } else {
        [store removeObjectForKey:SDLNameUTCHours];
    }
}

- (NSNumber<SDLInt> *)utcHours {
    return [store objectForKey:SDLNameUTCHours];
}

- (void)setUtcMinutes:(NSNumber<SDLInt> *)utcMinutes {
    if (utcMinutes != nil) {
        [store setObject:utcMinutes forKey:SDLNameUTCMinutes];
    } else {
        [store removeObjectForKey:SDLNameUTCMinutes];
    }
}

- (NSNumber<SDLInt> *)utcMinutes {
    return [store objectForKey:SDLNameUTCMinutes];
}

- (void)setUtcSeconds:(NSNumber<SDLInt> *)utcSeconds {
    if (utcSeconds != nil) {
        [store setObject:utcSeconds forKey:SDLNameUTCSeconds];
    } else {
        [store removeObjectForKey:SDLNameUTCSeconds];
    }
}

- (NSNumber<SDLInt> *)utcSeconds {
    return [store objectForKey:SDLNameUTCSeconds];
}

- (void)setCompassDirection:(SDLCompassDirection)compassDirection {
    if (compassDirection != nil) {
        [store setObject:compassDirection forKey:SDLNameCompassDirection];
    } else {
        [store removeObjectForKey:SDLNameCompassDirection];
    }
}

- (SDLCompassDirection)compassDirection {
    NSObject *obj = [store objectForKey:SDLNameCompassDirection];
    return (SDLCompassDirection)obj;
}

- (void)setPdop:(NSNumber<SDLFloat> *)pdop {
    if (pdop != nil) {
        [store setObject:pdop forKey:SDLNamePDOP];
    } else {
        [store removeObjectForKey:SDLNamePDOP];
    }
}

- (NSNumber<SDLFloat> *)pdop {
    return [store objectForKey:SDLNamePDOP];
}

- (void)setHdop:(NSNumber<SDLFloat> *)hdop {
    if (hdop != nil) {
        [store setObject:hdop forKey:SDLNameHDOP];
    } else {
        [store removeObjectForKey:SDLNameHDOP];
    }
}

- (NSNumber<SDLFloat> *)hdop {
    return [store objectForKey:SDLNameHDOP];
}

- (void)setVdop:(NSNumber<SDLFloat> *)vdop {
    if (vdop != nil) {
        [store setObject:vdop forKey:SDLNameVDOP];
    } else {
        [store removeObjectForKey:SDLNameVDOP];
    }
}

- (NSNumber<SDLFloat> *)vdop {
    return [store objectForKey:SDLNameVDOP];
}

- (void)setActual:(NSNumber<SDLBool> *)actual {
    if (actual != nil) {
        [store setObject:actual forKey:SDLNameActual];
    } else {
        [store removeObjectForKey:SDLNameActual];
    }
}

- (NSNumber<SDLBool> *)actual {
    return [store objectForKey:SDLNameActual];
}

- (void)setSatellites:(NSNumber<SDLInt> *)satellites {
    if (satellites != nil) {
        [store setObject:satellites forKey:SDLNameSatellites];
    } else {
        [store removeObjectForKey:SDLNameSatellites];
    }
}

- (NSNumber<SDLInt> *)satellites {
    return [store objectForKey:SDLNameSatellites];
}

- (void)setDimension:(SDLDimension)dimension {
    if (dimension != nil) {
        [store setObject:dimension forKey:SDLNameDimension];
    } else {
        [store removeObjectForKey:SDLNameDimension];
    }
}

- (SDLDimension)dimension {
    NSObject *obj = [store objectForKey:SDLNameDimension];
    return (SDLDimension)obj;
}

- (void)setAltitude:(NSNumber<SDLFloat> *)altitude {
    if (altitude != nil) {
        [store setObject:altitude forKey:SDLNameAltitude];
    } else {
        [store removeObjectForKey:SDLNameAltitude];
    }
}

- (NSNumber<SDLFloat> *)altitude {
    return [store objectForKey:SDLNameAltitude];
}

- (void)setHeading:(NSNumber<SDLFloat> *)heading {
    if (heading != nil) {
        [store setObject:heading forKey:SDLNameHeading];
    } else {
        [store removeObjectForKey:SDLNameHeading];
    }
}

- (NSNumber<SDLFloat> *)heading {
    return [store objectForKey:SDLNameHeading];
}

- (void)setSpeed:(NSNumber<SDLFloat> *)speed {
    if (speed != nil) {
        [store setObject:speed forKey:SDLNameSpeed];
    } else {
        [store removeObjectForKey:SDLNameSpeed];
    }
}

- (NSNumber<SDLFloat> *)speed {
    return [store objectForKey:SDLNameSpeed];
}

@end
