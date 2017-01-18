//  SDLUnsubscribeVehicleDataResponse.m
//


#import "SDLUnsubscribeVehicleDataResponse.h"

#import "SDLNames.h"
#import "SDLVehicleDataResult.h"

@implementation SDLUnsubscribeVehicleDataResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameUnsubscribeVehicleData]) {
    }
    return self;
}

- (void)setGps:(nullable SDLVehicleDataResult *)gps {
    if (gps != nil) {
        [parameters setObject:gps forKey:SDLNameGPS];
    } else {
        [parameters removeObjectForKey:SDLNameGPS];
    }
}

- (nullable SDLVehicleDataResult *)gps {
    NSObject *obj = [parameters objectForKey:SDLNameGPS];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setSpeed:(nullable SDLVehicleDataResult *)speed {
    if (speed != nil) {
        [parameters setObject:speed forKey:SDLNameSpeed];
    } else {
        [parameters removeObjectForKey:SDLNameSpeed];
    }
}

- (nullable SDLVehicleDataResult *)speed {
    NSObject *obj = [parameters objectForKey:SDLNameSpeed];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setRpm:(nullable SDLVehicleDataResult *)rpm {
    if (rpm != nil) {
        [parameters setObject:rpm forKey:SDLNameRPM];
    } else {
        [parameters removeObjectForKey:SDLNameRPM];
    }
}

- (nullable SDLVehicleDataResult *)rpm {
    NSObject *obj = [parameters objectForKey:SDLNameRPM];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setFuelLevel:(nullable SDLVehicleDataResult *)fuelLevel {
    if (fuelLevel != nil) {
        [parameters setObject:fuelLevel forKey:SDLNameFuelLevel];
    } else {
        [parameters removeObjectForKey:SDLNameFuelLevel];
    }
}

- (nullable SDLVehicleDataResult *)fuelLevel {
    NSObject *obj = [parameters objectForKey:SDLNameFuelLevel];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setFuelLevel_State:(nullable SDLVehicleDataResult *)fuelLevel_State {
    if (fuelLevel_State != nil) {
        [parameters setObject:fuelLevel_State forKey:SDLNameFuelLevelState];
    } else {
        [parameters removeObjectForKey:SDLNameFuelLevelState];
    }
}

- (nullable SDLVehicleDataResult *)fuelLevel_State {
    NSObject *obj = [parameters objectForKey:SDLNameFuelLevelState];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setInstantFuelConsumption:(nullable SDLVehicleDataResult *)instantFuelConsumption {
    if (instantFuelConsumption != nil) {
        [parameters setObject:instantFuelConsumption forKey:SDLNameInstantFuelConsumption];
    } else {
        [parameters removeObjectForKey:SDLNameInstantFuelConsumption];
    }
}

- (nullable SDLVehicleDataResult *)instantFuelConsumption {
    NSObject *obj = [parameters objectForKey:SDLNameInstantFuelConsumption];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setExternalTemperature:(nullable SDLVehicleDataResult *)externalTemperature {
    if (externalTemperature != nil) {
        [parameters setObject:externalTemperature forKey:SDLNameExternalTemperature];
    } else {
        [parameters removeObjectForKey:SDLNameExternalTemperature];
    }
}

- (nullable SDLVehicleDataResult *)externalTemperature {
    NSObject *obj = [parameters objectForKey:SDLNameExternalTemperature];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setPrndl:(nullable SDLVehicleDataResult *)prndl {
    if (prndl != nil) {
        [parameters setObject:prndl forKey:SDLNamePRNDL];
    } else {
        [parameters removeObjectForKey:SDLNamePRNDL];
    }
}

- (nullable SDLVehicleDataResult *)prndl {
    NSObject *obj = [parameters objectForKey:SDLNamePRNDL];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setTirePressure:(nullable SDLVehicleDataResult *)tirePressure {
    if (tirePressure != nil) {
        [parameters setObject:tirePressure forKey:SDLNameTirePressure];
    } else {
        [parameters removeObjectForKey:SDLNameTirePressure];
    }
}

- (nullable SDLVehicleDataResult *)tirePressure {
    NSObject *obj = [parameters objectForKey:SDLNameTirePressure];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setOdometer:(nullable SDLVehicleDataResult *)odometer {
    if (odometer != nil) {
        [parameters setObject:odometer forKey:SDLNameOdometer];
    } else {
        [parameters removeObjectForKey:SDLNameOdometer];
    }
}

- (nullable SDLVehicleDataResult *)odometer {
    NSObject *obj = [parameters objectForKey:SDLNameOdometer];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setBeltStatus:(nullable SDLVehicleDataResult *)beltStatus {
    if (beltStatus != nil) {
        [parameters setObject:beltStatus forKey:SDLNameBeltStatus];
    } else {
        [parameters removeObjectForKey:SDLNameBeltStatus];
    }
}

- (nullable SDLVehicleDataResult *)beltStatus {
    NSObject *obj = [parameters objectForKey:SDLNameBeltStatus];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setBodyInformation:(nullable SDLVehicleDataResult *)bodyInformation {
    if (bodyInformation != nil) {
        [parameters setObject:bodyInformation forKey:SDLNameBodyInformation];
    } else {
        [parameters removeObjectForKey:SDLNameBodyInformation];
    }
}

- (nullable SDLVehicleDataResult *)bodyInformation {
    NSObject *obj = [parameters objectForKey:SDLNameBodyInformation];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setDeviceStatus:(nullable SDLVehicleDataResult *)deviceStatus {
    if (deviceStatus != nil) {
        [parameters setObject:deviceStatus forKey:SDLNameDeviceStatus];
    } else {
        [parameters removeObjectForKey:SDLNameDeviceStatus];
    }
}

- (nullable SDLVehicleDataResult *)deviceStatus {
    NSObject *obj = [parameters objectForKey:SDLNameDeviceStatus];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setDriverBraking:(nullable SDLVehicleDataResult *)driverBraking {
    if (driverBraking != nil) {
        [parameters setObject:driverBraking forKey:SDLNameDriverBraking];
    } else {
        [parameters removeObjectForKey:SDLNameDriverBraking];
    }
}

- (nullable SDLVehicleDataResult *)driverBraking {
    NSObject *obj = [parameters objectForKey:SDLNameDriverBraking];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setWiperStatus:(nullable SDLVehicleDataResult *)wiperStatus {
    if (wiperStatus != nil) {
        [parameters setObject:wiperStatus forKey:SDLNameWiperStatus];
    } else {
        [parameters removeObjectForKey:SDLNameWiperStatus];
    }
}

- (nullable SDLVehicleDataResult *)wiperStatus {
    NSObject *obj = [parameters objectForKey:SDLNameWiperStatus];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setHeadLampStatus:(nullable SDLVehicleDataResult *)headLampStatus {
    if (headLampStatus != nil) {
        [parameters setObject:headLampStatus forKey:SDLNameHeadLampStatus];
    } else {
        [parameters removeObjectForKey:SDLNameHeadLampStatus];
    }
}

- (nullable SDLVehicleDataResult *)headLampStatus {
    NSObject *obj = [parameters objectForKey:SDLNameHeadLampStatus];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setEngineTorque:(nullable SDLVehicleDataResult *)engineTorque {
    if (engineTorque != nil) {
        [parameters setObject:engineTorque forKey:SDLNameEngineTorque];
    } else {
        [parameters removeObjectForKey:SDLNameEngineTorque];
    }
}

- (nullable SDLVehicleDataResult *)engineTorque {
    NSObject *obj = [parameters objectForKey:SDLNameEngineTorque];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setAccPedalPosition:(nullable SDLVehicleDataResult *)accPedalPosition {
    if (accPedalPosition != nil) {
        [parameters setObject:accPedalPosition forKey:SDLNameAccelerationPedalPosition];
    } else {
        [parameters removeObjectForKey:SDLNameAccelerationPedalPosition];
    }
}

- (nullable SDLVehicleDataResult *)accPedalPosition {
    NSObject *obj = [parameters objectForKey:SDLNameAccelerationPedalPosition];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setSteeringWheelAngle:(nullable SDLVehicleDataResult *)steeringWheelAngle {
    if (steeringWheelAngle != nil) {
        [parameters setObject:steeringWheelAngle forKey:SDLNameSteeringWheelAngle];
    } else {
        [parameters removeObjectForKey:SDLNameSteeringWheelAngle];
    }
}

- (nullable SDLVehicleDataResult *)steeringWheelAngle {
    NSObject *obj = [parameters objectForKey:SDLNameSteeringWheelAngle];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setECallInfo:(nullable SDLVehicleDataResult *)eCallInfo {
    if (eCallInfo != nil) {
        [parameters setObject:eCallInfo forKey:SDLNameECallInfo];
    } else {
        [parameters removeObjectForKey:SDLNameECallInfo];
    }
}

- (nullable SDLVehicleDataResult *)eCallInfo {
    NSObject *obj = [parameters objectForKey:SDLNameECallInfo];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setAirbagStatus:(nullable SDLVehicleDataResult *)airbagStatus {
    if (airbagStatus != nil) {
        [parameters setObject:airbagStatus forKey:SDLNameAirbagStatus];
    } else {
        [parameters removeObjectForKey:SDLNameAirbagStatus];
    }
}

- (nullable SDLVehicleDataResult *)airbagStatus {
    NSObject *obj = [parameters objectForKey:SDLNameAirbagStatus];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setEmergencyEvent:(nullable SDLVehicleDataResult *)emergencyEvent {
    if (emergencyEvent != nil) {
        [parameters setObject:emergencyEvent forKey:SDLNameEmergencyEvent];
    } else {
        [parameters removeObjectForKey:SDLNameEmergencyEvent];
    }
}

- (nullable SDLVehicleDataResult *)emergencyEvent {
    NSObject *obj = [parameters objectForKey:SDLNameEmergencyEvent];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setClusterModes:(nullable SDLVehicleDataResult *)clusterModes {
    if (clusterModes != nil) {
        [parameters setObject:clusterModes forKey:SDLNameClusterModes];
    } else {
        [parameters removeObjectForKey:SDLNameClusterModes];
    }
}

- (nullable SDLVehicleDataResult *)clusterModes {
    NSObject *obj = [parameters objectForKey:SDLNameClusterModes];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

- (void)setMyKey:(nullable SDLVehicleDataResult *)myKey {
    if (myKey != nil) {
        [parameters setObject:myKey forKey:SDLNameMyKey];
    } else {
        [parameters removeObjectForKey:SDLNameMyKey];
    }
}

- (nullable SDLVehicleDataResult *)myKey {
    NSObject *obj = [parameters objectForKey:SDLNameMyKey];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLVehicleDataResult alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLVehicleDataResult*)obj;
}

@end
