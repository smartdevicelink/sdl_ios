//  SDLOnVehicleData.m
//

#import "SDLOnVehicleData.h"

#import "SDLAirbagStatus.h"
#import "SDLBeltStatus.h"
#import "SDLBodyInformation.h"
#import "SDLClusterModeStatus.h"
#import "SDLDeviceStatus.h"
#import "SDLECallInfo.h"
#import "SDLEmergencyEvent.h"
#import "SDLGPSData.h"
#import "SDLHeadLampStatus.h"
#import "SDLMyKey.h"
#import "SDLNames.h"
#import "SDLTireStatus.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnVehicleData

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnVehicleData]) {
    }
    return self;
}

- (void)setGps:(nullable SDLGPSData *)gps {
    if (gps != nil) {
        [parameters setObject:gps forKey:SDLNameGPS];
    } else {
        [parameters removeObjectForKey:SDLNameGPS];
    }
}

- (nullable SDLGPSData *)gps {
    NSObject *obj = [parameters objectForKey:SDLNameGPS];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLGPSData alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLGPSData*)obj;
}

- (void)setSpeed:(nullable NSNumber<SDLFloat> *)speed {
    if (speed != nil) {
        [parameters setObject:speed forKey:SDLNameSpeed];
    } else {
        [parameters removeObjectForKey:SDLNameSpeed];
    }
}

- (nullable NSNumber<SDLFloat> *)speed {
    return [parameters objectForKey:SDLNameSpeed];
}

- (void)setRpm:(nullable NSNumber<SDLInt> *)rpm {
    if (rpm != nil) {
        [parameters setObject:rpm forKey:SDLNameRPM];
    } else {
        [parameters removeObjectForKey:SDLNameRPM];
    }
}

- (nullable NSNumber<SDLInt> *)rpm {
    return [parameters objectForKey:SDLNameRPM];
}

- (void)setFuelLevel:(nullable NSNumber<SDLFloat> *)fuelLevel {
    if (fuelLevel != nil) {
        [parameters setObject:fuelLevel forKey:SDLNameFuelLevel];
    } else {
        [parameters removeObjectForKey:SDLNameFuelLevel];
    }
}

- (nullable NSNumber<SDLFloat> *)fuelLevel {
    return [parameters objectForKey:SDLNameFuelLevel];
}

- (void)setFuelLevel_State:(nullable SDLComponentVolumeStatus)fuelLevel_State {
    if (fuelLevel_State != nil) {
        [parameters setObject:fuelLevel_State forKey:SDLNameFuelLevelState];
    } else {
        [parameters removeObjectForKey:SDLNameFuelLevelState];
    }
}

- (nullable SDLComponentVolumeStatus)fuelLevel_State {
    NSObject *obj = [parameters objectForKey:SDLNameFuelLevelState];
    return (SDLComponentVolumeStatus)obj;
}

- (void)setInstantFuelConsumption:(nullable NSNumber<SDLFloat> *)instantFuelConsumption {
    if (instantFuelConsumption != nil) {
        [parameters setObject:instantFuelConsumption forKey:SDLNameInstantFuelConsumption];
    } else {
        [parameters removeObjectForKey:SDLNameInstantFuelConsumption];
    }
}

- (nullable NSNumber<SDLFloat> *)instantFuelConsumption {
    return [parameters objectForKey:SDLNameInstantFuelConsumption];
}

- (void)setExternalTemperature:(nullable NSNumber<SDLFloat> *)externalTemperature {
    if (externalTemperature != nil) {
        [parameters setObject:externalTemperature forKey:SDLNameExternalTemperature];
    } else {
        [parameters removeObjectForKey:SDLNameExternalTemperature];
    }
}

- (nullable NSNumber<SDLFloat> *)externalTemperature {
    return [parameters objectForKey:SDLNameExternalTemperature];
}

- (void)setVin:(nullable NSString *)vin {
    if (vin != nil) {
        [parameters setObject:vin forKey:SDLNameVIN];
    } else {
        [parameters removeObjectForKey:SDLNameVIN];
    }
}

- (nullable NSString *)vin {
    return [parameters objectForKey:SDLNameVIN];
}

