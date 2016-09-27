//  SDLUnsubscribeVehicleData.m
//


#import "SDLUnsubscribeVehicleData.h"

#import "SDLNames.h"

@implementation SDLUnsubscribeVehicleData

- (instancetype)init {
    if (self = [super initWithName:SDLNameUnsubscribeVehicleData]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setGps:(NSNumber *)gps {
    if (gps != nil) {
        [parameters setObject:gps forKey:SDLNameGPS];
    } else {
        [parameters removeObjectForKey:SDLNameGPS];
    }
}

- (NSNumber *)gps {
    return [parameters objectForKey:SDLNameGPS];
}

- (void)setSpeed:(NSNumber *)speed {
    if (speed != nil) {
        [parameters setObject:speed forKey:SDLNameSpeed];
    } else {
        [parameters removeObjectForKey:SDLNameSpeed];
    }
}

- (NSNumber *)speed {
    return [parameters objectForKey:SDLNameSpeed];
}

- (void)setRpm:(NSNumber *)rpm {
    if (rpm != nil) {
        [parameters setObject:rpm forKey:SDLNameRPM];
    } else {
        [parameters removeObjectForKey:SDLNameRPM];
    }
}

- (NSNumber *)rpm {
    return [parameters objectForKey:SDLNameRPM];
}

- (void)setFuelLevel:(NSNumber *)fuelLevel {
    if (fuelLevel != nil) {
        [parameters setObject:fuelLevel forKey:SDLNameFuelLevel];
    } else {
        [parameters removeObjectForKey:SDLNameFuelLevel];
    }
}

- (NSNumber *)fuelLevel {
    return [parameters objectForKey:SDLNameFuelLevel];
}

- (void)setFuelLevel_State:(NSNumber *)fuelLevel_State {
    if (fuelLevel_State != nil) {
        [parameters setObject:fuelLevel_State forKey:SDLNameFuelLevelState];
    } else {
        [parameters removeObjectForKey:SDLNameFuelLevelState];
    }
}

- (NSNumber *)fuelLevel_State {
    return [parameters objectForKey:SDLNameFuelLevelState];
}

- (void)setInstantFuelConsumption:(NSNumber *)instantFuelConsumption {
    if (instantFuelConsumption != nil) {
        [parameters setObject:instantFuelConsumption forKey:SDLNameInstantFuelConsumption];
    } else {
        [parameters removeObjectForKey:SDLNameInstantFuelConsumption];
    }
}

- (NSNumber *)instantFuelConsumption {
    return [parameters objectForKey:SDLNameInstantFuelConsumption];
}

- (void)setExternalTemperature:(NSNumber *)externalTemperature {
    if (externalTemperature != nil) {
        [parameters setObject:externalTemperature forKey:SDLNameExternalTemperature];
    } else {
        [parameters removeObjectForKey:SDLNameExternalTemperature];
    }
}

- (NSNumber *)externalTemperature {
    return [parameters objectForKey:SDLNameExternalTemperature];
}

- (void)setPrndl:(NSNumber *)prndl {
    if (prndl != nil) {
        [parameters setObject:prndl forKey:SDLNamePRNDL];
    } else {
        [parameters removeObjectForKey:SDLNamePRNDL];
    }
}

- (NSNumber *)prndl {
    return [parameters objectForKey:SDLNamePRNDL];
}

- (void)setTirePressure:(NSNumber *)tirePressure {
    if (tirePressure != nil) {
        [parameters setObject:tirePressure forKey:SDLNameTirePressure];
    } else {
        [parameters removeObjectForKey:SDLNameTirePressure];
    }
}

- (NSNumber *)tirePressure {
    return [parameters objectForKey:SDLNameTirePressure];
}

- (void)setOdometer:(NSNumber *)odometer {
    if (odometer != nil) {
        [parameters setObject:odometer forKey:SDLNameOdometer];
    } else {
        [parameters removeObjectForKey:SDLNameOdometer];
    }
}

- (NSNumber *)odometer {
    return [parameters objectForKey:SDLNameOdometer];
}

- (void)setBeltStatus:(NSNumber *)beltStatus {
    if (beltStatus != nil) {
        [parameters setObject:beltStatus forKey:SDLNameBeltStatus];
    } else {
        [parameters removeObjectForKey:SDLNameBeltStatus];
    }
}

- (NSNumber *)beltStatus {
    return [parameters objectForKey:SDLNameBeltStatus];
}

- (void)setBodyInformation:(NSNumber *)bodyInformation {
    if (bodyInformation != nil) {
        [parameters setObject:bodyInformation forKey:SDLNameBodyInformation];
    } else {
        [parameters removeObjectForKey:SDLNameBodyInformation];
    }
}

- (NSNumber *)bodyInformation {
    return [parameters objectForKey:SDLNameBodyInformation];
}

- (void)setDeviceStatus:(NSNumber *)deviceStatus {
    if (deviceStatus != nil) {
        [parameters setObject:deviceStatus forKey:SDLNameDeviceStatus];
    } else {
        [parameters removeObjectForKey:SDLNameDeviceStatus];
    }
}

- (NSNumber *)deviceStatus {
    return [parameters objectForKey:SDLNameDeviceStatus];
}

- (void)setDriverBraking:(NSNumber *)driverBraking {
    if (driverBraking != nil) {
        [parameters setObject:driverBraking forKey:SDLNameDriverBraking];
    } else {
        [parameters removeObjectForKey:SDLNameDriverBraking];
    }
}

- (NSNumber *)driverBraking {
    return [parameters objectForKey:SDLNameDriverBraking];
}

- (void)setWiperStatus:(NSNumber *)wiperStatus {
    if (wiperStatus != nil) {
        [parameters setObject:wiperStatus forKey:SDLNameWiperStatus];
    } else {
        [parameters removeObjectForKey:SDLNameWiperStatus];
    }
}

- (NSNumber *)wiperStatus {
    return [parameters objectForKey:SDLNameWiperStatus];
}

- (void)setHeadLampStatus:(NSNumber *)headLampStatus {
    if (headLampStatus != nil) {
        [parameters setObject:headLampStatus forKey:SDLNameHeadLampStatus];
    } else {
        [parameters removeObjectForKey:SDLNameHeadLampStatus];
    }
}

- (NSNumber *)headLampStatus {
    return [parameters objectForKey:SDLNameHeadLampStatus];
}

- (void)setEngineTorque:(NSNumber *)engineTorque {
    if (engineTorque != nil) {
        [parameters setObject:engineTorque forKey:SDLNameEngineTorque];
    } else {
        [parameters removeObjectForKey:SDLNameEngineTorque];
    }
}

- (NSNumber *)engineTorque {
    return [parameters objectForKey:SDLNameEngineTorque];
}

- (void)setAccPedalPosition:(NSNumber *)accPedalPosition {
    if (accPedalPosition != nil) {
        [parameters setObject:accPedalPosition forKey:SDLNameAccelerationPedalPosition];
    } else {
        [parameters removeObjectForKey:SDLNameAccelerationPedalPosition];
    }
}

- (NSNumber *)accPedalPosition {
    return [parameters objectForKey:SDLNameAccelerationPedalPosition];
}

- (void)setSteeringWheelAngle:(NSNumber *)steeringWheelAngle {
    if (steeringWheelAngle != nil) {
        [parameters setObject:steeringWheelAngle forKey:SDLNameSteeringWheelAngle];
    } else {
        [parameters removeObjectForKey:SDLNameSteeringWheelAngle];
    }
}

- (NSNumber *)steeringWheelAngle {
    return [parameters objectForKey:SDLNameSteeringWheelAngle];
}

- (void)setECallInfo:(NSNumber *)eCallInfo {
    if (eCallInfo != nil) {
        [parameters setObject:eCallInfo forKey:SDLNameECallInfo];
    } else {
        [parameters removeObjectForKey:SDLNameECallInfo];
    }
}

- (NSNumber *)eCallInfo {
    return [parameters objectForKey:SDLNameECallInfo];
}

- (void)setAirbagStatus:(NSNumber *)airbagStatus {
    if (airbagStatus != nil) {
        [parameters setObject:airbagStatus forKey:SDLNameAirbagStatus];
    } else {
        [parameters removeObjectForKey:SDLNameAirbagStatus];
    }
}

- (NSNumber *)airbagStatus {
    return [parameters objectForKey:SDLNameAirbagStatus];
}

- (void)setEmergencyEvent:(NSNumber *)emergencyEvent {
    if (emergencyEvent != nil) {
        [parameters setObject:emergencyEvent forKey:SDLNameEmergencyEvent];
    } else {
        [parameters removeObjectForKey:SDLNameEmergencyEvent];
    }
}

- (NSNumber *)emergencyEvent {
    return [parameters objectForKey:SDLNameEmergencyEvent];
}

- (void)setClusterModeStatus:(NSNumber *)clusterModeStatus {
    if (clusterModeStatus != nil) {
        [parameters setObject:clusterModeStatus forKey:SDLNameClusterModeStatus];
    } else {
        [parameters removeObjectForKey:SDLNameClusterModeStatus];
    }
}

- (NSNumber *)clusterModeStatus {
    return [parameters objectForKey:SDLNameClusterModeStatus];
}

- (void)setMyKey:(NSNumber *)myKey {
    if (myKey != nil) {
        [parameters setObject:myKey forKey:SDLNameMyKey];
    } else {
        [parameters removeObjectForKey:SDLNameMyKey];
    }
}

- (NSNumber *)myKey {
    return [parameters objectForKey:SDLNameMyKey];
}

@end
