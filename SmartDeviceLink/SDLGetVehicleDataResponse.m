//  SDLGetVehicleDataResponse.m
//


#import "SDLGetVehicleDataResponse.h"

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


@implementation SDLGetVehicleDataResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameGetVehicleData]) {
    }
    return self;
}

- (void)setGps:(SDLGPSData *)gps {
    [parameters sdl_setObject:gps forName:SDLNameGPS];
}

- (SDLGPSData *)gps {
    return [parameters sdl_objectForName:SDLNameGPS ofClass:SDLGPSData.class];
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
    return [parameters sdl_objectForName:SDLNameFuelLevelState];
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
    return [parameters sdl_objectForName:SDLNamePRNDL];
}

- (void)setTirePressure:(SDLTireStatus *)tirePressure {
    [parameters sdl_setObject:tirePressure forName:SDLNameTirePressure];
}

- (SDLTireStatus *)tirePressure {
    return [parameters sdl_objectForName:SDLNameTirePressure ofClass:SDLTireStatus.class];
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
    return [parameters sdl_objectForName:SDLNameBeltStatus ofClass:SDLBeltStatus.class];
}

- (void)setBodyInformation:(SDLBodyInformation *)bodyInformation {
    [parameters sdl_setObject:bodyInformation forName:SDLNameBodyInformation];
}

- (SDLBodyInformation *)bodyInformation {
    return [parameters sdl_objectForName:SDLNameBodyInformation ofClass:SDLBodyInformation.class];
}

- (void)setDeviceStatus:(SDLDeviceStatus *)deviceStatus {
    [parameters sdl_setObject:deviceStatus forName:SDLNameDeviceStatus];
}

- (SDLDeviceStatus *)deviceStatus {
    return [parameters sdl_objectForName:SDLNameDeviceStatus ofClass:SDLDeviceStatus.class];
}

- (void)setDriverBraking:(SDLVehicleDataEventStatus)driverBraking {
    [parameters sdl_setObject:driverBraking forName:SDLNameDriverBraking];
}

- (SDLVehicleDataEventStatus)driverBraking {
    return [parameters sdl_objectForName:SDLNameDriverBraking];
}

- (void)setWiperStatus:(SDLWiperStatus)wiperStatus {
    [parameters sdl_setObject:wiperStatus forName:SDLNameWiperStatus];
}

- (SDLWiperStatus)wiperStatus {
    return [parameters sdl_objectForName:SDLNameWiperStatus];
}

- (void)setHeadLampStatus:(SDLHeadLampStatus *)headLampStatus {
    [parameters sdl_setObject:headLampStatus forName:SDLNameHeadLampStatus];
}

- (SDLHeadLampStatus *)headLampStatus {
    return [parameters sdl_objectForName:SDLNameHeadLampStatus ofClass:SDLHeadLampStatus.class];
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
    return [parameters sdl_objectForName:SDLNameECallInfo ofClass:SDLECallInfo.class];
}

- (void)setAirbagStatus:(SDLAirbagStatus *)airbagStatus {
    [parameters sdl_setObject:airbagStatus forName:SDLNameAirbagStatus];
}

- (SDLAirbagStatus *)airbagStatus {
    return [parameters sdl_objectForName:SDLNameAirbagStatus ofClass:SDLAirbagStatus.class];
}

- (void)setEmergencyEvent:(SDLEmergencyEvent *)emergencyEvent {
    [parameters sdl_setObject:emergencyEvent forName:SDLNameEmergencyEvent];
}

- (SDLEmergencyEvent *)emergencyEvent {
    return [parameters sdl_objectForName:SDLNameEmergencyEvent ofClass:SDLEmergencyEvent.class];
}

- (void)setClusterModeStatus:(SDLClusterModeStatus *)clusterModeStatus {
    [parameters sdl_setObject:clusterModeStatus forName:SDLNameClusterModeStatus];
}

- (SDLClusterModeStatus *)clusterModeStatus {
    return [parameters sdl_objectForName:SDLNameClusterModeStatus ofClass:SDLClusterModeStatus.class];
}

- (void)setMyKey:(SDLMyKey *)myKey {
    [parameters sdl_setObject:myKey forName:SDLNameMyKey];
}

- (SDLMyKey *)myKey {
    return [parameters sdl_objectForName:SDLNameMyKey ofClass:SDLMyKey.class];
}

@end