- (void)setPrndl:(nullable SDLPRNDL)prndl {
    if (prndl != nil) {
        [parameters setObject:prndl forKey:SDLNamePRNDL];
    } else {
        [parameters removeObjectForKey:SDLNamePRNDL];
    }
}

- (nullable SDLPRNDL)prndl {
    NSObject *obj = [parameters objectForKey:SDLNamePRNDL];
    return (SDLPRNDL)obj;
}

- (void)setTirePressure:(nullable SDLTireStatus *)tirePressure {
    if (tirePressure != nil) {
        [parameters setObject:tirePressure forKey:SDLNameTirePressure];
    } else {
        [parameters removeObjectForKey:SDLNameTirePressure];
    }
}

- (nullable SDLTireStatus *)tirePressure {
    NSObject *obj = [parameters objectForKey:SDLNameTirePressure];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLTireStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLTireStatus*)obj;
}

- (void)setOdometer:(nullable NSNumber<SDLInt> *)odometer {
    if (odometer != nil) {
        [parameters setObject:odometer forKey:SDLNameOdometer];
    } else {
        [parameters removeObjectForKey:SDLNameOdometer];
    }
}

- (nullable NSNumber<SDLInt> *)odometer {
    return [parameters objectForKey:SDLNameOdometer];
}

- (void)setBeltStatus:(nullable SDLBeltStatus *)beltStatus {
    if (beltStatus != nil) {
        [parameters setObject:beltStatus forKey:SDLNameBeltStatus];
    } else {
        [parameters removeObjectForKey:SDLNameBeltStatus];
    }
}

- (nullable SDLBeltStatus *)beltStatus {
    NSObject *obj = [parameters objectForKey:SDLNameBeltStatus];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLBeltStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLBeltStatus*)obj;
}

- (void)setBodyInformation:(nullable SDLBodyInformation *)bodyInformation {
    if (bodyInformation != nil) {
        [parameters setObject:bodyInformation forKey:SDLNameBodyInformation];
    } else {
        [parameters removeObjectForKey:SDLNameBodyInformation];
    }
}

- (nullable SDLBodyInformation *)bodyInformation {
    NSObject *obj = [parameters objectForKey:SDLNameBodyInformation];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLBodyInformation alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLBodyInformation*)obj;
}

- (void)setDeviceStatus:(nullable SDLDeviceStatus *)deviceStatus {
    if (deviceStatus != nil) {
        [parameters setObject:deviceStatus forKey:SDLNameDeviceStatus];
    } else {
        [parameters removeObjectForKey:SDLNameDeviceStatus];
    }
}

- (nullable SDLDeviceStatus *)deviceStatus {
    NSObject *obj = [parameters objectForKey:SDLNameDeviceStatus];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLDeviceStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLDeviceStatus*)obj;
}

- (void)setDriverBraking:(nullable SDLVehicleDataEventStatus)driverBraking {
    if (driverBraking != nil) {
        [parameters setObject:driverBraking forKey:SDLNameDriverBraking];
    } else {
        [parameters removeObjectForKey:SDLNameDriverBraking];
    }
}

- (nullable SDLVehicleDataEventStatus)driverBraking {
    NSObject *obj = [parameters objectForKey:SDLNameDriverBraking];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setWiperStatus:(nullable SDLWiperStatus)wiperStatus {
    if (wiperStatus != nil) {
        [parameters setObject:wiperStatus forKey:SDLNameWiperStatus];
    } else {
        [parameters removeObjectForKey:SDLNameWiperStatus];
    }
}

- (nullable SDLWiperStatus)wiperStatus {
    NSObject *obj = [parameters objectForKey:SDLNameWiperStatus];
    return (SDLWiperStatus)obj;
}

- (void)setHeadLampStatus:(nullable SDLHeadLampStatus *)headLampStatus {
    if (headLampStatus != nil) {
        [parameters setObject:headLampStatus forKey:SDLNameHeadLampStatus];
    } else {
        [parameters removeObjectForKey:SDLNameHeadLampStatus];
    }
}

- (nullable SDLHeadLampStatus *)headLampStatus {
    NSObject *obj = [parameters objectForKey:SDLNameHeadLampStatus];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLHeadLampStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLHeadLampStatus*)obj;
}

