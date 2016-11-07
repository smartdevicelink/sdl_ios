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


@implementation SDLOnVehicleData

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnVehicleData]) {
    }
    return self;
}

- (void)setGps:(SDLGPSData *)gps {
    [self setObject:gps forName:SDLNameGPS];
}

- (SDLGPSData *)gps {
    NSObject *obj = [parameters objectForKey:SDLNameGPS];
    if (obj == nil || [obj isKindOfClass:SDLGPSData.class]) {
        return (SDLGPSData *)obj;
    } else {
        return [[SDLGPSData alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setSpeed:(NSNumber<SDLFloat> *)speed {
    [self setObject:speed forName:SDLNameSpeed];
}

- (NSNumber<SDLFloat> *)speed {
    return [parameters objectForKey:SDLNameSpeed];
}

- (void)setRpm:(NSNumber<SDLInt> *)rpm {
    [self setObject:rpm forName:SDLNameRPM];
}

- (NSNumber<SDLInt> *)rpm {
    return [parameters objectForKey:SDLNameRPM];
}

- (void)setFuelLevel:(NSNumber<SDLFloat> *)fuelLevel {
    [self setObject:fuelLevel forName:SDLNameFuelLevel];
}

- (NSNumber<SDLFloat> *)fuelLevel {
    return [parameters objectForKey:SDLNameFuelLevel];
}

- (void)setFuelLevel_State:(SDLComponentVolumeStatus)fuelLevel_State {
    [self setObject:fuelLevel_State forName:SDLNameFuelLevelState];
}

- (SDLComponentVolumeStatus)fuelLevel_State {
    NSObject *obj = [parameters objectForKey:SDLNameFuelLevelState];
    return (SDLComponentVolumeStatus)obj;
}

- (void)setInstantFuelConsumption:(NSNumber<SDLFloat> *)instantFuelConsumption {
    [self setObject:instantFuelConsumption forName:SDLNameInstantFuelConsumption];
}

- (NSNumber<SDLFloat> *)instantFuelConsumption {
    return [parameters objectForKey:SDLNameInstantFuelConsumption];
}

- (void)setExternalTemperature:(NSNumber<SDLFloat> *)externalTemperature {
    [self setObject:externalTemperature forName:SDLNameExternalTemperature];
}

- (NSNumber<SDLFloat> *)externalTemperature {
    return [parameters objectForKey:SDLNameExternalTemperature];
}

- (void)setVin:(NSString *)vin {
    [self setObject:vin forName:SDLNameVIN];
}

- (NSString *)vin {
    return [parameters objectForKey:SDLNameVIN];
}

- (void)setPrndl:(SDLPRNDL)prndl {
    [self setObject:prndl forName:SDLNamePRNDL];
}

- (SDLPRNDL)prndl {
    NSObject *obj = [parameters objectForKey:SDLNamePRNDL];
    return (SDLPRNDL)obj;
}

- (void)setTirePressure:(SDLTireStatus *)tirePressure {
    [self setObject:tirePressure forName:SDLNameTirePressure];
}

- (SDLTireStatus *)tirePressure {
    NSObject *obj = [parameters objectForKey:SDLNameTirePressure];
    if (obj == nil || [obj isKindOfClass:SDLTireStatus.class]) {
        return (SDLTireStatus *)obj;
    } else {
        return [[SDLTireStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setOdometer:(NSNumber<SDLInt> *)odometer {
    [self setObject:odometer forName:SDLNameOdometer];
}

- (NSNumber<SDLInt> *)odometer {
    return [parameters objectForKey:SDLNameOdometer];
}

- (void)setBeltStatus:(SDLBeltStatus *)beltStatus {
    [self setObject:beltStatus forName:SDLNameBeltStatus];
}

- (SDLBeltStatus *)beltStatus {
    NSObject *obj = [parameters objectForKey:SDLNameBeltStatus];
    if (obj == nil || [obj isKindOfClass:SDLBeltStatus.class]) {
        return (SDLBeltStatus *)obj;
    } else {
        return [[SDLBeltStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setBodyInformation:(SDLBodyInformation *)bodyInformation {
    [self setObject:bodyInformation forName:SDLNameBodyInformation];
}

- (SDLBodyInformation *)bodyInformation {
    NSObject *obj = [parameters objectForKey:SDLNameBodyInformation];
    if (obj == nil || [obj isKindOfClass:SDLBodyInformation.class]) {
        return (SDLBodyInformation *)obj;
    } else {
        return [[SDLBodyInformation alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setDeviceStatus:(SDLDeviceStatus *)deviceStatus {
    [self setObject:deviceStatus forName:SDLNameDeviceStatus];
}

- (SDLDeviceStatus *)deviceStatus {
    NSObject *obj = [parameters objectForKey:SDLNameDeviceStatus];
    if (obj == nil || [obj isKindOfClass:SDLDeviceStatus.class]) {
        return (SDLDeviceStatus *)obj;
    } else {
        return [[SDLDeviceStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setDriverBraking:(SDLVehicleDataEventStatus)driverBraking {
    [self setObject:driverBraking forName:SDLNameDriverBraking];
}

- (SDLVehicleDataEventStatus)driverBraking {
    NSObject *obj = [parameters objectForKey:SDLNameDriverBraking];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setWiperStatus:(SDLWiperStatus)wiperStatus {
    [self setObject:wiperStatus forName:SDLNameWiperStatus];
}

- (SDLWiperStatus)wiperStatus {
    NSObject *obj = [parameters objectForKey:SDLNameWiperStatus];
    return (SDLWiperStatus)obj;
}

- (void)setHeadLampStatus:(SDLHeadLampStatus *)headLampStatus {
    [self setObject:headLampStatus forName:SDLNameHeadLampStatus];
}

- (SDLHeadLampStatus *)headLampStatus {
    NSObject *obj = [parameters objectForKey:SDLNameHeadLampStatus];
    if (obj == nil || [obj isKindOfClass:SDLHeadLampStatus.class]) {
        return (SDLHeadLampStatus *)obj;
    } else {
        return [[SDLHeadLampStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setEngineTorque:(NSNumber<SDLFloat> *)engineTorque {
    [self setObject:engineTorque forName:SDLNameEngineTorque];
}

- (NSNumber<SDLFloat> *)engineTorque {
    return [parameters objectForKey:SDLNameEngineTorque];
}

- (void)setAccPedalPosition:(NSNumber<SDLFloat> *)accPedalPosition {
    [self setObject:accPedalPosition forName:SDLNameAccelerationPedalPosition];
}

- (NSNumber<SDLFloat> *)accPedalPosition {
    return [parameters objectForKey:SDLNameAccelerationPedalPosition];
}

- (void)setSteeringWheelAngle:(NSNumber<SDLFloat> *)steeringWheelAngle {
    [self setObject:steeringWheelAngle forName:SDLNameSteeringWheelAngle];
}

- (NSNumber<SDLFloat> *)steeringWheelAngle {
    return [parameters objectForKey:SDLNameSteeringWheelAngle];
}

- (void)setECallInfo:(SDLECallInfo *)eCallInfo {
    [self setObject:eCallInfo forName:SDLNameECallInfo];
}

- (SDLECallInfo *)eCallInfo {
    NSObject *obj = [parameters objectForKey:SDLNameECallInfo];
    if (obj == nil || [obj isKindOfClass:SDLECallInfo.class]) {
        return (SDLECallInfo *)obj;
    } else {
        return [[SDLECallInfo alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setAirbagStatus:(SDLAirbagStatus *)airbagStatus {
    [self setObject:airbagStatus forName:SDLNameAirbagStatus];
}

- (SDLAirbagStatus *)airbagStatus {
    NSObject *obj = [parameters objectForKey:SDLNameAirbagStatus];
    if (obj == nil || [obj isKindOfClass:SDLAirbagStatus.class]) {
        return (SDLAirbagStatus *)obj;
    } else {
        return [[SDLAirbagStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setEmergencyEvent:(SDLEmergencyEvent *)emergencyEvent {
    [self setObject:emergencyEvent forName:SDLNameEmergencyEvent];
}

- (SDLEmergencyEvent *)emergencyEvent {
    NSObject *obj = [parameters objectForKey:SDLNameEmergencyEvent];
    if (obj == nil || [obj isKindOfClass:SDLEmergencyEvent.class]) {
        return (SDLEmergencyEvent *)obj;
    } else {
        return [[SDLEmergencyEvent alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setClusterModeStatus:(SDLClusterModeStatus *)clusterModeStatus {
    [self setObject:clusterModeStatus forName:SDLNameClusterModeStatus];
}

- (SDLClusterModeStatus *)clusterModeStatus {
    NSObject *obj = [parameters objectForKey:SDLNameClusterModeStatus];
    if (obj == nil || [obj isKindOfClass:SDLClusterModeStatus.class]) {
        return (SDLClusterModeStatus *)obj;
    } else {
        return [[SDLClusterModeStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setMyKey:(SDLMyKey *)myKey {
    [self setObject:myKey forName:SDLNameMyKey];
}

- (SDLMyKey *)myKey {
    NSObject *obj = [parameters objectForKey:SDLNameMyKey];
    if (obj == nil || [obj isKindOfClass:SDLMyKey.class]) {
        return (SDLMyKey *)obj;
    } else {
        return [[SDLMyKey alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end
