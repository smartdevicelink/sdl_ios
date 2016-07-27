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
        [store setObject:longitudeDegrees forKey:NAMES_longitudeDegrees];
    } else {
        [store removeObjectForKey:NAMES_longitudeDegrees];
    }
}

- (NSNumber *)longitudeDegrees {
    return [store objectForKey:NAMES_longitudeDegrees];
}

- (void)setLatitudeDegrees:(NSNumber *)latitudeDegrees {
    if (latitudeDegrees != nil) {
        [store setObject:latitudeDegrees forKey:NAMES_latitudeDegrees];
    } else {
        [store removeObjectForKey:NAMES_latitudeDegrees];
    }
}

- (NSNumber *)latitudeDegrees {
    return [store objectForKey:NAMES_latitudeDegrees];
}

- (void)setUtcYear:(NSNumber *)utcYear {
    if (utcYear != nil) {
        [store setObject:utcYear forKey:NAMES_utcYear];
    } else {
        [store removeObjectForKey:NAMES_utcYear];
    }
}

- (NSNumber *)utcYear {
    return [store objectForKey:NAMES_utcYear];
}

- (void)setUtcMonth:(NSNumber *)utcMonth {
    if (utcMonth != nil) {
        [store setObject:utcMonth forKey:NAMES_utcMonth];
    } else {
        [store removeObjectForKey:NAMES_utcMonth];
    }
}

- (NSNumber *)utcMonth {
    return [store objectForKey:NAMES_utcMonth];
}

- (void)setUtcDay:(NSNumber *)utcDay {
    if (utcDay != nil) {
        [store setObject:utcDay forKey:NAMES_utcDay];
    } else {
        [store removeObjectForKey:NAMES_utcDay];
    }
}

- (NSNumber *)utcDay {
    return [store objectForKey:NAMES_utcDay];
}

- (void)setUtcHours:(NSNumber *)utcHours {
    if (utcHours != nil) {
        [store setObject:utcHours forKey:NAMES_utcHours];
    } else {
        [store removeObjectForKey:NAMES_utcHours];
    }
}

- (NSNumber *)utcHours {
    return [store objectForKey:NAMES_utcHours];
}

- (void)setUtcMinutes:(NSNumber *)utcMinutes {
    if (utcMinutes != nil) {
        [store setObject:utcMinutes forKey:NAMES_utcMinutes];
    } else {
        [store removeObjectForKey:NAMES_utcMinutes];
    }
}

- (NSNumber *)utcMinutes {
    return [store objectForKey:NAMES_utcMinutes];
}

- (void)setUtcSeconds:(NSNumber *)utcSeconds {
    if (utcSeconds != nil) {
        [store setObject:utcSeconds forKey:NAMES_utcSeconds];
    } else {
        [store removeObjectForKey:NAMES_utcSeconds];
    }
}

- (NSNumber *)utcSeconds {
    return [store objectForKey:NAMES_utcSeconds];
}

- (void)setCompassDirection:(SDLCompassDirection *)compassDirection {
    if (compassDirection != nil) {
        [store setObject:compassDirection forKey:NAMES_compassDirection];
    } else {
        [store removeObjectForKey:NAMES_compassDirection];
    }
}

- (SDLCompassDirection *)compassDirection {
    NSObject *obj = [store objectForKey:NAMES_compassDirection];
    if (obj == nil || [obj isKindOfClass:SDLCompassDirection.class]) {
        return (SDLCompassDirection *)obj;
    } else {
        return [SDLCompassDirection valueOf:(NSString *)obj];
    }
}

- (void)setPdop:(NSNumber *)pdop {
    if (pdop != nil) {
        [store setObject:pdop forKey:NAMES_pdop];
    } else {
        [store removeObjectForKey:NAMES_pdop];
    }
}

- (NSNumber *)pdop {
    return [store objectForKey:NAMES_pdop];
}

- (void)setHdop:(NSNumber *)hdop {
    if (hdop != nil) {
        [store setObject:hdop forKey:NAMES_hdop];
    } else {
        [store removeObjectForKey:NAMES_hdop];
    }
}

- (NSNumber *)hdop {
    return [store objectForKey:NAMES_hdop];
}

- (void)setVdop:(NSNumber *)vdop {
    if (vdop != nil) {
        [store setObject:vdop forKey:NAMES_vdop];
    } else {
        [store removeObjectForKey:NAMES_vdop];
    }
}

- (NSNumber *)vdop {
    return [store objectForKey:NAMES_vdop];
}

- (void)setActual:(NSNumber *)actual {
    if (actual != nil) {
        [store setObject:actual forKey:NAMES_actual];
    } else {
        [store removeObjectForKey:NAMES_actual];
    }
}

- (NSNumber *)actual {
    return [store objectForKey:NAMES_actual];
}

- (void)setSatellites:(NSNumber *)satellites {
    if (satellites != nil) {
        [store setObject:satellites forKey:NAMES_satellites];
    } else {
        [store removeObjectForKey:NAMES_satellites];
    }
}

- (NSNumber *)satellites {
    return [store objectForKey:NAMES_satellites];
}

- (void)setDimension:(SDLDimension *)dimension {
    if (dimension != nil) {
        [store setObject:dimension forKey:NAMES_dimension];
    } else {
        [store removeObjectForKey:NAMES_dimension];
    }
}

- (SDLDimension *)dimension {
    NSObject *obj = [store objectForKey:NAMES_dimension];
    if (obj == nil || [obj isKindOfClass:SDLDimension.class]) {
        return (SDLDimension *)obj;
    } else {
        return [SDLDimension valueOf:(NSString *)obj];
    }
}

- (void)setAltitude:(NSNumber *)altitude {
    if (altitude != nil) {
        [store setObject:altitude forKey:NAMES_altitude];
    } else {
        [store removeObjectForKey:NAMES_altitude];
    }
}

- (NSNumber *)altitude {
    return [store objectForKey:NAMES_altitude];
}

- (void)setHeading:(NSNumber *)heading {
    if (heading != nil) {
        [store setObject:heading forKey:NAMES_heading];
    } else {
        [store removeObjectForKey:NAMES_heading];
    }
}

- (NSNumber *)heading {
    return [store objectForKey:NAMES_heading];
}

- (void)setSpeed:(NSNumber *)speed {
    if (speed != nil) {
        [store setObject:speed forKey:NAMES_speed];
    } else {
        [store removeObjectForKey:NAMES_speed];
    }
}

- (NSNumber *)speed {
    return [store objectForKey:NAMES_speed];
}

@end
