//  SDLOnVehicleData.m
//

#import "SDLOnVehicleData.h"

#import "SDLAirbagStatus.h"
#import "SDLBeltStatus.h"
#import "SDLBodyInformation.h"
#import "SDLClusterModeStatus.h"
#import "SDLComponentVolumeStatus.h"
#import "SDLDeviceStatus.h"
#import "SDLECallInfo.h"
#import "SDLEmergencyEvent.h"
#import "SDLGPSData.h"
#import "SDLHeadLampStatus.h"
#import "SDLMyKey.h"
#import "SDLNames.h"
#import "SDLPRNDL.h"
#import "SDLTireStatus.h"
#import "SDLVehicleDataEventStatus.h"
#import "SDLWiperStatus.h"


@implementation SDLOnVehicleData

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnVehicleData]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setGps:(SDLGPSData *)gps {
    if (gps != nil) {
        [parameters setObject:gps forKey:SDLNameGPS];
    } else {
        [parameters removeObjectForKey:SDLNameGPS];
    }
}

- (SDLGPSData *)gps {
    NSObject *obj = [parameters objectForKey:SDLNameGPS];
    if (obj == nil || [obj isKindOfClass:SDLGPSData.class]) {
        return (SDLGPSData *)obj;
    } else {
        return [[SDLGPSData alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
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

- (void)setFuelLevel_State:(SDLComponentVolumeStatus *)fuelLevel_State {
    if (fuelLevel_State != nil) {
        [parameters setObject:fuelLevel_State forKey:SDLNameFuelLevelState];
    } else {
        [parameters removeObjectForKey:SDLNameFuelLevelState];
    }
}

- (SDLComponentVolumeStatus *)fuelLevel_State {
    NSObject *obj = [parameters objectForKey:SDLNameFuelLevelState];
    if (obj == nil || [obj isKindOfClass:SDLComponentVolumeStatus.class]) {
        return (SDLComponentVolumeStatus *)obj;
    } else {
        return [SDLComponentVolumeStatus valueOf:(NSString *)obj];
    }
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

- (void)setVin:(NSString *)vin {
    if (vin != nil) {
        [parameters setObject:vin forKey:SDLNameVIN];
    } else {
        [parameters removeObjectForKey:SDLNameVIN];
    }
}

- (NSString *)vin {
    return [parameters objectForKey:SDLNameVIN];
}

- (void)setPrndl:(SDLPRNDL *)prndl {
    if (prndl != nil) {
        [parameters setObject:prndl forKey:SDLNamePRNDL];
    } else {
        [parameters removeObjectForKey:SDLNamePRNDL];
    }
}

- (SDLPRNDL *)prndl {
    NSObject *obj = [parameters objectForKey:SDLNamePRNDL];
    if (obj == nil || [obj isKindOfClass:SDLPRNDL.class]) {
        return (SDLPRNDL *)obj;
    } else {
        return [SDLPRNDL valueOf:(NSString *)obj];
    }
}

- (void)setTirePressure:(SDLTireStatus *)tirePressure {
    if (tirePressure != nil) {
        [parameters setObject:tirePressure forKey:SDLNameTirePressure];
    } else {
        [parameters removeObjectForKey:SDLNameTirePressure];
    }
}

- (SDLTireStatus *)tirePressure {
    NSObject *obj = [parameters objectForKey:SDLNameTirePressure];
    if (obj == nil || [obj isKindOfClass:SDLTireStatus.class]) {
        return (SDLTireStatus *)obj;
    } else {
        return [[SDLTireStatus alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
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

- (void)setBeltStatus:(SDLBeltStatus *)beltStatus {
    if (beltStatus != nil) {
        [parameters setObject:beltStatus forKey:SDLNameBeltStatus];
    } else {
        [parameters removeObjectForKey:SDLNameBeltStatus];
    }
}

- (SDLBeltStatus *)beltStatus {
    NSObject *obj = [parameters objectForKey:SDLNameBeltStatus];
    if (obj == nil || [obj isKindOfClass:SDLBeltStatus.class]) {
        return (SDLBeltStatus *)obj;
    } else {
        return [[SDLBeltStatus alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setBodyInformation:(SDLBodyInformation *)bodyInformation {
    if (bodyInformation != nil) {
        [parameters setObject:bodyInformation forKey:SDLNameBodyInformation];
    } else {
        [parameters removeObjectForKey:SDLNameBodyInformation];
    }
}

- (SDLBodyInformation *)bodyInformation {
    NSObject *obj = [parameters objectForKey:SDLNameBodyInformation];
    if (obj == nil || [obj isKindOfClass:SDLBodyInformation.class]) {
        return (SDLBodyInformation *)obj;
    } else {
        return [[SDLBodyInformation alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setDeviceStatus:(SDLDeviceStatus *)deviceStatus {
    if (deviceStatus != nil) {
        [parameters setObject:deviceStatus forKey:SDLNameDeviceStatus];
    } else {
        [parameters removeObjectForKey:SDLNameDeviceStatus];
    }
}

- (SDLDeviceStatus *)deviceStatus {
    NSObject *obj = [parameters objectForKey:SDLNameDeviceStatus];
    if (obj == nil || [obj isKindOfClass:SDLDeviceStatus.class]) {
        return (SDLDeviceStatus *)obj;
    } else {
        return [[SDLDeviceStatus alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setDriverBraking:(SDLVehicleDataEventStatus *)driverBraking {
    if (driverBraking != nil) {
        [parameters setObject:driverBraking forKey:SDLNameDriverBraking];
    } else {
        [parameters removeObjectForKey:SDLNameDriverBraking];
    }
}

- (SDLVehicleDataEventStatus *)driverBraking {
    NSObject *obj = [parameters objectForKey:SDLNameDriverBraking];
    if (obj == nil || [obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus *)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString *)obj];
    }
}

- (void)setWiperStatus:(SDLWiperStatus *)wiperStatus {
    if (wiperStatus != nil) {
        [parameters setObject:wiperStatus forKey:SDLNameWiperStatus];
    } else {
        [parameters removeObjectForKey:SDLNameWiperStatus];
    }
}

- (SDLWiperStatus *)wiperStatus {
    NSObject *obj = [parameters objectForKey:SDLNameWiperStatus];
    if (obj == nil || [obj isKindOfClass:SDLWiperStatus.class]) {
        return (SDLWiperStatus *)obj;
    } else {
        return [SDLWiperStatus valueOf:(NSString *)obj];
    }
}

- (void)setHeadLampStatus:(SDLHeadLampStatus *)headLampStatus {
    if (headLampStatus != nil) {
        [parameters setObject:headLampStatus forKey:SDLNameHeadLampStatus];
    } else {
        [parameters removeObjectForKey:SDLNameHeadLampStatus];
    }
}

- (SDLHeadLampStatus *)headLampStatus {
    NSObject *obj = [parameters objectForKey:SDLNameHeadLampStatus];
    if (obj == nil || [obj isKindOfClass:SDLHeadLampStatus.class]) {
        return (SDLHeadLampStatus *)obj;
    } else {
        return [[SDLHeadLampStatus alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
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

- (void)setECallInfo:(SDLECallInfo *)eCallInfo {
    if (eCallInfo != nil) {
        [parameters setObject:eCallInfo forKey:SDLNameECallInfo];
    } else {
        [parameters removeObjectForKey:SDLNameECallInfo];
    }
}

- (SDLECallInfo *)eCallInfo {
    NSObject *obj = [parameters objectForKey:SDLNameECallInfo];
    if (obj == nil || [obj isKindOfClass:SDLECallInfo.class]) {
        return (SDLECallInfo *)obj;
    } else {
        return [[SDLECallInfo alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setAirbagStatus:(SDLAirbagStatus *)airbagStatus {
    if (airbagStatus != nil) {
        [parameters setObject:airbagStatus forKey:SDLNameAirbagStatus];
    } else {
        [parameters removeObjectForKey:SDLNameAirbagStatus];
    }
}

- (SDLAirbagStatus *)airbagStatus {
    NSObject *obj = [parameters objectForKey:SDLNameAirbagStatus];
    if (obj == nil || [obj isKindOfClass:SDLAirbagStatus.class]) {
        return (SDLAirbagStatus *)obj;
    } else {
        return [[SDLAirbagStatus alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setEmergencyEvent:(SDLEmergencyEvent *)emergencyEvent {
    if (emergencyEvent != nil) {
        [parameters setObject:emergencyEvent forKey:SDLNameEmergencyEvent];
    } else {
        [parameters removeObjectForKey:SDLNameEmergencyEvent];
    }
}

- (SDLEmergencyEvent *)emergencyEvent {
    NSObject *obj = [parameters objectForKey:SDLNameEmergencyEvent];
    if (obj == nil || [obj isKindOfClass:SDLEmergencyEvent.class]) {
        return (SDLEmergencyEvent *)obj;
    } else {
        return [[SDLEmergencyEvent alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setClusterModeStatus:(SDLClusterModeStatus *)clusterModeStatus {
    if (clusterModeStatus != nil) {
        [parameters setObject:clusterModeStatus forKey:SDLNameClusterModeStatus];
    } else {
        [parameters removeObjectForKey:SDLNameClusterModeStatus];
    }
}

- (SDLClusterModeStatus *)clusterModeStatus {
    NSObject *obj = [parameters objectForKey:SDLNameClusterModeStatus];
    if (obj == nil || [obj isKindOfClass:SDLClusterModeStatus.class]) {
        return (SDLClusterModeStatus *)obj;
    } else {
        return [[SDLClusterModeStatus alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setMyKey:(SDLMyKey *)myKey {
    if (myKey != nil) {
        [parameters setObject:myKey forKey:SDLNameMyKey];
    } else {
        [parameters removeObjectForKey:SDLNameMyKey];
    }
}

- (SDLMyKey *)myKey {
    NSObject *obj = [parameters objectForKey:SDLNameMyKey];
    if (obj == nil || [obj isKindOfClass:SDLMyKey.class]) {
        return (SDLMyKey *)obj;
    } else {
        return [[SDLMyKey alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
