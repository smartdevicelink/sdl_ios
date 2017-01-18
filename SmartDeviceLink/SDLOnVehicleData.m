//  SDLOnVehicleData.m
//

#import "SDLOnVehicleData.h"

#import "NSMutableDictionary+Store.h"
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
    [parameters sdl_setObject:gps forName:SDLNameGPS];
}

- (SDLGPSData *)gps {
    NSObject *obj = [parameters sdl_objectForName:SDLNameGPS];
    if (obj == nil || [obj isKindOfClass:SDLGPSData.class]) {
        return (SDLGPSData *)obj;
    } else {
        return [[SDLGPSData alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setSpeed:(NSNumber<SDLFloat> *)speed {
    [parameters sdl_setObject:speed forName:SDLNameSpeed];
}

- (NSNumber<SDLFloat> *)speed {
    return [parameters sdl_objectForName:SDLNameSpeed];
}

- (void)setRpm:(NSNumber<SDLInt> *)rpm {
    [parameters sdl_setObject:rpm forName:SDLNameRPM];
}

- (NSNumber<SDLInt> *)rpm {
    return [parameters sdl_objectForName:SDLNameRPM];
}

- (void)setFuelLevel:(NSNumber<SDLFloat> *)fuelLevel {
    [parameters sdl_setObject:fuelLevel forName:SDLNameFuelLevel];
}

- (NSNumber<SDLFloat> *)fuelLevel {
    return [parameters sdl_objectForName:SDLNameFuelLevel];
}

- (void)setFuelLevel_State:(SDLComponentVolumeStatus)fuelLevel_State {
    [parameters sdl_setObject:fuelLevel_State forName:SDLNameFuelLevelState];
}

- (SDLComponentVolumeStatus)fuelLevel_State {
    NSObject *obj = [parameters sdl_objectForName:SDLNameFuelLevelState];
    return (SDLComponentVolumeStatus)obj;
}

- (void)setInstantFuelConsumption:(NSNumber<SDLFloat> *)instantFuelConsumption {
    [parameters sdl_setObject:instantFuelConsumption forName:SDLNameInstantFuelConsumption];
}

- (NSNumber<SDLFloat> *)instantFuelConsumption {
    return [parameters sdl_objectForName:SDLNameInstantFuelConsumption];
}

- (void)setExternalTemperature:(NSNumber<SDLFloat> *)externalTemperature {
    [parameters sdl_setObject:externalTemperature forName:SDLNameExternalTemperature];
}

- (NSNumber<SDLFloat> *)externalTemperature {
    return [parameters sdl_objectForName:SDLNameExternalTemperature];
}

- (void)setVin:(NSString *)vin {
    [parameters sdl_setObject:vin forName:SDLNameVIN];
}

- (NSString *)vin {
    return [parameters sdl_objectForName:SDLNameVIN];
}

- (void)setPrndl:(SDLPRNDL)prndl {
    [parameters sdl_setObject:prndl forName:SDLNamePRNDL];
}

- (SDLPRNDL)prndl {
    NSObject *obj = [parameters sdl_objectForName:SDLNamePRNDL];
    return (SDLPRNDL)obj;
}

- (void)setTirePressure:(SDLTireStatus *)tirePressure {
    [parameters sdl_setObject:tirePressure forName:SDLNameTirePressure];
}

- (SDLTireStatus *)tirePressure {
    NSObject *obj = [parameters sdl_objectForName:SDLNameTirePressure];
    if (obj == nil || [obj isKindOfClass:SDLTireStatus.class]) {
        return (SDLTireStatus *)obj;
    } else {
        return [[SDLTireStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setOdometer:(NSNumber<SDLInt> *)odometer {
    [parameters sdl_setObject:odometer forName:SDLNameOdometer];
}

- (NSNumber<SDLInt> *)odometer {
    return [parameters sdl_objectForName:SDLNameOdometer];
}

- (void)setBeltStatus:(SDLBeltStatus *)beltStatus {
    [parameters sdl_setObject:beltStatus forName:SDLNameBeltStatus];
}

- (SDLBeltStatus *)beltStatus {
    NSObject *obj = [parameters sdl_objectForName:SDLNameBeltStatus];
    if (obj == nil || [obj isKindOfClass:SDLBeltStatus.class]) {
        return (SDLBeltStatus *)obj;
    } else {
        return [[SDLBeltStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setBodyInformation:(SDLBodyInformation *)bodyInformation {
    [parameters sdl_setObject:bodyInformation forName:SDLNameBodyInformation];
}

- (SDLBodyInformation *)bodyInformation {
    NSObject *obj = [parameters sdl_objectForName:SDLNameBodyInformation];
    if (obj == nil || [obj isKindOfClass:SDLBodyInformation.class]) {
        return (SDLBodyInformation *)obj;
    } else {
        return [[SDLBodyInformation alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setDeviceStatus:(SDLDeviceStatus *)deviceStatus {
    [parameters sdl_setObject:deviceStatus forName:SDLNameDeviceStatus];
}

- (SDLDeviceStatus *)deviceStatus {
    NSObject *obj = [parameters sdl_objectForName:SDLNameDeviceStatus];
    if (obj == nil || [obj isKindOfClass:SDLDeviceStatus.class]) {
        return (SDLDeviceStatus *)obj;
    } else {
        return [[SDLDeviceStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setDriverBraking:(SDLVehicleDataEventStatus)driverBraking {
    [parameters sdl_setObject:driverBraking forName:SDLNameDriverBraking];
}

- (SDLVehicleDataEventStatus)driverBraking {
    NSObject *obj = [parameters sdl_objectForName:SDLNameDriverBraking];
    return (SDLVehicleDataEventStatus)obj;
}

- (void)setWiperStatus:(SDLWiperStatus)wiperStatus {
    [parameters sdl_setObject:wiperStatus forName:SDLNameWiperStatus];
}

- (SDLWiperStatus)wiperStatus {
    NSObject *obj = [parameters sdl_objectForName:SDLNameWiperStatus];
    return (SDLWiperStatus)obj;
}

- (void)setHeadLampStatus:(SDLHeadLampStatus *)headLampStatus {
    [parameters sdl_setObject:headLampStatus forName:SDLNameHeadLampStatus];
}

- (SDLHeadLampStatus *)headLampStatus {
    NSObject *obj = [parameters sdl_objectForName:SDLNameHeadLampStatus];
    if (obj == nil || [obj isKindOfClass:SDLHeadLampStatus.class]) {
        return (SDLHeadLampStatus *)obj;
    } else {
        return [[SDLHeadLampStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setEngineTorque:(NSNumber<SDLFloat> *)engineTorque {
    [parameters sdl_setObject:engineTorque forName:SDLNameEngineTorque];
}

- (NSNumber<SDLFloat> *)engineTorque {
    return [parameters sdl_objectForName:SDLNameEngineTorque];
}

- (void)setAccPedalPosition:(NSNumber<SDLFloat> *)accPedalPosition {
    [parameters sdl_setObject:accPedalPosition forName:SDLNameAccelerationPedalPosition];
}

- (NSNumber<SDLFloat> *)accPedalPosition {
    return [parameters sdl_objectForName:SDLNameAccelerationPedalPosition];
}

- (void)setSteeringWheelAngle:(NSNumber<SDLFloat> *)steeringWheelAngle {
    [parameters sdl_setObject:steeringWheelAngle forName:SDLNameSteeringWheelAngle];
}

- (NSNumber<SDLFloat> *)steeringWheelAngle {
    return [parameters sdl_objectForName:SDLNameSteeringWheelAngle];
}

- (void)setECallInfo:(SDLECallInfo *)eCallInfo {
    [parameters sdl_setObject:eCallInfo forName:SDLNameECallInfo];
}

- (SDLECallInfo *)eCallInfo {
    NSObject *obj = [parameters sdl_objectForName:SDLNameECallInfo];
    if (obj == nil || [obj isKindOfClass:SDLECallInfo.class]) {
        return (SDLECallInfo *)obj;
    } else {
        return [[SDLECallInfo alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setAirbagStatus:(SDLAirbagStatus *)airbagStatus {
    [parameters sdl_setObject:airbagStatus forName:SDLNameAirbagStatus];
}

- (SDLAirbagStatus *)airbagStatus {
    NSObject *obj = [parameters sdl_objectForName:SDLNameAirbagStatus];
    if (obj == nil || [obj isKindOfClass:SDLAirbagStatus.class]) {
        return (SDLAirbagStatus *)obj;
    } else {
        return [[SDLAirbagStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setEmergencyEvent:(SDLEmergencyEvent *)emergencyEvent {
    [parameters sdl_setObject:emergencyEvent forName:SDLNameEmergencyEvent];
}

- (SDLEmergencyEvent *)emergencyEvent {
    NSObject *obj = [parameters sdl_objectForName:SDLNameEmergencyEvent];
    if (obj == nil || [obj isKindOfClass:SDLEmergencyEvent.class]) {
        return (SDLEmergencyEvent *)obj;
    } else {
        return [[SDLEmergencyEvent alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setClusterModeStatus:(SDLClusterModeStatus *)clusterModeStatus {
    [parameters sdl_setObject:clusterModeStatus forName:SDLNameClusterModeStatus];
}

- (SDLClusterModeStatus *)clusterModeStatus {
    NSObject *obj = [parameters sdl_objectForName:SDLNameClusterModeStatus];
    if (obj == nil || [obj isKindOfClass:SDLClusterModeStatus.class]) {
        return (SDLClusterModeStatus *)obj;
    } else {
        return [[SDLClusterModeStatus alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setMyKey:(SDLMyKey *)myKey {
    [parameters sdl_setObject:myKey forName:SDLNameMyKey];
}

- (SDLMyKey *)myKey {
    NSObject *obj = [parameters sdl_objectForName:SDLNameMyKey];
    if (obj == nil || [obj isKindOfClass:SDLMyKey.class]) {
        return (SDLMyKey *)obj;
    } else {
        return [[SDLMyKey alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end
