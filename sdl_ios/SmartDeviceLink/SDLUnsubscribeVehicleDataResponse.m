//  SDLUnsubscribeVehicleDataResponse.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLUnsubscribeVehicleDataResponse.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLUnsubscribeVehicleDataResponse

-(id) init {
    if (self = [super initWithName:NAMES_UnsubscribeVehicleData]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setGps:(SDLVehicleDataResult *)gps {
    [parameters setOrRemoveObject:gps forKey:NAMES_gps];
}

-(SDLVehicleDataResult*) gps {
    NSObject* obj = [parameters objectForKey:NAMES_gps];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setSpeed:(SDLVehicleDataResult *)speed {
    [parameters setOrRemoveObject:speed forKey:NAMES_speed];
}

-(SDLVehicleDataResult*) speed {
    NSObject* obj = [parameters objectForKey:NAMES_speed];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setRpm:(SDLVehicleDataResult *)rpm {
    [parameters setOrRemoveObject:rpm forKey:NAMES_rpm];
}

-(SDLVehicleDataResult*) rpm {
    NSObject* obj = [parameters objectForKey:NAMES_rpm];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setFuelLevel:(SDLVehicleDataResult *)fuelLevel {
    [parameters setOrRemoveObject:fuelLevel forKey:NAMES_fuelLevel];
}

-(SDLVehicleDataResult*) fuelLevel {
    NSObject* obj = [parameters objectForKey:NAMES_fuelLevel];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setFuelLevel_State:(SDLVehicleDataResult *)fuelLevel_State {
    [parameters setOrRemoveObject:fuelLevel_State forKey:NAMES_fuelLevel_State];
}

-(SDLVehicleDataResult*) fuelLevel_State {
    NSObject* obj = [parameters objectForKey:NAMES_fuelLevel_State];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setInstantFuelConsumption:(SDLVehicleDataResult *)instantFuelConsumption {
    [parameters setOrRemoveObject:instantFuelConsumption forKey:NAMES_instantFuelConsumption];
}

-(SDLVehicleDataResult*) instantFuelConsumption {
    NSObject* obj = [parameters objectForKey:NAMES_instantFuelConsumption];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setExternalTemperature:(SDLVehicleDataResult *)externalTemperature {
    [parameters setOrRemoveObject:externalTemperature forKey:NAMES_externalTemperature];
}

-(SDLVehicleDataResult*) externalTemperature {
    NSObject* obj = [parameters objectForKey:NAMES_externalTemperature];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setPrndl:(SDLVehicleDataResult *)prndl {
    [parameters setOrRemoveObject:prndl forKey:NAMES_prndl];
}

-(SDLVehicleDataResult*) prndl {
    NSObject* obj = [parameters objectForKey:NAMES_prndl];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setTirePressure:(SDLVehicleDataResult *)tirePressure {
    [parameters setOrRemoveObject:tirePressure forKey:NAMES_tirePressure];
}

-(SDLVehicleDataResult*) tirePressure {
    NSObject* obj = [parameters objectForKey:NAMES_tirePressure];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setOdometer:(SDLVehicleDataResult *)odometer {
    [parameters setOrRemoveObject:odometer forKey:NAMES_odometer];
}

-(SDLVehicleDataResult*) odometer {
    NSObject* obj = [parameters objectForKey:NAMES_odometer];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setBeltStatus:(SDLVehicleDataResult *)beltStatus {
    [parameters setOrRemoveObject:beltStatus forKey:NAMES_beltStatus];
}

-(SDLVehicleDataResult*) beltStatus {
    NSObject* obj = [parameters objectForKey:NAMES_beltStatus];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setBodyInformation:(SDLVehicleDataResult *)bodyInformation {
    [parameters setOrRemoveObject:bodyInformation forKey:NAMES_bodyInformation];
}

-(SDLVehicleDataResult*) bodyInformation {
    NSObject* obj = [parameters objectForKey:NAMES_bodyInformation];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setDeviceStatus:(SDLVehicleDataResult *)deviceStatus {
    [parameters setOrRemoveObject:deviceStatus forKey:NAMES_deviceStatus];
}

-(SDLVehicleDataResult*) deviceStatus {
    NSObject* obj = [parameters objectForKey:NAMES_deviceStatus];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setDriverBraking:(SDLVehicleDataResult *)driverBraking {
    [parameters setOrRemoveObject:driverBraking forKey:NAMES_driverBraking];
}

-(SDLVehicleDataResult*) driverBraking {
    NSObject* obj = [parameters objectForKey:NAMES_driverBraking];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setWiperStatus:(SDLVehicleDataResult *)wiperStatus {
    [parameters setOrRemoveObject:wiperStatus forKey:NAMES_wiperStatus];
}

-(SDLVehicleDataResult*) wiperStatus {
    NSObject* obj = [parameters objectForKey:NAMES_wiperStatus];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setHeadLampStatus:(SDLVehicleDataResult *)headLampStatus {
    [parameters setOrRemoveObject:headLampStatus forKey:NAMES_headLampStatus];
}

-(SDLVehicleDataResult*) headLampStatus {
    NSObject* obj = [parameters objectForKey:NAMES_headLampStatus];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setEngineTorque:(SDLVehicleDataResult *)engineTorque {
    [parameters setOrRemoveObject:engineTorque forKey:NAMES_engineTorque];
}

-(SDLVehicleDataResult*) engineTorque {
    NSObject* obj = [parameters objectForKey:NAMES_engineTorque];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setAccPedalPosition:(SDLVehicleDataResult *)accPedalPosition {
    [parameters setOrRemoveObject:accPedalPosition forKey:NAMES_accPedalPosition];
}

-(SDLVehicleDataResult*) accPedalPosition {
    NSObject* obj = [parameters objectForKey:NAMES_accPedalPosition];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setSteeringWheelAngle:(SDLVehicleDataResult *)steeringWheelAngle {
    [parameters setOrRemoveObject:steeringWheelAngle forKey:NAMES_steeringWheelAngle];
}

-(SDLVehicleDataResult*) steeringWheelAngle {
    NSObject* obj = [parameters objectForKey:NAMES_steeringWheelAngle];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setECallInfo:(SDLVehicleDataResult *)eCallInfo {
    [parameters setOrRemoveObject:eCallInfo forKey:NAMES_eCallInfo];
}

-(SDLVehicleDataResult*) eCallInfo {
    NSObject* obj = [parameters objectForKey:NAMES_eCallInfo];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setAirbagStatus:(SDLVehicleDataResult *)airbagStatus {
    [parameters setOrRemoveObject:airbagStatus forKey:NAMES_airbagStatus];
}

-(SDLVehicleDataResult*) airbagStatus {
    NSObject* obj = [parameters objectForKey:NAMES_airbagStatus];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setEmergencyEvent:(SDLVehicleDataResult *)emergencyEvent {
    [parameters setOrRemoveObject:emergencyEvent forKey:NAMES_emergencyEvent];
}

-(SDLVehicleDataResult*) emergencyEvent {
    NSObject* obj = [parameters objectForKey:NAMES_emergencyEvent];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setClusterModes:(SDLVehicleDataResult *)clusterModes {
    [parameters setOrRemoveObject:clusterModes forKey:NAMES_clusterModes];
}

-(SDLVehicleDataResult*) clusterModes {
    NSObject* obj = [parameters objectForKey:NAMES_clusterModes];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

- (void)setMyKey:(SDLVehicleDataResult *)myKey {
    [parameters setOrRemoveObject:myKey forKey:NAMES_myKey];
}

-(SDLVehicleDataResult*) myKey {
    NSObject* obj = [parameters objectForKey:NAMES_myKey];
    if ([obj isKindOfClass:SDLVehicleDataResult.class]) {
        return (SDLVehicleDataResult*)obj;
    } else {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

@end
