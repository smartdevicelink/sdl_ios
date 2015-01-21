//  SDLUnsubscribeVehicleData.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLUnsubscribeVehicleData.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLUnsubscribeVehicleData

-(id) init {
    if (self = [super initWithName:NAMES_UnsubscribeVehicleData]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setGps:(NSNumber *)gps {
    [parameters setOrRemoveObject:gps forKey:NAMES_gps];
}

-(NSNumber*) gps {
    return [parameters objectForKey:NAMES_gps];
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

- (void)setFuelLevel_State:(NSNumber *)fuelLevel_State {
    [parameters setOrRemoveObject:fuelLevel_State forKey:NAMES_fuelLevel_State];
}

-(NSNumber*) fuelLevel_State {
    return [parameters objectForKey:NAMES_fuelLevel_State];
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

- (void)setPrndl:(NSNumber *)prndl {
    [parameters setOrRemoveObject:prndl forKey:NAMES_prndl];
}

-(NSNumber*) prndl {
    return [parameters objectForKey:NAMES_prndl];
}

- (void)setTirePressure:(NSNumber *)tirePressure {
    [parameters setOrRemoveObject:tirePressure forKey:NAMES_tirePressure];
}

-(NSNumber*) tirePressure {
    return [parameters objectForKey:NAMES_tirePressure];
}

- (void)setOdometer:(NSNumber *)odometer {
    [parameters setOrRemoveObject:odometer forKey:NAMES_odometer];
}

-(NSNumber*) odometer {
    return [parameters objectForKey:NAMES_odometer];
}

- (void)setBeltStatus:(NSNumber *)beltStatus {
    [parameters setOrRemoveObject:beltStatus forKey:NAMES_beltStatus];
}

-(NSNumber*) beltStatus {
    return [parameters objectForKey:NAMES_beltStatus];
}

- (void)setBodyInformation:(NSNumber *)bodyInformation {
    [parameters setOrRemoveObject:bodyInformation forKey:NAMES_bodyInformation];
}

-(NSNumber*) bodyInformation {
    return [parameters objectForKey:NAMES_bodyInformation];
}

- (void)setDeviceStatus:(NSNumber *)deviceStatus {
    [parameters setOrRemoveObject:deviceStatus forKey:NAMES_deviceStatus];
}

-(NSNumber*) deviceStatus {
    return [parameters objectForKey:NAMES_deviceStatus];
}

- (void)setDriverBraking:(NSNumber *)driverBraking {
    [parameters setOrRemoveObject:driverBraking forKey:NAMES_driverBraking];
}

-(NSNumber*) driverBraking {
    return [parameters objectForKey:NAMES_driverBraking];
}

- (void)setWiperStatus:(NSNumber *)wiperStatus {
    [parameters setOrRemoveObject:wiperStatus forKey:NAMES_wiperStatus];
}

-(NSNumber*) wiperStatus {
    return [parameters objectForKey:NAMES_wiperStatus];
}

- (void)setHeadLampStatus:(NSNumber *)headLampStatus {
    [parameters setOrRemoveObject:headLampStatus forKey:NAMES_headLampStatus];
}

-(NSNumber*) headLampStatus {
    return [parameters objectForKey:NAMES_headLampStatus];
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

- (void)setECallInfo:(NSNumber *)eCallInfo {
    [parameters setOrRemoveObject:eCallInfo forKey:NAMES_eCallInfo];
}

-(NSNumber*) eCallInfo {
    return [parameters objectForKey:NAMES_eCallInfo];
}

- (void)setAirbagStatus:(NSNumber *)airbagStatus {
    [parameters setOrRemoveObject:airbagStatus forKey:NAMES_airbagStatus];
}

-(NSNumber*) airbagStatus {
    return [parameters objectForKey:NAMES_airbagStatus];
}

- (void)setEmergencyEvent:(NSNumber *)emergencyEvent {
    [parameters setOrRemoveObject:emergencyEvent forKey:NAMES_emergencyEvent];
}

-(NSNumber*) emergencyEvent {
    return [parameters objectForKey:NAMES_emergencyEvent];
}

- (void)setClusterModeStatus:(NSNumber *)clusterModeStatus {
    [parameters setOrRemoveObject:clusterModeStatus forKey:NAMES_clusterModeStatus];
}

-(NSNumber*) clusterModeStatus {
    return [parameters objectForKey:NAMES_clusterModeStatus];
}

- (void)setMyKey:(NSNumber *)myKey {
    [parameters setOrRemoveObject:myKey forKey:NAMES_myKey];
}

-(NSNumber*) myKey {
    return [parameters objectForKey:NAMES_myKey];
}

@end