- (void)setEngineTorque:(nullable NSNumber<SDLFloat> *)engineTorque {
    if (engineTorque != nil) {
        [parameters setObject:engineTorque forKey:SDLNameEngineTorque];
    } else {
        [parameters removeObjectForKey:SDLNameEngineTorque];
    }
}

- (nullable NSNumber<SDLFloat> *)engineTorque {
    return [parameters objectForKey:SDLNameEngineTorque];
}

- (void)setAccPedalPosition:(nullable NSNumber<SDLFloat> *)accPedalPosition {
    if (accPedalPosition != nil) {
        [parameters setObject:accPedalPosition forKey:SDLNameAccelerationPedalPosition];
    } else {
        [parameters removeObjectForKey:SDLNameAccelerationPedalPosition];
    }
}

- (nullable NSNumber<SDLFloat> *)accPedalPosition {
    return [parameters objectForKey:SDLNameAccelerationPedalPosition];
}

- (void)setSteeringWheelAngle:(nullable NSNumber<SDLFloat> *)steeringWheelAngle {
    if (steeringWheelAngle != nil) {
        [parameters setObject:steeringWheelAngle forKey:SDLNameSteeringWheelAngle];
    } else {
        [parameters removeObjectForKey:SDLNameSteeringWheelAngle];
    }
}

- (nullable NSNumber<SDLFloat> *)steeringWheelAngle {
    return [parameters objectForKey:SDLNameSteeringWheelAngle];
}

- (void)setECallInfo:(nullable SDLECallInfo *)eCallInfo {
    if (eCallInfo != nil) {
        [parameters setObject:eCallInfo forKey:SDLNameECallInfo];
    } else {
        [parameters removeObjectForKey:SDLNameECallInfo];
    }
}

- (nullable SDLECallInfo *)eCallInfo {
    NSObject *obj = [parameters objectForKey:SDLNameECallInfo];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLECallInfo alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLECallInfo*)obj;
}

- (void)setAirbagStatus:(nullable SDLAirbagStatus *)airbagStatus {
    if (airbagStatus != nil) {
        [parameters setObject:airbagStatus forKey:SDLNameAirbagStatus];
    } else {
        [parameters removeObjectForKey:SDLNameAirbagStatus];
    }
}

- (nullable SDLAirbagStatus *)airbagStatus {
    NSObject *obj = [parameters objectForKey:SDLNameAirbagStatus];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLAirbagStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLAirbagStatus*)obj;
}

- (void)setEmergencyEvent:(nullable SDLEmergencyEvent *)emergencyEvent {
    if (emergencyEvent != nil) {
        [parameters setObject:emergencyEvent forKey:SDLNameEmergencyEvent];
    } else {
        [parameters removeObjectForKey:SDLNameEmergencyEvent];
    }
}

- (nullable SDLEmergencyEvent *)emergencyEvent {
    NSObject *obj = [parameters objectForKey:SDLNameEmergencyEvent];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLEmergencyEvent alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLEmergencyEvent*)obj;
}

- (void)setClusterModeStatus:(nullable SDLClusterModeStatus *)clusterModeStatus {
    if (clusterModeStatus != nil) {
        [parameters setObject:clusterModeStatus forKey:SDLNameClusterModeStatus];
    } else {
        [parameters removeObjectForKey:SDLNameClusterModeStatus];
    }
}

- (nullable SDLClusterModeStatus *)clusterModeStatus {
    NSObject *obj = [parameters objectForKey:SDLNameClusterModeStatus];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLClusterModeStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLClusterModeStatus*)obj;
}

- (void)setMyKey:(nullable SDLMyKey *)myKey {
    if (myKey != nil) {
        [parameters setObject:myKey forKey:SDLNameMyKey];
    } else {
        [parameters removeObjectForKey:SDLNameMyKey];
    }
}

- (nullable SDLMyKey *)myKey {
    NSObject *obj = [parameters objectForKey:SDLNameMyKey];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLMyKey alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLMyKey*)obj;
}

@end

NS_ASSUME_NONNULL_END
