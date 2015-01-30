//  SDLOnVehicleData.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLOnVehicleData.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLOnVehicleData

-(id) init {
    if (self = [super initWithName:NAMES_OnVehicleData]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setGps:(SDLGPSData *)gps {
    [parameters setOrRemoveObject:gps forKey:NAMES_gps];
}

-(SDLGPSData*) gps {
    NSObject* obj = [parameters objectForKey:NAMES_gps];
    if ([obj isKindOfClass:SDLGPSData.class]) {
        return (SDLGPSData*)obj;
    } else {
        return [[SDLGPSData alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setSpeed:(NSNumber *)speed {
    [parameters setOrRemoveObject:speed forKey:NAMES_speed];
}

-(NSNumber*) speed {
    return [parameters objectForKey:NAMES_speed];
}

- (void)setRpm:(NSNumber *)rpm {
    [parameters setOrRemoveObject:rpm forKey:NAMES_rpm];
}

-(NSNumber*) rpm {
    return [parameters objectForKey:NAMES_rpm];
}

- (void)setFuelLevel:(NSNumber *)fuelLevel {
    [parameters setOrRemoveObject:fuelLevel forKey:NAMES_fuelLevel];
}

-(NSNumber*) fuelLevel {
    return [parameters objectForKey:NAMES_fuelLevel];
}

- (void)setFuelLevel_State:(SDLComponentVolumeStatus *)fuelLevel_State {
    [parameters setOrRemoveObject:fuelLevel_State forKey:NAMES_fuelLevel_State];
}

-(SDLComponentVolumeStatus*) fuelLevel_State {
    NSObject* obj = [parameters objectForKey:NAMES_fuelLevel_State];
    if ([obj isKindOfClass:SDLComponentVolumeStatus.class]) {
        return (SDLComponentVolumeStatus*)obj;
    } else {
        return [SDLComponentVolumeStatus valueOf:(NSString*)obj];
    }
}

- (void)setInstantFuelConsumption:(NSNumber *)instantFuelConsumption {
    [parameters setOrRemoveObject:instantFuelConsumption forKey:NAMES_instantFuelConsumption];
}

-(NSNumber*) instantFuelConsumption {
    return [parameters objectForKey:NAMES_instantFuelConsumption];
}

- (void)setExternalTemperature:(NSNumber *)externalTemperature {
    [parameters setOrRemoveObject:externalTemperature forKey:NAMES_externalTemperature];
}

-(NSNumber*) externalTemperature {
    return [parameters objectForKey:NAMES_externalTemperature];
}

- (void)setVin:(NSString *)vin {
    [parameters setOrRemoveObject:vin forKey:NAMES_vin];
}

-(NSString*) vin {
    return [parameters objectForKey:NAMES_vin];
}

- (void)setPrndl:(SDLPRNDL *)prndl {
    [parameters setOrRemoveObject:prndl forKey:NAMES_prndl];
}

-(SDLPRNDL*) prndl {
    NSObject* obj = [parameters objectForKey:NAMES_prndl];
    if ([obj isKindOfClass:SDLPRNDL.class]) {
        return (SDLPRNDL*)obj;
    } else {
        return [SDLPRNDL valueOf:(NSString*)obj];
    }
}

- (void)setTirePressure:(SDLTireStatus *)tirePressure {
    [parameters setOrRemoveObject:tirePressure forKey:NAMES_tirePressure];
}

-(SDLTireStatus*) tirePressure {
    NSObject* obj = [parameters objectForKey:NAMES_tirePressure];
    if ([obj isKindOfClass:SDLTireStatus.class]) {
        return (SDLTireStatus*)obj;
    } else {
        return [[SDLTireStatus alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setOdometer:(NSNumber *)odometer {
    [parameters setOrRemoveObject:odometer forKey:NAMES_odometer];
}

-(NSNumber*) odometer {
    return [parameters objectForKey:NAMES_odometer];
}

- (void)setBeltStatus:(SDLBeltStatus *)beltStatus {
    [parameters setOrRemoveObject:beltStatus forKey:NAMES_beltStatus];
}

-(SDLBeltStatus*) beltStatus {
    NSObject* obj = [parameters objectForKey:NAMES_beltStatus];
    if ([obj isKindOfClass:SDLBeltStatus.class]) {
        return (SDLBeltStatus*)obj;
    } else {
        return [[SDLBeltStatus alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setBodyInformation:(SDLBodyInformation *)bodyInformation {
    [parameters setOrRemoveObject:bodyInformation forKey:NAMES_bodyInformation];
}

-(SDLBodyInformation*) bodyInformation {
    NSObject* obj = [parameters objectForKey:NAMES_bodyInformation];
    if ([obj isKindOfClass:SDLBodyInformation.class]) {
        return (SDLBodyInformation*)obj;
    } else {
        return [[SDLBodyInformation alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setDeviceStatus:(SDLDeviceStatus *)deviceStatus {
    [parameters setOrRemoveObject:deviceStatus forKey:NAMES_deviceStatus];
}

-(SDLDeviceStatus*) deviceStatus {
    NSObject* obj = [parameters objectForKey:NAMES_deviceStatus];
    if ([obj isKindOfClass:SDLDeviceStatus.class]) {
        return (SDLDeviceStatus*)obj;
    } else {
        return [[SDLDeviceStatus alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setDriverBraking:(SDLVehicleDataEventStatus *)driverBraking {
    [parameters setOrRemoveObject:driverBraking forKey:NAMES_driverBraking];
}

-(SDLVehicleDataEventStatus*) driverBraking {
    NSObject* obj = [parameters objectForKey:NAMES_driverBraking];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

- (void)setWiperStatus:(SDLWiperStatus *)wiperStatus {
    [parameters setOrRemoveObject:wiperStatus forKey:NAMES_wiperStatus];
}

-(SDLWiperStatus*) wiperStatus {
    NSObject* obj = [parameters objectForKey:NAMES_wiperStatus];
    if ([obj isKindOfClass:SDLWiperStatus.class]) {
        return (SDLWiperStatus*)obj;
    } else {
        return [SDLWiperStatus valueOf:(NSString*)obj];
    }
}

- (void)setHeadLampStatus:(SDLHeadLampStatus *)headLampStatus {
    [parameters setOrRemoveObject:headLampStatus forKey:NAMES_headLampStatus];
}

-(SDLHeadLampStatus*) headLampStatus {
    NSObject* obj = [parameters objectForKey:NAMES_headLampStatus];
    if ([obj isKindOfClass:SDLHeadLampStatus.class]) {
        return (SDLHeadLampStatus*)obj;
    } else {
        return [[SDLHeadLampStatus alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setEngineTorque:(NSNumber *)engineTorque {
    [parameters setOrRemoveObject:engineTorque forKey:NAMES_engineTorque];
}

-(NSNumber*) engineTorque {
    return [parameters objectForKey:NAMES_engineTorque];
}

- (void)setAccPedalPosition:(NSNumber *)accPedalPosition {
    [parameters setOrRemoveObject:accPedalPosition forKey:NAMES_accPedalPosition];
}

-(NSNumber*) accPedalPosition {
    return [parameters objectForKey:NAMES_accPedalPosition];
}

- (void)setSteeringWheelAngle:(NSNumber *)steeringWheelAngle {
    [parameters setOrRemoveObject:steeringWheelAngle forKey:NAMES_steeringWheelAngle];
}

-(NSNumber*) steeringWheelAngle {
    return [parameters objectForKey:NAMES_steeringWheelAngle];
}

- (void)setECallInfo:(SDLECallInfo *)eCallInfo {
    [parameters setOrRemoveObject:eCallInfo forKey:NAMES_eCallInfo];
}

-(SDLECallInfo*) eCallInfo {
    NSObject* obj = [parameters objectForKey:NAMES_eCallInfo];
    if ([obj isKindOfClass:SDLECallInfo.class]) {
        return (SDLECallInfo*)obj;
    } else {
        return [[SDLECallInfo alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setAirbagStatus:(SDLAirbagStatus *)airbagStatus {
    [parameters setOrRemoveObject:airbagStatus forKey:NAMES_airbagStatus];
}

-(SDLAirbagStatus*) airbagStatus {
    NSObject* obj = [parameters objectForKey:NAMES_airbagStatus];
    if ([obj isKindOfClass:SDLAirbagStatus.class]) {
        return (SDLAirbagStatus*)obj;
    } else {
        return [[SDLAirbagStatus alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setEmergencyEvent:(SDLEmergencyEvent *)emergencyEvent {
    [parameters setOrRemoveObject:emergencyEvent forKey:NAMES_emergencyEvent];
}

-(SDLEmergencyEvent*) emergencyEvent {
    NSObject* obj = [parameters objectForKey:NAMES_emergencyEvent];
    if ([obj isKindOfClass:SDLEmergencyEvent.class]) {
        return (SDLEmergencyEvent*)obj;
    } else {
        return [[SDLEmergencyEvent alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setClusterModeStatus:(SDLClusterModeStatus *)clusterModeStatus {
    [parameters setOrRemoveObject:clusterModeStatus forKey:NAMES_clusterModeStatus];
}

-(SDLClusterModeStatus*) clusterModeStatus {
    NSObject* obj = [parameters objectForKey:NAMES_clusterModeStatus];
    if ([obj isKindOfClass:SDLClusterModeStatus.class]) {
        return (SDLClusterModeStatus*)obj;
    } else {
        return [[SDLClusterModeStatus alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setMyKey:(SDLMyKey *)myKey {
    [parameters setOrRemoveObject:myKey forKey:NAMES_myKey];
}

-(SDLMyKey*) myKey {
    NSObject* obj = [parameters objectForKey:NAMES_myKey];
    if ([obj isKindOfClass:SDLMyKey.class]) {
        return (SDLMyKey*)obj;
    } else {
        return [[SDLMyKey alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

@end
