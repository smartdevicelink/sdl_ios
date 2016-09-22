//  SDLGPSData.m
//

#import "SDLGPSData.h"

#import "SDLCompassDirection.h"
#import "SDLDimension.h"
#import "SDLNames.h"

@implementation SDLGPSData

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setLongitudeDegrees:(NSNumber *)longitudeDegrees {
    if (longitudeDegrees != nil) {
        [store setObject:longitudeDegrees forKey:SDLNameLongitudeDegrees];
    } else {
        [store removeObjectForKey:SDLNameLongitudeDegrees];
    }
}

- (NSNumber *)longitudeDegrees {
    return [store objectForKey:SDLNameLongitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber *)latitudeDegrees {
    if (latitudeDegrees != nil) {
        [store setObject:latitudeDegrees forKey:SDLNameLatitudeDegrees];
    } else {
        [store removeObjectForKey:SDLNameLatitudeDegrees];
    }
}

- (NSNumber *)latitudeDegrees {
    return [store objectForKey:SDLNameLatitudeDegrees];
}

- (void)setUtcYear:(NSNumber *)utcYear {
    if (utcYear != nil) {
        [store setObject:utcYear forKey:SDLNameUtcYear];
    } else {
        [store removeObjectForKey:SDLNameUtcYear];
    }
}

- (NSNumber *)utcYear {
    return [store objectForKey:SDLNameUtcYear];
}

- (void)setUtcMonth:(NSNumber *)utcMonth {
    if (utcMonth != nil) {
        [store setObject:utcMonth forKey:SDLNameUtcMonth];
    } else {
        [store removeObjectForKey:SDLNameUtcMonth];
    }
}

- (NSNumber *)utcMonth {
    return [store objectForKey:SDLNameUtcMonth];
}

- (void)setUtcDay:(NSNumber *)utcDay {
    if (utcDay != nil) {
        [store setObject:utcDay forKey:SDLNameUtcDay];
    } else {
        [store removeObjectForKey:SDLNameUtcDay];
    }
}

- (NSNumber *)utcDay {
    return [store objectForKey:SDLNameUtcDay];
}

- (void)setUtcHours:(NSNumber *)utcHours {
    if (utcHours != nil) {
        [store setObject:utcHours forKey:SDLNameUtcHours];
    } else {
        [store removeObjectForKey:SDLNameUtcHours];
    }
}

- (NSNumber *)utcHours {
    return [store objectForKey:SDLNameUtcHours];
}

- (void)setUtcMinutes:(NSNumber *)utcMinutes {
    if (utcMinutes != nil) {
        [store setObject:utcMinutes forKey:SDLNameUtcMinutes];
    } else {
        [store removeObjectForKey:SDLNameUtcMinutes];
    }
}

- (NSNumber *)utcMinutes {
    return [store objectForKey:SDLNameUtcMinutes];
}

- (void)setUtcSeconds:(NSNumber *)utcSeconds {
    if (utcSeconds != nil) {
        [store setObject:utcSeconds forKey:SDLNameUtcSeconds];
    } else {
        [store removeObjectForKey:SDLNameUtcSeconds];
    }
}

- (NSNumber *)utcSeconds {
    return [store objectForKey:SDLNameUtcSeconds];
}

- (void)setCompassDirection:(SDLCompassDirection *)compassDirection {
    if (compassDirection != nil) {
        [store setObject:compassDirection forKey:SDLNameCompassDirection];
    } else {
        [store removeObjectForKey:SDLNameCompassDirection];
    }
}

- (SDLCompassDirection *)compassDirection {
    NSObject *obj = [store objectForKey:SDLNameCompassDirection];
    if (obj == nil || [obj isKindOfClass:SDLCompassDirection.class]) {
        return (SDLCompassDirection *)obj;
    } else {
        return [SDLCompassDirection valueOf:(NSString *)obj];
    }
}

- (void)setPdop:(NSNumber *)pdop {
    if (pdop != nil) {
        [store setObject:pdop forKey:SDLNamePdop];
    } else {
        [store removeObjectForKey:SDLNamePdop];
    }
}

- (NSNumber *)pdop {
    return [store objectForKey:SDLNamePdop];
}

- (void)setHdop:(NSNumber *)hdop {
    if (hdop != nil) {
        [store setObject:hdop forKey:SDLNameHdop];
    } else {
        [store removeObjectForKey:SDLNameHdop];
    }
}

- (NSNumber *)hdop {
    return [store objectForKey:SDLNameHdop];
}

- (void)setVdop:(NSNumber *)vdop {
    if (vdop != nil) {
        [store setObject:vdop forKey:SDLNameVdop];
    } else {
        [store removeObjectForKey:SDLNameVdop];
    }
}

- (NSNumber *)vdop {
    return [store objectForKey:SDLNameVdop];
}

- (void)setActual:(NSNumber *)actual {
    if (actual != nil) {
        [store setObject:actual forKey:SDLNameActual];
    } else {
        [store removeObjectForKey:SDLNameActual];
    }
}

- (NSNumber *)actual {
    return [store objectForKey:SDLNameActual];
}

- (void)setSatellites:(NSNumber *)satellites {
    if (satellites != nil) {
        [store setObject:satellites forKey:SDLNameSatellites];
    } else {
        [store removeObjectForKey:SDLNameSatellites];
    }
}

- (NSNumber *)satellites {
    return [store objectForKey:SDLNameSatellites];
}

- (void)setDimension:(SDLDimension *)dimension {
    if (dimension != nil) {
        [store setObject:dimension forKey:SDLNameDimension];
    } else {
        [store removeObjectForKey:SDLNameDimension];
    }
}

- (SDLDimension *)dimension {
    NSObject *obj = [store objectForKey:SDLNameDimension];
    if (obj == nil || [obj isKindOfClass:SDLDimension.class]) {
        return (SDLDimension *)obj;
    } else {
        return [SDLDimension valueOf:(NSString *)obj];
    }
}

- (void)setAltitude:(NSNumber *)altitude {
    if (altitude != nil) {
        [store setObject:altitude forKey:SDLNameAltitude];
    } else {
        [store removeObjectForKey:SDLNameAltitude];
    }
}

- (NSNumber *)altitude {
    return [store objectForKey:SDLNameAltitude];
}

- (void)setHeading:(NSNumber *)heading {
    if (heading != nil) {
        [store setObject:heading forKey:SDLNameHeading];
    } else {
        [store removeObjectForKey:SDLNameHeading];
    }
}

- (NSNumber *)heading {
    return [store objectForKey:SDLNameHeading];
}

- (void)setSpeed:(NSNumber *)speed {
    if (speed != nil) {
        [store setObject:speed forKey:SDLNameSpeed];
    } else {
        [store removeObjectForKey:SDLNameSpeed];
    }
}

- (NSNumber *)speed {
    return [store objectForKey:SDLNameSpeed];
}

@end
