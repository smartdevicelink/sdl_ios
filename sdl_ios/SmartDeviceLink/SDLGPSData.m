//  SDLGPSData.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLGPSData.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLGPSData

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setLongitudeDegrees:(NSNumber*) longitudeDegrees {
    [store setOrRemoveObject:longitudeDegrees forKey:NAMES_longitudeDegrees];
}

-(NSNumber*) longitudeDegrees {
    return [store objectForKey:NAMES_longitudeDegrees];
}

-(void) setLatitudeDegrees:(NSNumber*) latitudeDegrees {
    [store setOrRemoveObject:latitudeDegrees forKey:NAMES_latitudeDegrees];
}

-(NSNumber*) latitudeDegrees {
    return [store objectForKey:NAMES_latitudeDegrees];
}

-(void) setUtcYear:(NSNumber*) utcYear {
    [store setOrRemoveObject:utcYear forKey:NAMES_utcYear];
}

-(NSNumber*) utcYear {
    return [store objectForKey:NAMES_utcYear];
}

-(void) setUtcMonth:(NSNumber*) utcMonth {
    [store setOrRemoveObject:utcMonth forKey:NAMES_utcMonth];
}

-(NSNumber*) utcMonth {
    return [store objectForKey:NAMES_utcMonth];
}

-(void) setUtcDay:(NSNumber*) utcDay {
    [store setOrRemoveObject:utcDay forKey:NAMES_utcDay];
}

-(NSNumber*) utcDay {
    return [store objectForKey:NAMES_utcDay];
}

-(void) setUtcHours:(NSNumber*) utcHours {
    [store setOrRemoveObject:utcHours forKey:NAMES_utcHours];
}

-(NSNumber*) utcHours {
    return [store objectForKey:NAMES_utcHours];
}

-(void) setUtcMinutes:(NSNumber*) utcMinutes {
    [store setOrRemoveObject:utcMinutes forKey:NAMES_utcMinutes];
}

-(NSNumber*) utcMinutes {
    return [store objectForKey:NAMES_utcMinutes];
}

-(void) setUtcSeconds:(NSNumber*) utcSeconds {
    [store setOrRemoveObject:utcSeconds forKey:NAMES_utcSeconds];
}

-(NSNumber*) utcSeconds {
    return [store objectForKey:NAMES_utcSeconds];
}

-(void) setCompassDirection:(SDLCompassDirection*) compassDirection {
    [store setOrRemoveObject:compassDirection forKey:NAMES_compassDirection];
}

-(SDLCompassDirection*) compassDirection {
    NSObject* obj = [store objectForKey:NAMES_compassDirection];
    if ([obj isKindOfClass:SDLCompassDirection.class]) {
        return (SDLCompassDirection*)obj;
    } else {
        return [SDLCompassDirection valueOf:(NSString*)obj];
    }
}

-(void) setPdop:(NSNumber*) pdop {
    [store setOrRemoveObject:pdop forKey:NAMES_pdop];
}

-(NSNumber*) pdop {
    return [store objectForKey:NAMES_pdop];
}

-(void) setHdop:(NSNumber*) hdop {
    [store setOrRemoveObject:hdop forKey:NAMES_hdop];
}

-(NSNumber*) hdop {
    return [store objectForKey:NAMES_hdop];
}

-(void) setVdop:(NSNumber*) vdop {
    [store setOrRemoveObject:vdop forKey:NAMES_vdop];
}

-(NSNumber*) vdop {
    return [store objectForKey:NAMES_vdop];
}

-(void) setActual:(NSNumber*) actual {
    [store setOrRemoveObject:actual forKey:NAMES_actual];
}

-(NSNumber*) actual {
    return [store objectForKey:NAMES_actual];
}

-(void) setSatellites:(NSNumber*) satellites {
    [store setOrRemoveObject:satellites forKey:NAMES_satellites];
}

-(NSNumber*) satellites {
    return [store objectForKey:NAMES_satellites];
}

-(void) setDimension:(SDLDimension*) dimension {
    [store setOrRemoveObject:dimension forKey:NAMES_dimension];
}

-(SDLDimension*) dimension {
    NSObject* obj = [store objectForKey:NAMES_dimension];
    if ([obj isKindOfClass:SDLDimension.class]) {
        return (SDLDimension*)obj;
    } else {
        return [SDLDimension valueOf:(NSString*)obj];
    }
}

-(void) setAltitude:(NSNumber*) altitude {
    [store setOrRemoveObject:altitude forKey:NAMES_altitude];
}

-(NSNumber*) altitude {
    return [store objectForKey:NAMES_altitude];
}

-(void) setHeading:(NSNumber*) heading {
    [store setOrRemoveObject:heading forKey:NAMES_heading];
}

-(NSNumber*) heading {
    return [store objectForKey:NAMES_heading];
}

-(void) setSpeed:(NSNumber*) speed {
    [store setOrRemoveObject:speed forKey:NAMES_speed];
}

-(NSNumber*) speed {
    return [store objectForKey:NAMES_speed];
}

@end
